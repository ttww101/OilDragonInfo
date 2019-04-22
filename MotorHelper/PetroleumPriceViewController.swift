
import UIKit
import SystemConfiguration
import NVActivityIndicatorView

class PetroleumPriceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var products: [Petroleum] = []
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var reloadBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadBtn.layer.cornerRadius = 8
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "PetroleumPriceTableViewCell", bundle: nil), forCellReuseIdentifier: "PetroleumPriceTableViewCell")
        self.tableView.backgroundColor = UIColor(displayP3Red: 57/255, green: 58/255, blue: 58/255, alpha: 1.0)
        self.tableView.estimatedRowHeight = 77
        self.tableView.rowHeight = UITableView.automaticDimension
        getOilInfo()
    }
    
    func getOilInfo() {
        
        let petroleumProvider = PetroleumProvider(dataLoader: DataLoader())
        petroleumProvider.getPetroleum { [unowned self] (products, error) in
            guard let products = products else { return }
            self.products = products
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
            })
        }
    }
    
    @IBAction func reload(_ sender: Any) {
        getOilInfo()
    }
}

extension PetroleumPriceViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PetroleumPriceTableViewCell", for: indexPath) as? PetroleumPriceTableViewCell else {
            return UITableViewCell()
        }
        
        cell.nameLabel.text = self.products[indexPath.row].name
        cell.priceLabel.text = "\(self.products[indexPath.row].price)  TWD/l"
        
        return cell
    }
    
}
