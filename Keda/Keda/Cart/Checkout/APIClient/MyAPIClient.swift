//
//  MyAPIClient.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import Stripe
import Alamofire

public let stripeKey = "pk_test_51IW0HkFpP5Z8xfYJk3s7ByiQ0uKgXHKjzQhWCm35LMmG52YyM2FRKvmzmihwpN4fMCLJHajEaI5p4tSUvaPjLRMw00dueNYaDW"
public let urlScheme = "com.keda.t06.paymentskeda"

class MyAPIClient: NSObject, STPCustomerEphemeralKeyProvider {
    
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        /*
        let cusID = "cus_GwjDxdBv7TR8y3"
        let urlStr = "https://api.stripe.com/v1/ephemeral_keys"

        var requestData: [String : String]? = [String : String]()
        requestData?.updateValue(apiVersion, forKey: "api_version")
        requestData?.updateValue(cusID, forKey: "customerId")
        submitDataToURL(urlStr, withMethod: "POST", requestData: requestData!)
        */
        
        createCustomerKey(apiVersion: apiVersion, completion: completion)
    }
    
    /*
    func submitDataToURL(_ urlString : String, withMethod method : String, requestData data : [String : Any]) {
        do {
            guard let url = URL(string: urlString) else { return }
            let defaultSession = URLSession(configuration: .default)
            var urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
            let key = "application/json; charset=utf-8"
            urlRequest.httpMethod = method
            urlRequest.setValue(key, forHTTPHeaderField: "Content-Type")
            urlRequest.setValue(key, forHTTPHeaderField: "Accept")

            let httpBodyData : Data?
            try httpBodyData = JSONSerialization.data(withJSONObject: data, options: [.fragmentsAllowed])
            urlRequest.httpBody = httpBodyData

            let dataTask = defaultSession.dataTask(with: urlRequest, completionHandler: { (responseData, urlResponse, error) in
                print("responseData \(String(describing: responseData))")
                print("urlResponse \(String(describing: urlResponse))")
            })

            dataTask.resume()

        } catch { print("Excetion in submitDataToURL") }
    }
    */
    
    //MARK: - CustomerKey
    func createCustomerKey(apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        let urlStr = "http://192.168.11.135/StripeBackend/empheralkey.php"
        //let urlStr = "http://localhost:8888/StripeBackend/empheralkey.php"
        guard let url = URL(string: urlStr) else { return }
        let parameters = ["api_version" : apiVersion]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            do {
                if let data = response.data {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
                        print("Failure")
                        completion(nil, response.error!)
                        return
                    }
                    
                    print("Success")
                    completion(json, nil)
                }

            } catch {}
        }
    }
    
    //MARK: - CreateCustomer
    func createCustomer(_ user: User, completion: @escaping (String?) -> Void) {
        //let urlStr = "http://192.168.11.135/StripeBackend/createCustomer.php"
        let urlStr = "http://localhost:8888/StripeBackend/createCustomer.php"
        guard let url = URL(string: urlStr) else { return }
        let parameters: [String: Any] = [
            "email": user.email,
            "name": user.fullName,
            "phone": user.phoneNumber
        ]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if response.result.isSuccess {
                if let json = try? JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: Any] {
                    completion(json["id"] as? String)
                }
                
            } else {
                print("Error: \(response.result.error!)")
                completion(nil)
            }
        }
    }
    
    //MARK: - CreatePaymentIntent
    func createPaymentIntent(total: Double, customerId: String, completion: @escaping (String?) -> Void) {
        //let link = "http://192.168.11.135/StripeBackend/createpaymentintent.php"
        let link = "http://localhost:8888/StripeBackend/createpaymentintent.php"
        let total = Int(total)
        let parameters: [String: Any] = [
            "amount": total*100,
            "currency": "cad",
            "customerId": customerId
        ]
        
        guard let url = URL(string: link) else { return }
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if response.result.isSuccess {
                guard let json = try? JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: String] else { return }
                completion(json["clientSecret"])
                
            } else {
                print("Error: \(response.result.error!)")
                completion(nil)
            }
        }
    }
}
