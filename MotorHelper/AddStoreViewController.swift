//
//  AddStoreViewController.swift
//  MotorHelper
//
//  Created by 孟軒蕭 on 13/04/2017.
//  Copyright © 2017 MichaelXiao. All rights reserved.
//

import UIKit
import Cosmos
import AVOSCloud

protocol buttonIsClick: class {
    func detectIsClick()
}

class AddStoreViewController: UIViewController {

    weak var delegate: buttonIsClick?
    let userID = ""
    let userMail = ""

    @IBOutlet weak var storePhoneNumber: UITextField!
    @IBOutlet weak var storeAddressTextfield: UITextField!
    @IBOutlet weak var storeNameTextfield: UITextField!
    @IBOutlet weak var storeRate: CosmosView!
    @IBOutlet weak var storeComments: UITextView!
    @IBOutlet weak var submitStore: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
//        AVOSCloud.setApplicationId("IsDkIby9Jnpu9Seds1I1Xyy0-gzGzoHsz", clientKey: "YveFWt3T9vWet4A9nCxLELdQ")
        
        storeNameTextfield.placeholder = "請輸入車行名稱(必填)"
        storeAddressTextfield.placeholder = "請輸入車行地址(必填)"
        storePhoneNumber.keyboardType = .numberPad
        storePhoneNumber.clearButtonMode = .whileEditing
        storePhoneNumber.placeholder = "請輸入車行電話"
        submitStore.layer.cornerRadius = 25

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func submitBtn(_ sender: Any) {
        
        let object = AVObject(className: AVOSKey.storeClassName)
        
        if storeNameTextfield.text?.count != 0 && storeAddressTextfield.text?.count != 0 {

            object.setObject(storeAddressTextfield.text, forKey: "address")
            object.setObject(storePhoneNumber.text, forKey: "phone")
            object.setObject(storeNameTextfield.text, forKey: "name")
            object.setObject("\(storeRate.rating)", forKey: "rate")
            object.setObject([storeComments.text], forKey: "comments")
            
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
