//
//  LogoVC.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class LogoVC: UIViewController {


    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)


            let id = "TabBarController"
            let vc = self.storyboard!.instantiateViewController(withIdentifier: id) as! TabBarController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }



//MARK: - Configures

extension LogoVC {

    func updateUI() {
        view.backgroundColor = UIColor(hex: 0x282b32)
    
}

}
