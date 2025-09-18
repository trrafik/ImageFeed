import UIKit

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

final class ImagesListService {
    static let shared = ImagesListService()
    
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private var task: URLSessionTask?
    private let perPage = 10
    private let dateFormatter = ISO8601DateFormatter()
    
    private enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case patch = "PATCH"
        case delete = "DELETE"
    }
    
    func fetchPhotosNextPage() {
        task?.cancel()
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        guard let request = makeRequest(page: nextPage, perPage: perPage) else {
            print("[ImageListService: fetchPhotosNextPage]: Ошибка - не удалось создать запрос")
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            switch result {
            case .success(let results):
                let photo = results.map { result in
                    Photo(
                        id: result.id,
                        size: CGSize(width: result.width, height: result.height),
                        createdAt: self?.dateFormatter.date(from: result.createdAt),
                        welcomeDescription: result.description,
                        thumbImageURL: result.urls.thumb,
                        largeImageURL: result.urls.full,
                        isLiked: result.likedByUser
                    )
                }

                self?.photos.append(contentsOf: photo)
                self?.lastLoadedPage = nextPage
                NotificationCenter.default.post(
                    name: ImagesListService.didChangeNotification,
                    object: self
                )

            case .failure(let error):
                print("[ImagesListService]: Ошибка запроса/декодирования - \(error.localizedDescription)")
            }
            self?.task = nil
        }
        self.task = task
        task.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        task?.cancel()
        
        guard let request = makeLikeRequest(photoId: photoId, isLiked: isLike) else {
            print("[ImageListService: changeLike]: Ошибка - не удалось создать запрос")
            return
        }
        let task = URLSession.shared.objectTask(for: request) {[weak self] (result: Result<LikePhotoResult, Error>) in
            guard let self else {return}
            switch result {
            case .success(let photoResult):
                if let index = self.photos.firstIndex(where: {$0.id == photoId}) {
                    let photo = self.photos[index]
                    let newPhoto = Photo(id: photo.id,
                                         size: photo.size,
                                         createdAt: photo.createdAt,
                                         welcomeDescription: photo.welcomeDescription,
                                         thumbImageURL: photo.thumbImageURL,
                                         largeImageURL: photo.largeImageURL,
                                         isLiked: !photo.isLiked
                    )
                    self.photos[index] = newPhoto
                }
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    
    private func makeRequest(page: Int, perPage: Int) -> URLRequest? {
        guard let token = OAuth2TokenStorage.shared.token else {
            print("[ImagesListService: makeRequest]: Ошибка - отсутствует токен")
            return nil
        }
        
        var components = URLComponents(string: "\(Constants.defaultBaseURLString)/photos")
        components?.queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "per_page", value: String(perPage))
        ]
        
        guard let url = components?.url else {
            print("[ImagesListService: makeRequest]: Ошибка - неверный URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func makeLikeRequest(photoId: String, isLiked: Bool) -> URLRequest? {
        guard let token = OAuth2TokenStorage.shared.token else {
            print("[ImagesListService: makeLikeRequest]: Ошибка - отсутствует токен")
            return nil
        }
        
        let components = URLComponents(string: "\(Constants.defaultBaseURLString)/photos/\(photoId)/like")
        
        guard let url = components?.url else {
            print("[ImagesListService: makeLikeRequest]: Ошибка - неверный URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = isLiked ? HTTPMethod.delete.rawValue : HTTPMethod.post.rawValue
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}

extension ImagesListService: CleanData {
    func cleanData() {
        photos = []
        lastLoadedPage = nil
        task?.cancel()
        task = nil
    }
}
