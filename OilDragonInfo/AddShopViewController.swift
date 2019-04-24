
import UIKit
import Cosmos
import AVOSCloud

protocol buttonIsClick: class {
    func detectIsClick()
}

class AddShopViewController: UIViewController, UITextViewDelegate {

    weak var delegate: buttonIsClick?

    @IBOutlet weak var storePhoneNumber: UITextField!
    @IBOutlet weak var storeAddressTextfield: UITextField!
    @IBOutlet weak var storeNameTextfield: UITextField!
    @IBOutlet weak var storeRate: CosmosView!
    @IBOutlet weak var storeComments: UITextView!
    @IBOutlet weak var submitStore: UIButton!
    var navigationRightButton: UIBarButtonItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        storeNameTextfield.placeholder = "請輸入車行名稱(必填)"
        storeAddressTextfield.placeholder = "請輸入車行地址(必填)"
        storePhoneNumber.keyboardType = .numberPad
        storePhoneNumber.clearButtonMode = .whileEditing
        storePhoneNumber.placeholder = "請輸入車行電話"
        submitStore.layer.cornerRadius = 10

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        storeComments.delegate = self
        navigationRightButton = UIBarButtonItem(title: "完成", style: .done, target: self, action: #selector(doneButtonTapped))
        
    }
    
    @objc func doneButtonTapped() {
        self.view.endEditing(true)
        self.navigationItem.rightBarButtonItem = nil
    }
    
    @IBAction func submitBtn(_ sender: Any) {
        
        let object = AVObject(className: AVOSKey.storeClassName)
        
        if storeNameTextfield.text?.count != 0 && storeAddressTextfield.text?.count != 0 {

            object.setObject(storeAddressTextfield.text, forKey: "address")
            object.setObject(storePhoneNumber.text, forKey: "phone")
            object.setObject(storeNameTextfield.text, forKey: "name")
            if storeComments.text == "" {
                object.setObject([], forKey: "comments")
            } else {
                object.setObject([storeComments.text], forKey: "comments")
            }
            object.setObject([UserDefaults.standard.value(forKey:UserDefaultKeys.uuid) as! String : "\(storeRate.rating)"], forKey: "rate")
            
            _ = object.save()
            
            DispatchQueue.main.async {
                self.delegate?.detectIsClick()
            }
            cleanTextField()
            _ = self.navigationController?.popViewController(animated: true)
        } else {
            let alertController = UIAlertController(title: "請完成必填欄位", message: "請按確認繼續", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "確認", style: .cancel, handler: nil)
            alertController.addAction(confirmAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func cleanTextField() {
        storePhoneNumber.text = ""
        storeAddressTextfield.text = ""
        storeNameTextfield.text = ""
        storeComments.text = ""
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension AddShopViewController {
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.navigationItem.rightBarButtonItem = self.navigationRightButton
    }
}
