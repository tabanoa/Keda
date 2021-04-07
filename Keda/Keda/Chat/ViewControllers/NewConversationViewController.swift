//
//  NewConversationViewController.swift
//  MessagingApp
//
//  Created by Ben Jenkyn on 2021-01-20.
//

import UIKit

class NewConversationViewController: UIViewController {
    
    public var completion: ((User) -> (Void))?
    
    private var users = [User]()
    
    private var results = [User]()
    
    private var hasFetched = false;
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for Users..."
        return searchBar
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(UITableViewCell.self,
                       forCellReuseIdentifier: "cell")
        return table
    }()
    
    private let noResultLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "No Results"
        label.textAlignment = .center
        label.textColor = .green
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(noResultLabel)
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        view.backgroundColor = .white
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(dismissSelf))
        searchBar.becomeFirstResponder()
        if !hasFetched{
            User.fetchAllUsers { (users) in
                self.users = users
                self.hasFetched = true
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noResultLabel.frame = CGRect(x: view.msgWidth/4,
                                     y: view.msgHeight-200/2,
                                     width: view.msgWidth/2,
                                     height: 200)
    }
    
    @objc private func dismissSelf(){
        dismiss(animated: true, completion: nil)
    }
}

extension NewConversationViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = results[indexPath.row].fullName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Start Conversation
        let targetUserData = results[indexPath.row]
        
        dismiss(animated: true, completion: {[weak self] in
            self?.completion?(targetUserData)
        })
    }
}

extension NewConversationViewController: UISearchBarDelegate{
    //Manages the search bar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.replacingOccurrences(of: " ", with: "").isEmpty else{
            return
        }
        searchBar.resignFirstResponder()
        
        results.removeAll()
        
        self.searchUsers(query: text)
    }
    
    func searchUsers(query: String){
        if hasFetched{
            filterUsers(with: query)
        }
        else{
            User.fetchAllUsers { (users) in
                self.users = users
                self.hasFetched = true
            }
        }
    }
    
    func filterUsers(with term: String){
        guard hasFetched else{
            return
        }
        
        let results: [User] = self.users.filter({
            return $0.fullName.lowercased().hasPrefix(term.lowercased())
        })
        
        self.results = results
        
        updateUI()
    }
    
    func updateUI(){
        if results.isEmpty{
            self.noResultLabel.isHidden = false
            self.tableView.isHidden = true
        }
        else{
            self.noResultLabel.isHidden = true
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
}

