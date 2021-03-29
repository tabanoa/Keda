//
//  AppDelegate.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.


import UIKit
import Stripe
import Braintree
import Firebase
import SDWebImage
import FBSDKCoreKit
import CoreData
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let effectView = UIVisualEffectView()
    
    var isHomeVC = false
    var isWishlistVC = false
    var isShopVC = false
    var isArrivalsDetailVC = false
    var isFeaturedDetailVC = false
    var isSellersDetailVC = false
    var isProductRatingVC = false
    
    var iPad = false
    var isX = false
    var iPhonePlus = false
    var iPhone = false
    var iPhone5 = false
    
    let englishTxt = NSLocalizedString("English", comment: "AppDelegate.swift: English")
    var isFirstTime = !Manager.sharedInstance.getFirstTime()
    
    lazy var coreDataStack = CoreDataStack(modelName: "FashiDM")
    
    private let gcmMessageID = "gcm.message_id"
    var tokenKey = ""

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupAppearance()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            iPad = true
            
        } else if UIDevice.current.userInterfaceIdiom == .phone {
            iPad = false
            
            switch UIScreen.main.nativeBounds.height {
            case 2688, 1792, 2436: isX = true; break
            case 2208: iPhonePlus = true; break
            case 1334: iPhone = true; break
            case 1136: iPhone5 = true; break
            default: isX = true; break
            }
        }
        
        //TODO: - Stripe
        Stripe.setDefaultPublishableKey(stripeKey)
        
        //TODO: - Braintree
        BTAppSwitch.setReturnURLScheme(urlScheme)
        
        //TODO: - Firebase
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        
        //TODO: - SaveData
        saveData()
        
        //TODO: - Facebook
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //TODO: - LogOut
        setupLogOut()
        
        //TODO: - DeleteCoreData
        //deleteRecentlyViewed()
        //deleteRecentSearches()
        
        //TODO: - RemoveCacheImage
        //SDImageCache.shared.clearMemory()
        //SDImageCache.shared.clearDisk(onCompletion: nil)
        
        //TODO: - TestRating
        saveRating()
        
        //TODO: - TestViews
        saveViews()
        
        //TODO: - TestBuyed
        saveBuyed()
        
        //TODO: Notification
        requestAuthorizationNotif(application)
        
        return true
    }
    
    private func requestAuthorizationNotif(_ application: UIApplication) {
        let current = UNUserNotificationCenter.current()
        current.requestAuthorization(options: [.sound, .badge, .alert]) { (granted, error) in
            guard error == nil, granted else { return }
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
            
            Messaging.messaging().delegate = self
            current.delegate = self
            
            //TODO: - Subscribe
            setupSubscribeMessage()
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.scheme?.localizedCaseInsensitiveCompare(urlScheme) == ComparisonResult.orderedSame {
            return BTAppSwitch.handleOpen(url, options: options)
        }
        
        return false || ApplicationDelegate.shared.application(app, open: url, options: options)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().token { (token, error) in
            if let error = error {
                print("*** Notf-ResError-Mes: \(error.localizedDescription)")
                
            } else if let token = token {
                self.tokenKey = token
                print("*** Notf-ResToken-Mes: \(self.tokenKey)")
                
                guard self.tokenKey != "" else { return }
                self.setupPushNotif()
            }
        }
        
        /*
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("*** Notf-ResError-Inst: \(error.localizedDescription)")
                
            } else if let result = result {
                self.tokenKey = result.token
                print("*** Notf-ResToken-Inst: \(self.tokenKey)")
                
                guard self.tokenKey != "" else { return }
                self.setupPushNotif()
            }
        }
        */
        
        Messaging.messaging().apnsToken = deviceToken
    }
    
    private func setupPushNotif() {
        if !Manager.sharedInstance.getFirstTimeNotif() {
            Manager.sharedInstance.setFirstTimeNotif(true)
            self.handleNotification(self.tokenKey)
        }
    }
    
    private func handleNotification(_ fcmToken: String) {
        createNotification(keyName: notifKeyNewArrival, ids: [fcmToken])
        createNotification(keyName: notifKeyPromotion, ids: [fcmToken])
        createNotification(keyName: notifKeySaleOff, ids: [fcmToken])
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let messageID = userInfo[gcmMessageID] { print("*** Notf-ReceiveMessageID: \(messageID)") }
        print("*** Notf-ReceiveUserInfo: \(userInfo)")
        
        switch application.applicationState {
        case .active: print("*** Update badges")
        case .inactive:
            guard isLogIn() else { return }
            let notificationVC = NotificationVC()
            notificationVC.isPop = true
            window?.rootViewController = UINavigationController(rootViewController: notificationVC)
            window?.makeKeyAndVisible()
        case .background: print("*** Background")
        default: break
        }
        
        Messaging.messaging().appDidReceiveMessage(userInfo)
        completionHandler(.newData)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("*** Notf-FailError: \(error.localizedDescription)")
    }
    
    private func setupAppearance() {
        UITabBar.appearance().barTintColor = .white
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        
        let attributes = setupAttri(fontNamedBold, size: 17.0, txtColor: .white)
        UINavigationBar.appearance().titleTextAttributes = attributes
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = defaultColor
        UINavigationBar.appearance().tintColor = .black
        window?.tintColor = .black
        
        //UIApplication.shared.statusBarView?.backgroundColor = defaultColor
    }
    
    private func saveData() {
       // Product.saveHoodies()
        Product.saveWatches()
        Product.saveBelts()
        Product.saveShoes()
        Product.saveBags()
    }
    
    private func saveRating() {
        Rating.saveBelts()
        Rating.saveBags()
        Rating.saveHoodies()
        Rating.saveShoes()
        Rating.saveWatches()
    }
    
    private func saveViews() {
        ViewsModel.saveBelts()
        ViewsModel.saveBags()
        ViewsModel.saveHoodies()
        ViewsModel.saveShoes()
        ViewsModel.saveWatches()
    }
    
    private func saveBuyed() {
        Buyed.saveBelts()
        Buyed.saveBags()
        Buyed.saveHoodies()
        Buyed.saveShoes()
        Buyed.saveWatches()
    }
    
    private func setupLogOut() {
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "SignOutKey") == false {
            do {
                try Auth.auth().signOut()
                
            } catch {}
            
            defaults.setValue(true, forKey: "SignOutKey")
            defaults.synchronize()
        }
    }
    
    func deleteRecentlyViewed() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RecentlyViewed")
        let recently = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try coreDataStack.managedObjectContext.execute(recently)
            coreDataStack.saveContext()
            print("Delete Recently Viewed Success")
            
        } catch {}
    }
    
    func deleteRecentSearches() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RecentSearches")
        let recent = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try coreDataStack.managedObjectContext.execute(recent)
            coreDataStack.saveContext()
            print("Delete Recent Searches Success")
            
        } catch {}
    }

    /*
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    */
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        effectView.effect = UIBlurEffect(style: .dark)
        effectView.frame = window!.bounds
        effectView.alpha = 0.95
        window?.addSubview(effectView)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        if isLogIn() { User.disconnected() }
        DispatchQueue.main.async {
            application.applicationIconBadgeNumber = 0
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        effectView.removeFromSuperview()
        if isLogIn() { User.connected() }
        DispatchQueue.main.async {
            application.applicationIconBadgeNumber = 0
        }
        
        configureNotification { (status) in
            guard status == .authorized else { return }
            self.requestAuthorizationNotif(application)
            guard self.tokenKey != "" else { return }
            if !Manager.sharedInstance.getFirstTimeNotif() {
                Manager.sharedInstance.setFirstTimeNotif(true)
                self.handleNotification(self.tokenKey)
            }
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        effectView.removeFromSuperview()
    }
}

//MARK: - MessagingDelegate

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("*** Notf-FCMToken: \(fcmToken)")
        self.tokenKey = fcmToken
        
        let userInfo: [String: Any] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: userInfo)
    }
}

//MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        if let messageID = userInfo[gcmMessageID] { print("*** Notf-MessageID: \(messageID)") }
        print("*** Notf-UserInfo: \(userInfo)")
        completionHandler([.sound, .badge, .alert])
    }
}

extension UIApplication {
    
    var statusBarView: UIView? {
        if #available(iOS 13, *) {
            let tag = 3848245
            let keyWindow = UIApplication.shared.connectedScenes
                .map({ $0 as? UIWindowScene })
                .compactMap({ $0 })
                .first?.windows.first
            
            if let statusBar = keyWindow?.viewWithTag(tag) {
                return statusBar
                
            } else {
                guard let statusBarF = keyWindow?.windowScene?.statusBarManager?.statusBarFrame else { return nil }
                let statusBarV = UIView(frame: statusBarF)
                statusBarV.tag = tag
                statusBarV.layer.zPosition = 999999
                keyWindow?.addSubview(statusBarV)
                return statusBarV
            }
        } else if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
            
        } else {
            return nil
        }
    }
}

//MARK: - Open FB

extension UIApplication {
    
    class func tryURL(urls: [String]) {
        let app = UIApplication.shared
        urls.forEach({
            let url = URL(string: $0)!
            if app.canOpenURL(url) {
                app.open(url)
            }
        })
    }
}
