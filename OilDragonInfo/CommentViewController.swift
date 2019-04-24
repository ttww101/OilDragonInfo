
import UIKit
import Cosmos
import AVOSCloud

class CommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    weak var delegate: buttonIsClick?
    
    var shop: Shop?

    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var commentsList: UITableView!
    @IBOutlet weak var commentsTextfield: UITextField!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        storeName.text = shop?.name ?? "name"
        phone.text = shop?.phone ?? "phone"
        address.text = shop?.address ?? "address"
        ratingView.rating = Double(self.shop?.rate?[UserDefaults.standard.value(forKey:UserDefaultKeys.uuid) as! String] ?? "") ?? 0
        commentsTextfield.placeholder = "請留下您的評論"
        submitBtn.layer.cornerRadius = 10

        ratingView.didTouchCosmos = didTouchCosmos

        commentsList.delegate = self
        commentsList.dataSource = self
        commentsList.separatorStyle = .none

        setUp()
        commentsList.rowHeight = UITableView.automaticDimension
        commentsList.estimatedRowHeight = 77
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shop?.comments?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier, for: indexPath) as? CommentTableViewCell
        else { return UITableViewCell() }

        cell.userComment.text = self.shop?.comments?[indexPath.row]
        cell.commentView.layer.cornerRadius = 10
        return cell
    }

    func setUp() {
        let commentDetailNib = UINib(nibName: CommentTableViewCell.identifier, bundle: nil)
        commentsList.register(commentDetailNib, forCellReuseIdentifier: CommentTableViewCell.identifier)

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @IBAction func submitBtn(_ sender: Any) {
        
        //empty
        let alertController = UIAlertController(title: "系統提示", message: "您尚未填入任何評論", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "確定", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        
        guard let addText = commentsTextfield.text else {
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        if commentsTextfield.text == "" {
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        guard let store = shop else { return }
        
        let object = AVObject(className: AVOSKey.storeClassName, objectId: store.objectID)
        
        var updateComments: [String] = []
        
        if let comments = store.comments {
            updateComments += comments
        }
        updateComments += [addText]
            
        object.setObject(updateComments, forKey: "comments")
        self.shop?.comments = updateComments
        self.commentsTextfield.text = ""
            
        _ = object.save()
        
        self.tableView.reloadData()
    }
    
    // close keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // move to last cell
    func moveToLastComment() {
        if commentsList.contentSize.height > commentsList.frame.height {
            // First figure out how many sections there are
            let lastSectionIndex = commentsList.numberOfSections - 1
            // Then grab the number of rows in the last section
            let lastRowIndex = commentsList.numberOfRows(inSection: lastSectionIndex) - 1
            // Now just construct the index path
            let pathToLastRow = NSIndexPath(row: lastRowIndex, section: lastSectionIndex)
            // Make the last row visible
            commentsList.scrollToRow(at: pathToLastRow as IndexPath, at: UITableView.ScrollPosition.bottom, animated: true)
        }
    }
    
    private func didTouchCosmos(_ rating: Double) {
        
        if let shop = self.shop, var _ = shop.rate {
            self.shop?.rate?[UserDefaults.standard.value(forKey:UserDefaultKeys.uuid) as! String] = "\(rating)"
        } else {
            self.shop?.rate = [UserDefaults.standard.value(forKey:UserDefaultKeys.uuid) as! String : "\(rating)"]
        }
        
        guard let store = shop else { return }
        
        let object = AVObject(className: AVOSKey.storeClassName, objectId: store.objectID)
        
        object.setObject(self.shop?.rate, forKey: "rate")
        
        _ = object.save()
        
        DispatchQueue.main.async {
            self.delegate?.detectIsClick()
        }
    }

}
