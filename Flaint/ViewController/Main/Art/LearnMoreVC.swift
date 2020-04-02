//
//  LearnMoreVC.swift
//  Flaint
//
//  Created by Kerby Jean on 6/8/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit
import FirebaseAuth

class LearnMoreVC: UIViewController {
    
    // MARK: - Properties
    
    var tableView: UITableView!
    
    fileprivate let viewModel = LearnMoreViewModel()
    
    var artImg: UIImage?
    var userId: String?
    
    var art: Art! {
        didSet {
            viewModel.art = art
        }
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    
    // MARK: - Functions
    
    func setupViews() {
        
        view.backgroundColor = .backgroundColor
         self.navigationController?.isToolbarHidden = true
         
         let rightButton = UIBarButtonItem(image: UIImage(named: "Menu-32"), style: .done, target: self, action: #selector(options))
         navigationItem.rightBarButtonItem = rightButton
         
         tableView = UITableView(frame: view.frame, style: .grouped)
         tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
         tableView.backgroundColor = .backgroundColor
         
         tableView.register(EditArtCell.self, forCellReuseIdentifier: EditArtCell.id)
         tableView.register(UITableViewCell.self, forCellReuseIdentifier: "test")
         tableView.register(LearnMoreDescCell.self, forCellReuseIdentifier: "LearnMoreDescCell")
         
         tableView.delegate = viewModel
         tableView.dataSource = viewModel
         viewModel.viewController = self
         viewModel.tableView = self.tableView
         
         tableView.rowHeight = UITableView.automaticDimension
         tableView.estimatedRowHeight = 200
         tableView.allowsSelection = false
         tableView.sectionHeaderHeight = 70
         
         let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 70))
         let label = UILabel(frame: headerView.frame)
         label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
         label.textColor = .darkText
         label.textAlignment = .center
         label.text = viewModel.art?.title
         headerView.addSubview(label)
         self.tableView.tableHeaderView = headerView
         view.addSubview(tableView)
    }
    
    
    @objc func options() {
        let alert = UIAlertController(title: "More", message: nil, preferredStyle: .actionSheet)
        let editAction = UIAlertAction(title: "Edit", style: .default) { _ in
            // Edit Art
            let vc = EditArtVC()
            vc.artImg = self.artImg
            vc.art = self.art
            let nav = UINavigationController(rootViewController: vc)
            self.navigationController?.present(nav, animated: true, completion: nil)
        }
        
        _ = UIAlertAction(title: "Share", style: .default) { _ in
            // Take Picture
            
            // Share Art
            let activityViewController = UIActivityViewController(activityItems: ["test" as NSString], applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: nil)
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            let deleteAlert = UIAlertController(title: "Are you sure you want to delete it from your gallery?", message: nil, preferredStyle: .actionSheet)
            let yesAction = UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                // Delete art
                
                DataService.shared.deleteArt(userId: self.userId ?? Auth.auth().currentUser!.uid, artId: self.art.id, artStyle: self.art.style) { result in
                    if let _ = try? result.get() {
                        self.showMessage("Successfully deleted", type: .success)
                    } else {
                        self.showMessage("Error while deleting", type: .error)
                    }
                }
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            deleteAlert.addAction(yesAction)
            deleteAlert.addAction(cancelAction)
            self.present(deleteAlert, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(editAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}
