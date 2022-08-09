//
//  PushNotificationSender.swift
//  WGTNotification
//
//  Created by Nguyen Quang on 08/08/2022.
//

import UIKit

struct PushNotificationSender {
    
    func callApiSendFcmToken() {
        guard let url = NSURL(string:"https://wordsapiv1.p.mashape.com/words/soliloquy") else { return }
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                guard let data = data, let json = String(data: data, encoding: .utf8)?.data(using: .utf8)  else { return }
                print(json)
            }
        }
        task.resume()
    }
}
