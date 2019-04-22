
import UIKit
import AVOSCloud
import NVActivityIndicatorView

class ConsumptionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var noRecordMessageLabel = UILabel()
    var noRecordMessageView: UIView {
        let view = UIView()
        noRecordMessageLabel.textAlignment = .center
        noRecordMessageLabel.font = UIFont.systemFont(ofSize: 14)
        noRecordMessageLabel.textColor = UIColor.lightGray
        view.addSubview(noRecordMessageLabel)
        noRecordMessageLabel.constraints(view, constant: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
        view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.width/5)
        return view
    }

    var records: [ConsumptionRecord] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.separatorStyle = .none
        setUp()
        requestRecord()
    }
    
    func requestRecord() {
        
        let query = AVQuery(className: AVOSKey.consumptionRecordClassName)
        if let uuid = UserDefaults.standard.value(forKey: UserDefaultKeys.uuid) as? String {
            query.whereKey("uuid", equalTo: uuid)
        }
        
        query.findObjectsInBackground { [unowned self] (dataObjects, error) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
            
            if let _ = error { return }
            
            guard let objects = dataObjects else { return }
            
            if let avObjects = objects as? [AVObject] {
                
                var records: [ConsumptionRecord] = []
                
                for avObject in avObjects {
                    //display consumption
                    let date = avObject["date"] as! String
                    let oilType = avObject["oilType"] as! String
                    let oilPrice = avObject["oilPrice"] as! String
                    let numOfOil = avObject["numOfOil"] as! String
                    let totalPrice = avObject["totalPrice"] as! String
                    let totalKM = avObject["totalKM"] as! String
                    
                    let record = ConsumptionRecord(date: date, oilType: oilType, oilPrice: oilPrice, numOfOil: numOfOil, totalPrice: totalPrice, totalKM: totalKM)
                    records.append(record)
                }
                self.records = records
                
                self.records = records.sorted(by: { (obj1, obj2) -> Bool in
                    if obj1.date == obj2.date {
                        return obj1.totalKM < obj2.totalKM
                    } else {
                        return obj1.date < obj2.date
                    }
                })
                
                self.tableView.reloadData()
            }
        }

    }
    
    func setUp() {
        let detailNib = UINib(nibName: ConcumptionRecordTableViewCell.identifier, bundle: nil)
        tableView.register(detailNib, forCellReuseIdentifier: ConcumptionRecordTableViewCell.identifier)
        self.tableView.allowsSelection = false
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if (records.count == 0) {
            self.noRecordMessageLabel.text = "-尚未新增油耗紀錄-"
        } else {
            self.noRecordMessageLabel.text = "-沒有更多油耗紀錄-"
        }
        return self.noRecordMessageView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: ConcumptionRecordTableViewCell.identifier, for: indexPath) as? ConcumptionRecordTableViewCell
            else { return UITableViewCell() }
        cell.grayview.layer.cornerRadius = 15
        cell.dateOfAddRecord.text = "\(records[indexPath.row].date)"
        cell.numOfOil.text = "\(records[indexPath.row].numOfOil) 公升"
        cell.oilType.text = "\(records[indexPath.row].oilType)"
        cell.totalKM.text = "\(records[indexPath.row].totalKM) 公里"
        cell.totalPrice.text = "\(records[indexPath.row].totalPrice) 元"
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ConcumptionRecordTableViewCell.height
    }

    private func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            print("\(userID!) --- \(records[indexPath.row].autoID)")
//            FIRDatabase.database().reference().child("\(userID!)").child("\(records[indexPath.row].autoID)").removeValue(completionBlock: { ( _, _) in
//                self.records.remove(at: indexPath.row)
//                self.tableView.deleteRows(at: [indexPath], with: .fade)
//            })
            self.tableView.reloadData()
        }
    }

    @IBAction func addRecord(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddOilRecordViewController") as? AddConsumptionRecordViewController
            else { return }
        vc.delegate = self
        self.show(vc, sender: nil)
    }
}
extension ConsumptionViewController: submitIsClick {
    func detectSubmit(oilRecord: ConsumptionRecord) {
        self.records.append(oilRecord)
        self.tableView.reloadData()
    }
}
