import Foundation

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private init() {}
    
    private let userDefaults = UserDefaults.standard
    private let tokenKey = "access_token"
    
    var token: String? {
        get {
            return userDefaults.string(forKey: tokenKey)
        }
        set {
            userDefaults.set(newValue, forKey: tokenKey)
        }
    }
}
