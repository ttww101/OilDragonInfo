//
//  RequestToken.swift
//  Voyage
//
//  Created by 湯芯瑜 on 2018/3/13.
//  Copyright © 2018年 Hsin-Yu Tang. All rights reserved.
//

import Foundation

class RequestToken {
    
    private weak var task: URLSessionTask? //DIP
    
    init(task: URLSessionTask? = nil) {
        
        self.task = task
    }
    
    //TODO: Ask where to use
    func cancel() {//SIP
        
        task?.cancel()
    }
}
