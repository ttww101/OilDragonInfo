
import Foundation

protocol PetroleumProvidable {
    func getPetroleum(completionHandler: @escaping ([Petroleum]?, Error?) -> Swift.Void)
}

class PetroleumProvider: PetroleumProvidable {
    
    var dataLoader: NetworkService
    private var requestToken: RequestToken? = nil
    private var offset = 0
    
    init(dataLoader: NetworkService) {
        self.dataLoader = dataLoader
    }
    
    func getPetroleum(completionHandler: @escaping ([Petroleum]?, Error?) -> Swift.Void) {
                
        guard let url = URL(string: "http://47.75.131.189/gas_inform/?type=all") else {
            //handle wrong url error
            completionHandler(nil, NetworkError.formURLFail)
            return
        }
        
        requestToken = dataLoader.getData(url: url, headers: nil, completionHandler: { result in //[unowned self]
            
            switch result {
                
            case .success(let data):
                
                let decoder = JSONDecoder()
                
                do {
                    // check if dictionary
                    let object = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
                    
                    //handle parse error
                    guard let petroleumArray = object?["data"] as? [AnyObject] else {
                            completionHandler(nil, NetworkError.parseError)
                            return
                    }
                    
                    //parse json data
                    let petroleumArrayData = try JSONSerialization.data(withJSONObject: petroleumArray, options: .prettyPrinted)
                    
                    //decode from data array
                    let petroleums = try decoder.decode([Petroleum].self, from: petroleumArrayData)
                    
                    //self offset + 10 per time
//                    self.offset += 10
                    
                    completionHandler(petroleums, nil)
                    
                } catch {
                    
                    completionHandler(nil, error)

                }
                
            case .error(let error):
                
                completionHandler(nil, error)
            }
        })
    }
}
