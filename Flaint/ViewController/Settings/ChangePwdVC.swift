//
//  ChangePwdVC.swift
//  Flaint
//
//  Created by Kerby Jean on 7/2/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit
import FirebaseAuth

class  ChangePwdVC: UITableViewController {
    
    var data = ["Current password", "New password", "Repeat password"]
    
    var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup UI
    
    func setupUI() {
        self.title = "Change Password"
        saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        navigationItem.rightBarButtonItem = saveButton
        tableView.register(TextFieldCell.self, forCellReuseIdentifier: TextFieldCell.id)
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Actions
    
    @objc func save() {
        guard let currentPass = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TextFieldCell, let repeatPass = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? TextFieldCell, let newPass = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? TextFieldCell, currentPass != repeatPass else { return }
        Auth.auth().currentUser?.updatePassword(to: newPass.textField.text!, completion: { error in
            if let err = error {
                self.showMessage(err.localizedDescription, type: .error)
            } else {
                 self.showMessage("Password successfully updated", type: .error)
            }
        })
    }
}

// MARK: - Tableview Delegate/Datasource

extension ChangePwdVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.id, for: indexPath) as! TextFieldCell
        let data = self.data[indexPath.row]
        cell.configure(placeholder: data)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50.0
    }
}
