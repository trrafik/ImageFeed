import XCTest
@testable import ImageFeed

// MARK: - Тесты для Presenter
final class ProfileViewTests: XCTestCase {

    func testPresenterShowLogoutAlert() {
        // Given
        let presenter = ProfileViewPresenter()
        let viewSpy = ProfileViewControllerSpy()
        presenter.view = viewSpy
        
        presenter.didTapLogout()
        
        XCTAssertTrue(viewSpy.showLogoutAlertCalled)
    }

    func testPresenterCallsViewDidLoad() {
        let presenter = ProfileViewPresenter()
        let viewSpy = ProfileViewControllerSpy()
        presenter.view = viewSpy
        
        XCTAssertNoThrow(presenter.viewDidLoad())
    }
    
    func testViewControllerCallsViewDidLoad() {
        let viewController = ProfileViewController()
        let presenterSpy = ProfilePresenterSpy()
        viewController.presenter = presenterSpy
        presenterSpy.view = viewController

        _ = viewController.view
        
        XCTAssertTrue(presenterSpy.viewDidLoadCalled)
    }
}
