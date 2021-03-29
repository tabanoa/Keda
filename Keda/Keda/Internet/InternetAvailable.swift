//
//  InternetAvailable.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit
import SystemConfiguration

//MARK: - Internet Available

public func isInternetAvailable() -> Bool {
    var zeroAddr = sockaddr_in()
    zeroAddr.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddr))
    zeroAddr.sin_family = sa_family_t(AF_INET)
    
    var flags = SCNetworkReachabilityFlags()
    let reachability = withUnsafePointer(to: &zeroAddr, {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1, { zeroSockAddr in
            SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddr)
        })
    })
    
    if !SCNetworkReachabilityGetFlags(reachability!, &flags) { return false }
    
    let reachable = flags.contains(.reachable)
    let connection = flags.contains(.connectionRequired)
    return reachable && !connection
}

func internetNotAvailable() {
    let wTxt = NSLocalizedString("Internet Not Available", comment: "InternetAvailable.swift: Internet Not Available")
    handleInternet(wTxt, imgName: "icon-wifi-unavailable")
}

func handleInternet(_ txt: String, imgName: String, isCircle: Bool = true, completion: (() -> ())? = nil) {
    let updateV = UpdateView.updateView(kWindow!, true)
    updateV.text = NSString(string: txt)
    updateV.imgName = imgName
    updateV.isCircle = isCircle
    
    delay(duration: 1.0) {
        UIView.animate(withDuration: 0.33, animations: {
            updateV.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            updateV.alpha = 0.0
        }) { (_) in
            updateV.removeFromSuperview()
            completion?()
        }
    }
}
