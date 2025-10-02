@testable import ImageFeed
import Foundation

final class ProfilePresenterSpy: ProfileViewPresenterProtocol {
    weak var view: ProfileViewControllerProtocol?

    private(set) var viewDidLoadCalled = false
    private(set) var didTapLogoutCalled = false

    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    func didTapLogout() {
        didTapLogoutCalled = true
    }
}
