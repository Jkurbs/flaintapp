//
//  ShareVC.swift
//  Flaint
//
//  Created by Kerby Jean on 11/21/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit
import FirebaseAuth

class ShareVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView!
    
    var artImg: UIImage?
    var art: Art!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.backgroundColor = .backgroundColor
        
        self.title = "Share"
                
        tableView = UITableView(frame: view.frame, style: .grouped)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        tableView.backgroundColor = .backgroundColor
        
        tableView.register(EditArtCell.self, forCellReuseIdentifier: EditArtCell.id)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.sectionHeaderHeight = 70

        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 70))
        let label = UILabel(frame: headerView.frame)
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = .darkText
        label.textAlignment = .center
        label.text = art?.title
        headerView.addSubview(label)
        self.tableView.tableHeaderView = headerView
        view.addSubview(tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
       
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: EditArtCell.id, for: indexPath) as? EditArtCell {
                if let url = art.imgUrl {
                    cell.artImageView.sd_setImage(with: URL(string: url))
                }
             return cell
           }
       }
                     
       let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
       cell.imageView?.image = UIImage(named: "Instagram")
       cell.textLabel?.text = "Instagram stories"
       cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
       cell.accessoryType = .disclosureIndicator
       return cell
   }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return tableView.frame.height / 3
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! EditArtCell
        let img = cell.artImageView.image
        if indexPath.row == 1 {
            // Share to Instagram
            shareToInstagramStories(image: img)
        }
    }
}

extension ShareVC {
    
    func shareToInstagramStories(image: UIImage?) {
        if let storiesUrl = URL(string: "instagram-stories://share") {
            if UIApplication.shared.canOpenURL(storiesUrl) {
                guard let image = image else { return }
                guard let imageData = image.pngData() else { return }
                let pasteboardItems: [String: Any] = [
                    "com.instagram.sharedSticker.stickerImage": imageData,
                    "com.instagram.sharedSticker.backgroundTopColor": "#3498db",
                    "com.instagram.sharedSticker.backgroundBottomColor": "#e74c3c"
                ]
                let pasteboardOptions = [
                    UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(300)
                ]
                UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)
                UIApplication.shared.open(storiesUrl, options: [:], completionHandler: nil)
            } else {
                print("User don't have instagram on their device.")
            }
        }
    }
}
