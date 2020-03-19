//
//  SettingsVC.swift
//  Flaint
//
//  Created by Kerby Jean on 5/19/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit
import FirebaseAuth

class SettingsVC: UIViewController {
    
    
    // MARK: - Properties
    
    var tableView: UITableView!
    var userId: String?
    
    var settings = ["Edit account", "Password", "Log Out"]    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Options"
        
        view.backgroundColor = .backgroundColor
        
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: displayWidth, height: displayHeight))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.id)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .backgroundColor
        self.view.addSubview(tableView)
    }
    
    // MARK: - Functions
            
    func logoutAlert() {
      let alert = UIAlertController(title: "Log Out", message: nil, preferredStyle: .alert)
      let logOut = UIAlertAction(title: "Log Out", style: .default) { (action) in
          let firebaseAuth = Auth.auth()
          do {
              try firebaseAuth.signOut()              
              let navigation = UINavigationController(rootViewController: LogInVC())
              
              navigation.modalPresentationStyle = .fullScreen
              self.navigationController?.present(navigation, animated: true, completion: nil)
          } catch let signOutError as NSError {
              print ("Error signing out: %@", signOutError)
          }
      }
      let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
      alert.addAction(logOut)
      alert.addAction(cancel)
      self.present(alert, animated: true, completion: nil)
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource

extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.id, for: indexPath)
        cell.backgroundColor = .backgroundColor
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        cell.textLabel?.text = settings[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        if row == 0 {
            let vc = EditProfileVC()
            vc.userId = self.userId
            navigationController?.pushViewController(vc, animated: true)
        } else if row == 1 {
            let vc = ChangePwdVC()
            navigationController?.pushViewController(vc, animated: true)
        } else {
            logoutAlert()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
}

