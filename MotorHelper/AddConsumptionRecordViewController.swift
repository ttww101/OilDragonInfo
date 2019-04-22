
import UIKit
import AVOSCloud

protocol submitIsClick: class {
    func detectSubmit(oilRecord: ConsumptionRecord)
}

enum Component {
    case date //日期
    case oilprice //油價
    case numOfOil //加油量
    case totalPrice //總價
    case totalKM //里程數
    case oilType //油品種類
}

class AddConsumptionRecordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var addConsumption: UITableView!
    @IBOutlet weak var addRecordButton: UIButton!
    weak var delegate: submitIsClick?
    let datePicker = UIDatePicker()
    let dateFormatter = DateFormatter()
    var record = ConsumptionRecord(date: "", oilType: "", oilPrice: "", numOfOil: "", totalPrice: "", totalKM: "")
    var oilPrice: [String: String] =
        ["oil92" : "92 無鉛汽油",
         "oil95" : "95 無鉛汽油",
         "oil98" : "98 無鉛汽油",
         "oilSuper" : "柴油"]
    let currentdate = Date()

    // MARK: Property
    let components: [Component] = [ Component.date, Component.oilType, Component.oilprice, Component.numOfOil, Component.totalPrice, Component.totalKM] // index表示位置

    override func viewDidLoad() {
        super.viewDidLoad()

        addConsumption.delegate = self
        addConsumption.dataSource = self

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        self.addRecordButton.addTarget(self, action: #selector(submitBtn), for: .touchUpInside)

        setUp()
    }

    // MARK: Set up
    func setUp() {
        let textNib = UINib(nibName: ConsumptionTextTableViewCell.identifier, bundle: nil)
        addConsumption.register(textNib, forCellReuseIdentifier: ConsumptionTextTableViewCell.identifier)

        let dateNib = UINib(nibName: ConsumptionDateTableViewCell.identifier, bundle: nil)
        addConsumption.register(dateNib, forCellReuseIdentifier: ConsumptionDateTableViewCell.identifier)

        let oilTypeNib = UINib(nibName: ConsumptionSegmentTableViewCell.identifier, bundle: nil)
        addConsumption.register(oilTypeNib, forCellReuseIdentifier: ConsumptionSegmentTableViewCell.identifier)

    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return components.count
    }
    //行數
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let component = components[section]

        print("component:\(component) in section:\(section)")

        switch component {
        case .numOfOil, .oilprice, .totalKM, .totalPrice, .date, .oilType:
            return 1
        }
    }
    //行高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let screenHeight = self.view.frame.height
        let cellHeight: CGFloat = 6.0
        return screenHeight/cellHeight
    }
    //內容
    //swiftlint:disable cyclomatic_complexity
    //swiftlint:disable function_body_length
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let component = components[indexPath.section]

        switch component {
        case Component.oilprice:

            guard let cell = tableView.dequeueReusableCell(withIdentifier: ConsumptionTextTableViewCell.identifier, for: indexPath) as? ConsumptionTextTableViewCell else { return UITableViewCell() }
            cell.contentTextName.text = "油價"
            cell.contentTextField.placeholder = "必填"
            cell.contentTextField.clearButtonMode = .whileEditing
            cell.contentTextField.keyboardType = .numbersAndPunctuation
            cell.contentTextField.returnKeyType = .done
            cell.contentTextField.delegate = self
            cell.index = TextFieldType.oilPrice
            return cell

        case Component.numOfOil:

            guard let cell = tableView.dequeueReusableCell(withIdentifier: ConsumptionTextTableViewCell.identifier, for: indexPath) as? ConsumptionTextTableViewCell else { return UITableViewCell() }
            cell.contentTextName.text = "油量"
            cell.contentTextField.placeholder = "必填"
            cell.contentTextField.clearButtonMode = .whileEditing
            cell.contentTextField.keyboardType = .numbersAndPunctuation
            cell.contentTextField.returnKeyType = .done
            cell.contentTextField.delegate = self
            cell.index = TextFieldType.numOfOil
            return cell

        case Component.totalPrice:

            guard let cell = tableView.dequeueReusableCell(withIdentifier: ConsumptionTextTableViewCell.identifier, for: indexPath) as? ConsumptionTextTableViewCell else { return UITableViewCell() }
            cell.contentTextName.text = "總價"
            cell.contentTextField.placeholder = "必填"
            cell.contentTextField.clearButtonMode = .whileEditing
            cell.contentTextField.keyboardType = .numbersAndPunctuation
            cell.contentTextField.returnKeyType = .done
            cell.contentTextField.delegate = self
            cell.index = TextFieldType.totalPrice
            return cell

        case Component.totalKM:

            guard let cell = tableView.dequeueReusableCell(withIdentifier: ConsumptionTextTableViewCell.identifier, for: indexPath) as? ConsumptionTextTableViewCell else { return UITableViewCell() }
            cell.contentTextName.text = "里程"
            cell.contentTextField.placeholder = "必填"
            cell.contentTextField.clearButtonMode = .whileEditing
            cell.contentTextField.keyboardType = .numbersAndPunctuation
            cell.contentTextField.returnKeyType = .done
            cell.contentTextField.delegate = self
            cell.index = TextFieldType.totalKM
            return cell

        case Component.date:

            guard let cell = tableView.dequeueReusableCell(withIdentifier: ConsumptionTextTableViewCell.identifier, for: indexPath) as? ConsumptionTextTableViewCell else { return UITableViewCell() }

            cell.contentTextName.text = "日期"
            //datepicker
            datePicker.datePickerMode = .date
            datePicker.addTarget(self, action: #selector(AddConsumptionRecordViewController.didSelectedDate), for: .valueChanged)
            let cal = Calendar.current
            let minTime = cal.date(byAdding: .month, value: -3, to: Date())
            datePicker.minimumDate = minTime
            datePicker.maximumDate = Date()
            //toolbar
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            //bar button item
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(dismissKeyboard))
            toolbar.setItems([doneButton], animated: false)
            cell.contentTextField.inputAccessoryView = toolbar
            cell.contentTextField.inputView = datePicker
            //限制date picker的預設地點，但出現一個bug 就是預設不會印在上面，這個需要再嘗試
//            dateFormatter.locale = Locale(identifier: "zh-TW")
//            record.date = dateFormatter.string(from: datePicker.date)
//            cell.contentTextField.text = dateFormatter.string(from: datePicker.date)

            record.date = DateFormatter.localizedString(from: datePicker.date, dateStyle: .long, timeStyle: .none)
            cell.contentTextField.text = DateFormatter.localizedString(from: datePicker.date, dateStyle: .short, timeStyle: .none)

            cell.index = TextFieldType.date
            cell.contentTextField.textAlignment = .center
            cell.contentTextField.delegate = self
            return cell

        case Component.oilType:

            guard let cell = tableView.dequeueReusableCell(withIdentifier: ConsumptionSegmentTableViewCell.identifier, for: indexPath) as? ConsumptionSegmentTableViewCell else { return UITableViewCell() }
            cell.oilTypeSegment.addTarget(self, action: #selector(AddConsumptionRecordViewController.onChange), for: .valueChanged)
            return cell

        }
    }
    // close keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    //get date
    @objc func didSelectedDate(_ sender: Any) {

        if
            let picker = sender as? UIDatePicker,
            picker === datePicker,
            let dateSection = components.index(of: Component.date) {

                let indexPath = IndexPath(row: 0, section: dateSection)
                dateFormatter.dateStyle = .long //formatter樣式
                dateFormatter.timeStyle = .none //不要時間

                let cell = addConsumption.cellForRow(at: indexPath) as? ConsumptionTextTableViewCell

                cell?.contentTextField.text = dateFormatter.string(from: picker.date)
                record.date = dateFormatter.string(from: picker.date)

        }
    }
    //segment
    @objc func onChange(_ sender: UISegmentedControl) {
        if let _ = components.index(of: .oilprice) {
            switch sender.selectedSegmentIndex {
            case 0:
                record.oilType = oilPrice["oil92"]!
            case 1:
                record.oilType = oilPrice["oil95"]!
            case 2:
                record.oilType = oilPrice["oil98"]!
            case 3:
                record.oilType = oilPrice["oilSuper"]!
            default:
                print("default")
            }
        }
    }

}

extension AddConsumptionRecordViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {

    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let cell = textField.superview?.superview as? ConsumptionTextTableViewCell else {return }
        switch cell.index! {
            case .oilPrice:
                record.oilPrice = cell.contentTextField.text!
            case .numOfOil:
                record.numOfOil = cell.contentTextField.text!
                if let oilSection = components.index(of: .totalPrice) {
                    let indexPath = IndexPath(row: 0, section: oilSection)
                    let cell = addConsumption.cellForRow(at: indexPath) as? ConsumptionTextTableViewCell
                    let oilPriceDouble = Double(record.oilPrice)
                    var calc = 0.0
                    if let numOfOilDouble = Double(record.numOfOil) {
                        calc = oilPriceDouble! * numOfOilDouble
                        print("\(oilPriceDouble!) * \(numOfOilDouble)")
                    }
                    cell?.contentTextField.text = "\(calc)"
                    record.totalPrice = "\(calc)"
                }
            case .totalPrice:
                record.totalPrice = cell.contentTextField.text!
            case .totalKM:
                record.totalKM = cell.contentTextField.text!
            case .date:
                record.date = cell.contentTextField.text!
        }
    }
    //限制只能輸入數字與小數點
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let aSet = NSCharacterSet(charactersIn:"0123456789.").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }
}
// MARK: submit button
extension AddConsumptionRecordViewController {
    @objc func submitBtn() {
        self.view.endEditing(true)
        if record.oilPrice == "" || record.totalKM == "" || record.totalPrice == "" || record.numOfOil == "" {
            let alertController = UIAlertController(title: "系統提示", message: "請填入所需資訊", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "確定", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            postOilRecordData()
        }
    }
    func postOilRecordData() {
        guard
            let oilTypeSection = components.index(of: .oilType)
            else { return }
        let indexPath = IndexPath(row: 0, section: oilTypeSection)
        guard
            let cell = addConsumption.cellForRow(at: indexPath) as? ConsumptionSegmentTableViewCell
            else { return }
        //判斷選擇的油品
        if cell.oilTypeSegment.selectedSegmentIndex == 3 {
            record.oilType = "超級柴油"
        } else {
            record.oilType = "\(cell.oilTypeSegment.titleForSegment(at: (cell.oilTypeSegment.selectedSegmentIndex))!)無鉛汽油"
        }
        
        let object = AVObject(className: AVOSKey.consumptionRecordClassName)
        object.setObject(record.date, forKey: "date")
        object.setObject(record.oilType, forKey: "oilType")
        object.setObject(record.oilPrice, forKey: "oilPrice")
        object.setObject(record.numOfOil, forKey: "numOfOil")
        object.setObject(record.totalPrice, forKey: "totalPrice")
        object.setObject(record.totalKM, forKey: "totalKM")
        object.setObject(UserDefaults.standard.value(forKey: UserDefaultKeys.uuid), forKey: "uuid")
        
        _ = object.save()

        self.delegate?.detectSubmit(oilRecord: record)
        self.navigationController?.popViewController(animated: true)
    }
    
    func getMonday(myDate: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "YYYY-MM-dd"
        var cal = Calendar.current
        cal.firstWeekday = 2
        let comps = cal.dateComponents([.weekOfYear, .yearForWeekOfYear], from: myDate)
        let beginningOfWeek = cal.date(from: comps)!
        let monStr = df.string(from: beginningOfWeek)
        return monStr
    }
}
