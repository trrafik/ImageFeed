import UIKit

final class SplashViewController: UIViewController {
    private let storage = OAuth2TokenStorage.shared
    private let showAuthenticationScreenSegueIdentifier = "showAuth"
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = storage.token {
            print("Токен обнаружен: \(token)")
            switchToTabBarController()
        }
        else{
            print("Токен не найден")
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
           
        UIView.transition(with: window, duration: 0.7, options: .transitionFlipFromRight) {
            window.rootViewController = tabBarController
        }

    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                assertionFailure("Failed to prepare for \(showAuthenticationScreenSegueIdentifier)")
                return
            }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
            }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        //vc.dismiss(animated: true) ЗАЧЕМ????
        switchToTabBarController()
    }
}
