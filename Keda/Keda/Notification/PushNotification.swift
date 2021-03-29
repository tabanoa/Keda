//
//  PushNotification.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import Foundation
import Alamofire
import Firebase
import UserNotifications

//MARK: - PushNotification

public let senderID = "1085365256573"
public let serverKey = "AAAA_LTPgX0:APA91bGUtCghB6m1ye0oQpfJOiyaSGhox2rkmUyxCJYlu4k6oDk-xkCJVH3mwQdDMVkoNvi-gQqvmKTL5k0hQQw61AsDhhnYGABpM1HOc7C5hfUJu2l6dJpahUBo54y4Bf3r-1-rTjV-"
public let fcmURL = "https://fcm.googleapis.com/fcm"

public let newArrivalKey       = "newArrival"
public let promotionKey        = "promotion"
public let saleOffKey          = "saleOff"
public let updatingOrdersKey   = "updatingOrders"

public let notifKeyNewArrival       = "appFashi-NewArrival"
public let notifKeyPromotion        = "appFashi-Promotion"
public let notifKeySaleOff          = "appFashi-SaleOff"

public func pushNotificationForInfo(keyName: String, title: String, body: String) {
    retrievingNotificationKey(keyName: keyName) { (key) in
        guard let url = URL(string: "\(fcmURL)/send") else { return }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        let dict: [String: Any] = [
            "to": "\(key)",
            "notification": [
                "title": title,
                "body": body,
                "sound": "default",
                "badge": 1
            ]
        ]
        
        let data = try! JSONSerialization.data(withJSONObject: dict, options: [.prettyPrinted])
        request.httpBody = data
        
        Alamofire.request(request).responseJSON { (response) in
            switch response.result {
            case .success: print(response); break
            case .failure(let error): print(error.localizedDescription); break
            }
        }
    }
}

public func createNotification(keyName: String, ids: [String]) {
    let url = URL(string: "\(fcmURL)/notification")!
    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
    request.setValue(senderID, forHTTPHeaderField: "project_id")
    request.httpMethod = "POST"
    
    let dict: [String: Any] = [
        "operation": "create",
        "notification_key_name": keyName,
        "registration_ids": ids
    ]
    
    let data = try! JSONSerialization.data(withJSONObject: dict, options: [.prettyPrinted])
    request.httpBody = data
    
    Alamofire.request(request).responseJSON { (response) in
        switch response.result {
        case .success:
            print("*** Notif-Create: \(response)")
            if let dict = response.value as? [String: Any] {
                if dict["error"] as? String == "notification_key already exists" {
                    retrievingAndAddOrRemoveNotification(keyName: notifKeyNewArrival, operation: "add", ids: ids)
                    retrievingAndAddOrRemoveNotification(keyName: notifKeyPromotion, operation: "add", ids: ids)
                    retrievingAndAddOrRemoveNotification(keyName: notifKeySaleOff, operation: "add", ids: ids)
                }
            }
            
        case .failure(let error): print("Error: \(error.localizedDescription)"); break
        }
    }
}

public func addOrRemoveNotification(keyName: String, operation: String, key: String, ids: [String]) {
    let url = URL(string: "\(fcmURL)/notification")!
    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
    request.setValue(senderID, forHTTPHeaderField: "project_id")
    request.httpMethod = "POST"
    
    let dict: [String: Any] = [
        "operation": operation,
        "notification_key_name": keyName,
        "notification_key": key,
        "registration_ids": ids
    ]
    
    let data = try! JSONSerialization.data(withJSONObject: dict, options: [.prettyPrinted])
    request.httpBody = data
    
    Alamofire.request(request).responseJSON { (response) in
        switch response.result {
        case .success: print("*** Add-Remove: \(response)"); break
        case .failure(let error): print("Error: \(error.localizedDescription)"); break
        }
    }
}

public func retrievingNotificationKey(keyName: String, completion: @escaping (String) -> Void) {
    let url = URL(string: "\(fcmURL)/notification?notification_key_name=\(keyName)")!
    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
    request.setValue(senderID, forHTTPHeaderField: "project_id")
    request.httpMethod = "GET"
    
    Alamofire.request(request).responseJSON { (response) in
        switch response.result {
        case .success:
            if let dict = response.value as? [String: Any] {
                for (_, value) in dict {
                    if let key = value as? String {
                        print("*** Retrieving: \(key)")
                        completion(key)
                    }
                }
            }
            
        case .failure(let error): print("Error: \(error.localizedDescription)"); break
        }
    }
}

public func retrievingAndAddOrRemoveNotification(keyName: String, operation: String, ids: [String]) {
    retrievingNotificationKey(keyName: keyName) { (key) in
        addOrRemoveNotification(keyName: keyName, operation: operation, key: key, ids: ids)
    }
}

public func pushNotificationTo(toUID: String, title: String, body: String) {
    guard let url = URL(string: "\(fcmURL)/send") else { return }
    
    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
    request.httpMethod = "POST"
    
    let dict: [String: Any] = [
        "to": "/topics/\(toUID)",
        "notification": [
            "title": title,
            "body": body,
            "sound": "default",
            "badge": 1
        ]
    ]
    
    let data = try! JSONSerialization.data(withJSONObject: dict, options: [.prettyPrinted])
    request.httpBody = data
    
    Alamofire.request(request).responseJSON { (response) in
        switch response.result {
        case .success: print(response); break
        case .failure(let error): print(error.localizedDescription); break
        }
    }
    
    /*
    let session = URLSession.shared
    session.dataTask(with: request, completionHandler: { (data, response, error) in
        guard error == nil, let data = data else { return }
        if let httpRes = response as? HTTPURLResponse,
            httpRes.statusCode != 200 {
            print("*** httpURLRes: \(httpRes.statusCode)")
            print("*** Res: \(response!)")
        }
        
        if let resStr = String(data: data, encoding: .utf8) {
            print("*** ResStr: \(resStr)")
        }
    }).resume()
    */
}

public func setupSubscribeMessage() {
    guard isLogIn() else { return }
    if let currentUID = currentUID {
        Messaging.messaging().subscribe(toTopic: "/topics/\(currentUID)")
    }
}

public func configureNotification(completion: @escaping (UNAuthorizationStatus) -> Void) {
    let current = UNUserNotificationCenter.current()
    current.getNotificationSettings { (setting) in
        switch setting.authorizationStatus {
        case .notDetermined: completion(.notDetermined); break
        case .denied: completion(.denied); break
        case .authorized: completion(.authorized); break
        default: break
        }
    }
}

public func openSettingURL() {
    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
    UIApplication.shared.open(url) { (success) in }
}
