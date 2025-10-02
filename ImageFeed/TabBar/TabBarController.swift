import UIKit

final class TabBarController: UITabBarController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imageListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController")
        
        let imagesListViewPresenter = ImagesListViewPresenter()
        (imageListViewController as? ImagesListViewControllerProtocol)?.presenter = imagesListViewPresenter
        imagesListViewPresenter.view = (imageListViewController as? ImagesListViewControllerProtocol)
        
        let profileViewController = ProfileViewController()
        let profileViewPresenter = ProfileViewPresenter()
        profileViewController.presenter = profileViewPresenter
        profileViewPresenter.view = profileViewController
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(resource: .tabProfileActive),
            selectedImage: nil
        )
        
        viewControllers = [imageListViewController, profileViewController]
    }
}
