@testable import ImageFeed
import Foundation

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfileViewPresenterProtocol?

    private(set) var updateProfileCalled = false
    private(set) var updateAvatarCalled = false
    private(set) var showLogoutAlertCalled = false

    var name: String?
    var login: String?
    var bio: String?
    var avatarURL: URL?

    func updateProfile(name: String, login: String, bio: String) {
        updateProfileCalled = true
        self.name = name
        self.login = login
        self.bio = bio
    }

    func updateAvatar(with url: URL?) {
        updateAvatarCalled = true
        self.avatarURL = url
    }

    func showLogoutAlert() {
        showLogoutAlertCalled = true
    }
}
