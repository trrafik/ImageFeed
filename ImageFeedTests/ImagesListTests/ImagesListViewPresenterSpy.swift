import UIKit
@testable import ImageFeed

final class ImagesListViewPresenterSpy: ImagesListViewPresenterProtocol {

    weak var view: ImagesListViewControllerProtocol?
    
    // Spy свойства
    private(set) var viewDidLoadCalled = false
    private(set) var fetchNextPageCalled = false
    private(set) var didTapLikeCalled = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func fetchNextPage() {
        fetchNextPageCalled = true
    }
    
    func numberOfPhotos() -> Int { return 2 }
    
    func photo(at index: Int) -> Photo {
        // возвращаем фиктивное фото
        return Photo(
            id: "\(index)",
            size: CGSize(width: 100, height: 100),
            createdAt: Date(),
            welcomeDescription: nil,
            thumbImageURL: "thumb\(index)",
            largeImageURL: "large\(index)",
            isLiked: false
        )
    }
    
    func heightForPhoto(at index: Int, tableViewWidth: CGFloat) -> CGFloat {
        return 200
    }
    
    func didTapLike(at index: Int, completion: @escaping (Bool) -> Void) {
        didTapLikeCalled = true
        completion(true)
    }
    
    func formattedDate(for photo: Photo) -> String {
        return "01 января 1970"
    }
}
