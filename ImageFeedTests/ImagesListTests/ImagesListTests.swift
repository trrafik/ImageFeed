import XCTest
@testable import ImageFeed

final class ImagesListTests: XCTestCase {

    func testViewControllerCallsPresenterViewDidLoad() {
        // Arrange
        let presenterSpy = ImagesListViewPresenterSpy()
        let viewSpy = ImagesListViewControllerSpy()
        viewSpy.presenter = presenterSpy
        presenterSpy.view = viewSpy
        
        // Act
        viewSpy.presenter?.viewDidLoad()
        
        // Assert
        XCTAssertTrue(presenterSpy.viewDidLoadCalled)
    }
    
    func testPresenterNotifiesView() {
        let viewSpy = ImagesListViewControllerSpy()
        let presenter = ImagesListViewPresenterSpy()
        viewSpy.presenter = presenter
        presenter.view = viewSpy
        
        presenter.fetchNextPage()
        
        XCTAssertTrue(presenter.fetchNextPageCalled)
    }
    
    func testUpdateTableViewCalledOnViewSpy() {
        let viewSpy = ImagesListViewControllerSpy()
        
        viewSpy.updateTableViewAnimated(indexPaths: [IndexPath(row: 0, section: 0)])
        
        XCTAssertTrue(viewSpy.updateTableViewCalled)
        XCTAssertEqual(viewSpy.lastIndexPaths?.first?.row, 0)
    }
    
    func testShowErrorAlertCalledOnViewSpy() {
        let viewSpy = ImagesListViewControllerSpy()
        
        viewSpy.showErrorAlert()
        
        XCTAssertTrue(viewSpy.showErrorAlertCalled)
    }
}
