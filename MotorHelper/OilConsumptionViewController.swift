
import UIKit
import AVOSCloud
import NVActivityIndicatorView

class OilConsumptionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, OilConsumptionManagerDelegate {
    
    @IBOutlet weak var tableView: UITableView!

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
        
        query.findObjectsInBackground { [unowned self] (dataObjects, error) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
            
            if let _ = error { return }
            
            guard let objects = dataObjects else { return }
            
            if let avObjects = objects as? [AVObject] {
                
                var records: [ConsumptionRecord] = []
                
                for avObject in avObjects {
                    //stores
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
        let detailNib = UINib(nibName: RecordTableViewCell.identifier, bundle: nil)
        tableView.register(detailNib, forCellReuseIdentifier: RecordTableViewCell.identifier)
        self.tableView.allowsSelection = false
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: RecordTableViewCell.identifier, for: indexPath) as? RecordTableViewCell
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
        return RecordTableViewCell.height
    }

    func manager(_ manager: OilConsumptionManager, didFailWith error: Error) {
        print("error")
    }
    func manager(_ manager: OilConsumptionManager, didGet records: [ConsumptionRecord]) {
//        self.records = records.reversed()
        self.records = records.sorted(by: { (obj1, obj2) -> Bool in
            if obj1.date == obj2.date {
                return obj1.totalKM < obj2.totalKM
            } else {
                //目前比較的是String
                print("\(obj1.date) < \(obj2.date)")
                return obj1.date < obj2.date
            }
        })
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.moveToLastRecord()
        }
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
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddOilRecordViewController") as? AddOilRecordViewController
            else { return }
        vc.delegate = self
        self.show(vc, sender: nil)
    }
    // move to last cell
    func moveToLastRecord() {
        if tableView.contentSize.height > tableView.frame.height {
            // First figure out how many sections there are
            let lastSectionIndex = tableView.numberOfSections - 1
            // Then grab the number of rows in the last section
            let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
            // Now just construct the index path
            let pathToLastRow = NSIndexPath(row: lastRowIndex, section: lastSectionIndex)
            // Make the last row visible
            tableView.scrollToRow(at: pathToLastRow as IndexPath, at: UITableView.ScrollPosition.bottom, animated: true)
        }
    }
}
extension OilConsumptionViewController: submitIsClick {
    func detectSubmit(oilRecord: ConsumptionRecord) {
        self.records.append(oilRecord)
        self.tableView.reloadData()
    }
}
