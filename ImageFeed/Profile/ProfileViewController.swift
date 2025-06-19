import UIKit

final class ProfileViewController: UIViewController {
    private let avatarImageView: UIImageView = {
        let view = UIImageView()
        let image = UIImage(named: "avatar")
        view.image = image
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.font = UIFont.systemFont(ofSize: 23.0, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private let loginNameLabel: UILabel = {
        let label = UILabel()
        label.text = "@ekaterina_nov"
        label.font = UIFont.systemFont(ofSize: 13.0)
        label.textColor = UIColor(red: 174/255.0, green: 175/255.0, blue: 180/255.0, alpha: 1)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello, world!"
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [avatarImageView,
         nameLabel,
         loginNameLabel,
         descriptionLabel,
         logoutButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        setupСonstraints()
    }
    
    @objc
    private func didTapButton() {
        // TODO: - Добавить логику при нажатии на кнопку
        // временное решение для очистки токена авторизации
        print("Токен: \(OAuth2TokenStorage.shared.token ?? "Токен не найден")")
        UserDefaults.standard.removeObject(forKey: "access_token")
        if UserDefaults.standard.object(forKey: "access_token") == nil {
            print("Токен успешно удален")
        }
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
