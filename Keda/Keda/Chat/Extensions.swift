//
//  Extensions.swift
//  Keda
//
//  Created by Ben Jenkyn on 2021-03-28.
//  Copyright © 2021 Keda Team. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    public var msgWidth: CGFloat {
        return frame.size.width
    }

    public var msgHeight: CGFloat {
        return frame.size.height
    }

    public var msgTop: CGFloat {
        return frame.origin.y
    }

    public var msgBottom: CGFloat {
        return frame.size.height + frame.origin.y
    }

    public var msgLeft: CGFloat {
        return frame.origin.x
    }

    public var msgRight: CGFloat {
        return frame.size.width + frame.origin.x
    }

}

extension Notification.Name {
    /// Notificaiton  when user logs in
    static let didLogInNotification = Notification.Name("didLogInNotification")
}
