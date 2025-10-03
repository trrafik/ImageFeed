import UIKit

protocol ImagesListViewPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    
    func viewDidLoad()
    func fetchNextPage()
    func numberOfPhotos() -> Int
    func photo(at index: Int) -> Photo
    func heightForPhoto(at index: Int, tableViewWidth: CGFloat) -> CGFloat
    func didTapLike(at index: Int, completion: @escaping (Bool) -> Void)
    func formattedDate(for photo: Photo) -> String
}

final class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
    
    weak var view: ImagesListViewControllerProtocol?
    
    private let imagesListService = ImagesListService.shared
    private var photos: [Photo] = []
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    private var observer: NSObjectProtocol?
    
    init() {
        observer = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.didReceiveNewPhotos()
        }
    }
    
    deinit {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    func viewDidLoad() {
        fetchNextPage()
    }
    
    func fetchNextPage() {
        imagesListService.fetchPhotosNextPage()
    }
    
    func numberOfPhotos() -> Int {
        return photos.count
    }
    
    func photo(at index: Int) -> Photo {
        return photos[index]
    }
    
    func heightForPhoto(at index: Int, tableViewWidth: CGFloat) -> CGFloat {
        let photo = photos[index]
        let insets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let width = tableViewWidth - insets.left - insets.right
        let scale = width / photo.size.width
        return photo.size.height * scale + insets.top + insets.bottom
    }
    
    func didTapLike(at index: Int, completion: @escaping (Bool) -> Void) {
        let photo = photos[index]
        imagesListService.changeLike(photoId: photo.id, isLike: photo.isLiked) { [weak self] result in
            switch result {
            case .success:
                self?.photos = self?.imagesListService.photos ?? []
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
    
    func formattedDate(for photo: Photo) -> String {
        return dateFormatter.string(from: photo.createdAt ?? Date())
    }
    
    private func didReceiveNewPhotos() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        
        if newCount > oldCount {
            let indexPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
            view?.updateTableViewAnimated(indexPaths: indexPaths)
        } else {
            view?.updateTableViewAnimated(indexPaths: nil)
        }
    }
}
