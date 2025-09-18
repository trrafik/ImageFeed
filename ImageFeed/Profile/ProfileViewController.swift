import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    private let avatarImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 23.0, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private let loginNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13.0)
        label.textColor = UIColor(red: 174/255.0, green: 175/255.0, blue: 180/255.0, alpha: 1)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13.0)
        label.textColor = .white
        return label
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(named: "logout_button") ?? UIImage(),
            target: self,
            action: #selector(Self.didTapButton)
        )
        button.tintColor = UIColor(red: 245/255.0, green: 107/255.0, blue: 108/255.0, alpha: 1)
        return button
    }()
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(resource: .ypBlack)
        
        [avatarImageView,
         nameLabel,
         loginNameLabel,
         descriptionLabel,
         logoutButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        setupСonstraints()
        
        if let profile = ProfileService.shared.profile {
            updateProfileDetails(profile: profile)
        }
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
    }
    private func updateProfileDetails(profile: Profile) {
        nameLabel.text = profile.name.isEmpty
            ? "Имя не указано"
            : profile.name
        loginNameLabel.text = profile.loginName.isEmpty
            ? "@неизвестный_пользователь"
            : profile.loginName
        descriptionLabel.text = (profile.bio?.isEmpty ?? true)
            ? "Профиль не заполнен"
            : profile.bio
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        print("imageUrl: \(url)")

        let placeholderImage = UIImage(systemName: "person.circle.fill")?
            .withTintColor(.lightGray, renderingMode: .alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 70, weight: .regular))

        let processor = RoundCornerImageProcessor(cornerRadius: 35) // Радиус для круга
        avatarImageView.kf.indicatorType = .activity
        avatarImageView.kf.setImage(
            with: url,
            placeholder: placeholderImage,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale), // Учитываем масштаб экрана
                .cacheOriginalImage, // Кэшируем оригинал
                .forceRefresh // Игнорируем кэш, чтобы обновить
            ]) { result in

                switch result {
                case .success(let value):
                    print(value.image)
                    print(value.cacheType)
                    print(value.source)
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    @objc
    private func didTapButton() {
        let alertController = UIAlertController(title: "Пока, пока!",
                                                message: "Уверены, что хотите выйти?",
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Нет", style: .default, handler: nil)
        let acceptAction = UIAlertAction(title: "Да", style: .default) {_ in
            ProfileLogoutService.shared.logout()
            guard let window = UIApplication.shared.windows.first else {
                assertionFailure("Invalid Configuration")
                return
            }
            window.rootViewController = SplashViewController()
        }
        
        alertController.addAction(acceptAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
    private func setupСonstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            
            loginNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            
            
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
        ])
    }
    
}
