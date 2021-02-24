//
//  NotificationsViewController.swift
//  Keda Profile
//
//  Created by Matthew Mukherjee on 12/22/2020.

import UIKit
import ProgressHUD

class NotificationsViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Vars
    var allUsers: [FUser] = []

    
    //MARK: - ViewLifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
    }
    
    //MARK: - Navigation
    
    private func showUserProfileFor(user: FUser) {
        
        let profileView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ProfileTableView") as! UserProfileTableViewController
        
        profileView.userObject = user
        self.navigationController?.pushViewController(profileView, animated: true)
    }

}


extension NotificationsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! LikeTableViewCell
        
        cell.setupCell(user: allUsers[indexPath.row])
        return cell
    }
    
    
}


extension NotificationsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        showUserProfileFor(user: allUsers[indexPath.row])
    }
}
