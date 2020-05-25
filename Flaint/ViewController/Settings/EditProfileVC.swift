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
    
    lazy var viewModel = AccountViewModel()
    private var handle: AuthStateDidChangeListenerHandle!
    var user: Users!
    
    // MARK: - UI Elements
    
    var indicator = UIActivityIndicatorView()
    var userId: String?
    
    // MARK: - View  Lifecycle
    
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
        self.view.backgroundColor = .systemBackground
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        navigationItem.rightBarButtonItem = saveButton
    
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
        viewModel.viewController = self
        viewModel.tableView = self.tableView
        tableView.separatorStyle = .none
        
        tableView.register(PictureCell.self, forCellReuseIdentifier: PictureCell.id)
        tableView.register(EditAccountGeneralCell.self, forCellReuseIdentifier: EditAccountGeneralCell.id)
//        tableView.register(EditAccountPrivateCell.self, forCellReuseIdentifier: EditAccountPrivateCell.id)
        
        tableView.backgroundColor = .systemBackground
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
        self.navigationItem.addActivityIndicator()
        if let pictureCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? PictureCell, let displayNameCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? EditAccountGeneralCell {
            
//              let emailCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? EditAccountPrivateCell, let phoneCell = tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as? EditAccountPrivateCell
            
            guard let displayname = displayNameCell.textField.text, let image = pictureCell.userImgView.image, let userId = self.userId else {
                return
            }
            
            DataService.shared.updateUserData(userId, displayname, image) { success, error in
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
        DataService.shared.fetchCurrentUser(userID: userId) { result in
            if let result = try? result.get() as? Users {
                DispatchQueue.main.async {
                    self.userId = result.userId
                    self.viewModel.user = result
                    self.tableView.reloadData()
                    self.indicator.stopAnimating()
                }
            }
        }
    }
}
