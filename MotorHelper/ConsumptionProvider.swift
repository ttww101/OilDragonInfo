//
//  ConsumptionProvider.swift
//  MotorHelper
//
//  Created by Wu on 2019/4/18.
//  Copyright © 2019 na. All rights reserved.
//

import Foundation

protocol ConsumptionRecordProvidable {
    func getConsumptionRecord(completionHandler: @escaping ([ConsumptionRecord]?, Error?) -> Swift.Void)
}

class ConsumptionProvider: ConsumptionRecordProvidable {
    
    var dataLoader: NetworkService
    private var requestToken: RequestToken? = nil
    private var offset = 0
    
    init(dataLoader: NetworkService) {
        self.dataLoader = dataLoader
    }
    
    func getConsumptionRecord(completionHandler: @escaping ([ConsumptionRecord]?, Error?) -> Swift.Void) {
        
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
                    guard let consumptionRecordArray = object?["data"] as? [AnyObject] else {
                        completionHandler(nil, NetworkError.parseError)
                        return
                    }
                    
                    //parse json data
                    let consumptionRecordArrayData = try JSONSerialization.data(withJSONObject: consumptionRecordArray, options: .prettyPrinted)
                    
                    //decode from data array
                    let consumptionRecords = try decoder.decode([ConsumptionRecord].self, from: consumptionRecordArrayData)
                    
                    //self offset + 10 per time
                    //                    self.offset += 10
                    
                    completionHandler(consumptionRecords, nil)
                    
                } catch {
                    
                    completionHandler(nil, error)
                    
                }
                
            case .error(let error):
                
                completionHandler(nil, error)
            }
        })
    }
}
