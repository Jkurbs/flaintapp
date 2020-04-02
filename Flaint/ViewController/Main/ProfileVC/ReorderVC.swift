//
//  ReorderVC.swift
//  Flaint
//
//  Created by Kerby Jean on 3/19/20.
//  Copyright © 2020 Kerby Jean. All rights reserved.
//

import UIKit

class ReorderVC: UIViewController {
    
    // MARK: - Properties
    
    var tableView: UITableView!
    var arts = [Art]()
    
    private let heightForHeader: CGFloat = 30.0
    
    var doneButton: UIBarButtonItem!
    
    lazy var indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = UIActivityIndicatorView.Style.medium
        view.hidesWhenStopped = true
        return view
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Functions
    
    func setupUI() {
        
        view.backgroundColor = .white
        self.title = "Reorder"
        
        indicator.layer.position.y = view.layer.position.y
        indicator.layer.position.x = view.layer.position.x
        
        indicator.startAnimating()
        view.addSubview(indicator)
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(sendRequest))
        doneButton.isEnabled = false
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = doneButton
        
        tableView = UITableView(frame: view.frame, style: .grouped)
        tableView.register(ReorderCell.self, forCellReuseIdentifier: ReorderCell.id)
        tableView.isEditing = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 80))
        let label = UILabel(frame: headerView.frame)
        label.text = "Drag your arts at the position you would\nlike them to show in your gallery"
        label.numberOfLines = 3
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        headerView.addSubview(label)
        tableView.tableHeaderView = headerView
        view.addSubview(tableView)
    }
    
    @objc func cancel() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func sendRequest() {
        
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        let barButton = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.setRightBarButton(barButton, animated: true)
        activityIndicator.startAnimating()
        
        guard let userId = AuthService.shared.UserID ?? UserDefaults.standard.string(forKey: .userId) else { return }
        DataService.shared.reorderArt(arts: arts, userId: userId) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.navigationController?.dismiss(animated: true, completion: nil)
            }
        }
    }
}

// MARK: TableView Delegate/Datasource

extension ReorderVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: ReorderCell.id, for: indexPath) as? ReorderCell {
            let art = self.arts[indexPath.row]
            cell.art = art
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 30))
        let label = UICreator.create.label("Arts will show from top to bottom.", 12.5, .lightGray, .center, .regular, headerView)
        label.frame = headerView.frame
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        heightForHeader
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        heightForHeader
    }
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let sourceRow = sourceIndexPath.row
        let art = self.arts[sourceRow]
        
        self.arts.remove(at: sourceRow)
        arts.insert(art, at: destinationIndexPath.row)
        
        for index in tableView.indexPathsForVisibleRows! {
            self.arts[index.row].index = index.row
        }
        self.doneButton.isEnabled = true
    }
}
