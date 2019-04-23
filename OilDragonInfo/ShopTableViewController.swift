
import UIKit
import NVActivityIndicatorView
import AVOSCloud

class ShopTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {

    var stores: [Shop] = []
    var scores = [String: Double]()

    let searchController = UISearchController(searchResultsController: nil)
    var searchTableView: UITableView!
    var filteredStores = [Shop]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    var shouldShowSearchResults = false
    
    //MARK: vc life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestStoreData()
        setUp()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none

        searchBarSetup()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return filteredStores.count
        } else {
            return stores.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchController.isActive {
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: ShopListInfoTableViewCell.identifier, for: indexPath) as? ShopListInfoTableViewCell
                else { return UITableViewCell()}
            cell.view.layer.cornerRadius = 15

            cell.storeName.text = "\(filteredStores[indexPath.row].name)"
            cell.address.text = "\(filteredStores[indexPath.row].address)"
            cell.phone.text = "\(filteredStores[indexPath.row].phone)"
            let id = filteredStores[indexPath.row].objectID
            cell.cosmosRatingView.settings.fillMode = .precise
            if scores[id] == nil {
                cell.cosmosRatingView.rating = 0
            } else {
                cell.cosmosRatingView.rating = scores[id]!
            }
            cell.cosmosRatingView.settings.updateOnTouch = false
            return cell
        } else {
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: ShopListInfoTableViewCell.identifier, for: indexPath) as? ShopListInfoTableViewCell
                else { return UITableViewCell()}
            cell.view.layer.cornerRadius = 15

            cell.storeName.text = "\(stores[indexPath.row].name)"
            cell.address.text = "\(stores[indexPath.row].address)"
            cell.phone.text = "\(stores[indexPath.row].phone)"
            let id = stores[indexPath.row].objectID
            cell.cosmosRatingView.settings.fillMode = .precise
            if scores[id] == nil {
                cell.cosmosRatingView.rating = 0
            } else {
                cell.cosmosRatingView.rating = scores[id]!
            }
            cell.cosmosRatingView.settings.updateOnTouch = false
            return cell
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ShopListInfoTableViewCell.height
    }

    //MARK: Private
    
    func setUp() {
        let storeDetailNib = UINib(nibName: ShopListInfoTableViewCell.identifier, bundle: nil)
        tableView.register(storeDetailNib, forCellReuseIdentifier: ShopListInfoTableViewCell.identifier)
    }

    func requestStoreData() {
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
        
        
        let query = AVQuery(className: AVOSKey.storeClassName)
        
        query.findObjectsInBackground { (dataObjects, error) in
             NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
            
            if let _ = error { return }
            
            guard let objects = dataObjects else { return }
            
            if let avObjects = objects as? [AVObject] {
                
                var remoteStores: [Shop] = []
                
                for avObject in avObjects {
                    //stores
                    let name = avObject["name"] as! String
                    let phone = avObject["phone"] as! String
                    let address = avObject["address"] as! String
                    let objectID = avObject["objectId"] as! String
                    let rate = avObject["rate"] as? [String : String]?
                    let comments = avObject["comments"] as! [String]
                    let store = Shop(name: name, address: address, phone: phone, objectID: objectID, rate: rate ?? nil, comments: comments )
                    remoteStores.append(store)
                    self.scores[objectID] = Double(rate??[UserDefaults.standard.value(forKey:UserDefaultKeys.uuid) as! String] ?? "")
                }
                self.stores = remoteStores
                self.tableView.reloadData()
            }
        }
    }

    @IBAction func addStore(_ sender: Any) {
        searchController.dismiss(animated: true, completion: nil)
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddStoreViewController") as? AddShopViewController
                else { return }
            vc.delegate = self
            self.show(vc, sender: nil)
    }
}

extension ShopTableViewController {
    //選到那個欄位
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchController.isActive {
            print("\(stores[indexPath.row].objectID)")
            guard
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommentViewController") as? CommentViewController
                else { return }
            vc.shop = filteredStores[indexPath.row]
            vc.delegate = self
            self.show(vc, sender: nil)
            searchController.dismiss(animated: true, completion: nil)
        } else {
            print("\(stores[indexPath.row].objectID)")
            guard
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommentViewController") as? CommentViewController
                else { return }
            vc.shop = stores[indexPath.row]
            vc.delegate = self
            self.show(vc, sender: nil)
        }
    }
}

extension ShopTableViewController {
    func updateSearchResults(for searchController: UISearchController) {
        // 取得搜尋文字
        guard
            let searchText = searchController.searchBar.text
            else { return }
        filteredStores = stores.filter({ (store) -> Bool in
            return store.name.contains(searchText) || store.address.contains(searchText)
        })
    }
    func searchBarSetup() {
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.searchBarStyle = .prominent
        searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = searchController.searchBar
    }
    func dismissKeyboard() {
        view.endEditing(true)
        searchController.dismiss(animated: true, completion: nil)
    }
}

extension ShopTableViewController: buttonIsClick {
    func detectIsClick() {
        self.stores.removeAll()
        self.scores.removeAll()
        self.requestStoreData()
        print("Click")
    }
}
