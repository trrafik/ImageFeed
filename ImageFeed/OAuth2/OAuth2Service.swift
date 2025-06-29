import UIKit

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
}

enum URLConstants {
    static let getTokenURL = "https://unsplash.com/oauth/token"
}

final class OAuth2Service {
    static let shared = OAuth2Service()
    private init() {}
    
    func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: URLConstants.getTokenURL) else {
            print("urlComponents is nil")
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let url = urlComponents.url else {
            print("urlComponents.url is nil")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let request = makeOAuthTokenRequest(code: code) else {
            DispatchQueue.main.async {
                completion(.failure(NSError(domain: "InvalidRequest", code: 0, userInfo: [NSLocalizedDescriptionKey: "Не удалось создать запрос"])))
            }
            return
        }
        
        let task = URLSession.shared.data(for: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let response = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    OAuth2TokenStorage.shared.token = response.accessToken
                    completion(.success(response.accessToken))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
