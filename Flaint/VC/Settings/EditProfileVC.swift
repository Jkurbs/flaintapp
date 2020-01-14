//
//  EditProfileVC.swift
//  Flaint
//
//  Created by Kerby Jean on 7/2/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit
import FirebaseAuth

final class EditProfileVC: UITableViewController {
    
    fileprivate let viewModel = AccountViewModel()
    private var handle: AuthStateDidChangeListenerHandle!
    var user: User!
    // MARK: - UI Elements
    
    var indicator = UIActivityIndicatorView()
    var userId: String?
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isToolbarHidden = true
    }
    
    // MARK: - Setup UI
    
    func setupUI() {
        
        self.title = "Edit Account"
        self.view.backgroundColor = .backgroundColor        
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        navigationItem.rightBarButtonItem = saveButton
    
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
        viewModel.viewController = self
        viewModel.tableView = self.tableView
        tableView.separatorStyle = .none
        
        tableView.register(PictureCell.self, forCellReuseIdentifier: PictureCell.id)
        tableView.register(EditAccountGeneralCell.self, forCellReuseIdentifier: EditAccountGeneralCell.id)
        tableView.register(EditAccountPrivateCell.self, forCellReuseIdentifier: EditAccountPrivateCell.id)
        
        tableView.backgroundColor = .backgroundColor
        tableView.allowsSelection = true
        tableView.tableFooterView = UIView()
        
        indicator.frame = CGRect(x: 0, y: 150, width: 0, height: 0)
        indicator.center.x = view.center.x
        if #available(iOS 13.0, *) {
            indicator.style = UIActivityIndicatorView.Style.medium
        } else {
            // Fallback on earlier versions
            indicator.style = .gray
        }
        view.addSubview(indicator)
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
    }
    
    // MARK: - Actions
    
    @objc func save() {
//        let username = usernameCell.textField.text?.trimmingCharacters(in: .whitespaces)
        self.navigationItem.addActivityIndicator()
        if let pictureCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? PictureCell, let displayNameCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? EditAccountGeneralCell, let emailCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? EditAccountPrivateCell, let phoneCell = tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as? EditAccountPrivateCell  {
            guard let displayname = displayNameCell.textField.text, let email = emailCell.valueLabel.text, let phone = phoneCell.valueLabel.text, let image = pictureCell.userImgView.image else {
                return
            }
            DataService.shared.updateUserData(displayname, email, phone, image) { (success, error) in
                if !success {
                    self.showMessage("An error occured", type: .error)
                } else {
                    DispatchQueue.main.async {
                        self.showMessage("Successfully updated account", type: .success)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    // MARK: - Fetch Data
    
    func fetchData() {
        DataService.shared.fetchCurrentUser(userID: userId) { (success, error, user) in
            if !success {
                print("error:", error!.localizedDescription)
            } else {
                self.viewModel.user = user
                self.tableView.reloadData()
                self.indicator.stopAnimating()
            }
        }
    }
}
