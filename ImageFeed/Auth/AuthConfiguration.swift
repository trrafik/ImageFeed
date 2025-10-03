import Foundation

enum Constants {
    static let accessKey = "eqXcRV2QssNENj9OVow9T_yDTEgl2s4jEm-2ZxpVCe4"
    static let secretKey = "rb26m68wrAlaC0YZwhGt5zUkR7As2Lf7q4CfZiG2jk8"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    
    static let defaultBaseURLString = "https://api.unsplash.com"
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURLString: String
    let authURLString: String
    
    static var standard: AuthConfiguration {
        AuthConfiguration(accessKey: Constants.accessKey,
                          secretKey: Constants.secretKey,
                          redirectURI: Constants.redirectURI,
                          accessScope: Constants.accessScope,
                          defaultBaseURLString: Constants.defaultBaseURLString,
                          authURLString: Constants.unsplashAuthorizeURLString)
    }
}
