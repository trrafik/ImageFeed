import UIKit
import Kingfisher

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListViewPresenterProtocol? { get set }
    
    func updateTableViewAnimated(indexPaths: [IndexPath]?)
    func showErrorAlert()
}

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {

    @IBOutlet private var tableView: UITableView!
    
    var presenter: ImagesListViewPresenterProtocol?
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 200
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        presenter?.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier,
           let vc = segue.destination as? SingleImageViewController,
           let indexPath = sender as? IndexPath {
            let photo = presenter?.photo(at: indexPath.row)
            vc.imageURL = URL(string: photo?.largeImageURL ?? "")
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func showAlertError() {
        let alert = UIAlertController(
            title: "Произошла ошибка",
            message: "Не удалось изменить состояние лайка",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let photo = presenter?.photo(at: indexPath.row) else { return }
        
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(with: URL(string: photo.thumbImageURL),
                                   placeholder: UIImage(named: "cell_placeholder")) { [weak self] _ in
            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        cell.dateLabel.text = presenter?.formattedDate(for: photo)
        
        let likeImage = photo.isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        cell.likeButton.setImage(likeImage, for: .normal)
        cell.selectionStyle = .none
        cell.delegate = self
    }
}

extension ImagesListViewController {
    func updateTableViewAnimated(indexPaths: [IndexPath]?) {
        guard let indexPaths = indexPaths else {
            tableView.reloadData()
            return
        }
        tableView.performBatchUpdates {
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
    func showErrorAlert() {
        showAlertError()
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.numberOfPhotos() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) as? ImagesListCell else {
            return UITableViewCell()
        }
        configCell(for: cell, with: indexPath)
        return cell
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        presenter?.heightForPhoto(at: indexPath.row, tableViewWidth: tableView.bounds.width) ?? 200
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let count = presenter?.numberOfPhotos(), indexPath.row + 1 == count {
            presenter?.fetchNextPage()
        }
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        UIBlockingProgressHUD.show()
        presenter?.didTapLike(at: indexPath.row) { [weak self] success in
            UIBlockingProgressHUD.dismiss()
            if success {
                if let photo = self?.presenter?.photo(at: indexPath.row) {
                    cell.setIsLiked(photo.isLiked)
                }
            } else {
                self?.showErrorAlert()
            }
        }
    }
}
