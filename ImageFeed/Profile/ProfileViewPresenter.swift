import Foundation

protocol ProfileViewPresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }

    func viewDidLoad()
    func didTapLogout()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    weak var view: ProfileViewControllerProtocol?

    func viewDidLoad() {
        if let profile = ProfileService.shared.profile {
            let name = profile.name.isEmpty ? "Имя не указано" : profile.name
            let login = profile.loginName.isEmpty ? "@неизвестный_пользователь" : profile.loginName
            let bio = (profile.bio?.isEmpty ?? true) ? "Профиль не заполнен" : (profile.bio ?? "")
            view?.updateProfile(name: name, login: login, bio: bio)
        }

        if let profileImageURL = ProfileImageService.shared.avatarURL,
           let url = URL(string: profileImageURL) {
            view?.updateAvatar(with: url)
        }

        NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            if let profileImageURL = ProfileImageService.shared.avatarURL,
               let url = URL(string: profileImageURL) {
                self.view?.updateAvatar(with: url)
            }
        }
    }

    func didTapLogout() {
        view?.showLogoutAlert()
    }
}

