//
//  GatewayAPIWrapper.swift
//  GatewayAPISMS
//
//  Created by Taif Al Musabe on 29/7/19.
//  Copyright © 2019 Taif Al Musabe. All rights reserved.
//

import UIKit

class GatewayAPIWrapper: NSObject {
    
    @objc public var sender:String?
    @objc public var message: String?
    @objc public var recipients: Array<String>?
    
    @objc var delegate: GatewayAPIWrapperDelegate?
    
    static private let apiUrl: String = "https://gatewayapi.com/rest/mtsms"
    
    private var request: URLRequest!
    
    @objc public init(token:String) {
        super.init()
        
        var urlComps = URLComponents(string: GatewayAPIWrapper.apiUrl)!
        urlComps.queryItems = [URLQueryItem(name: "token", value: token)]
        
        self.request = URLRequest(url: urlComps.url!)
        self.request.httpMethod = "POST"
        self.request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        self.request.addValue("application/json", forHTTPHeaderField: "Accept")
    }
    
    @objc public func sendSMS() {
        
        var recepientsDict : [[String:String]] = []
        for recepient in recipients! {
            recepientsDict.append(["msisdn" : recepient])
        }
        
        let json: [String: Any] = ["sender": sender!,
                                   "message": message!,
                                   "recipients": recepientsDict
                                  ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                self.delegate?.sendSMSError(error: error?.localizedDescription ?? "No Data")
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                self.delegate?.sendSMSResponse(result: responseJSON)
                print(responseJSON)
            }
        }
        task.resume()
        
    }
    
}

@objc protocol GatewayAPIWrapperDelegate {
    @objc func sendSMSResponse(result: [String: Any])
    @objc func sendSMSError(error: String)
}
