import Foundation
import WebKit

protocol CleanData {
    func cleanData()
}

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    let services: [CleanData] = [ProfileService.shared, ProfileImageService.shared, ImagesListService.shared, OAuth2TokenStorage.shared]
    
    private init() { }
    
    func logout() {
        cleanCookies()
        cleanServicesData()
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    private func cleanServicesData() {
        services.forEach { service in
            service.cleanData()
        }
    }
}

