import UIKit
@testable import ImageFeed

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {

    var presenter: ImagesListViewPresenterProtocol?
    
    // Spy свойства
    private(set) var updateTableViewCalled = false
    private(set) var lastIndexPaths: [IndexPath]? = nil
    private(set) var showErrorAlertCalled = false
    
    func updateTableViewAnimated(indexPaths: [IndexPath]?) {
        updateTableViewCalled = true
        lastIndexPaths = indexPaths
    }
    
    func showErrorAlert() {
        showErrorAlertCalled = true
    }
}
