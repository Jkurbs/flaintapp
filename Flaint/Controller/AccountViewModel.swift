//
//  AccountViewModel.swift
//  Flaint
//
//  Created by Kerby Jean on 7/4/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import Foundation
import UIKit

enum AccountModelItemType {
    case general
    case personal
}

protocol AccountModelItem {
    var type: AccountModelItemType { get }
    var sectionTitle: String? { get }
    var rowCount: Int { get }
}


class AccountViewModel: NSObject {
    
    var items = [AccountModelItem]()
    
    var tableView: UITableView!
    var viewController: UIViewController!
    
    
    var user: Users? {
        didSet {
            guard let user = user else { return }
            let firstName = user.firstName ?? ""
            let imgUrl = user.imgUrl ?? ""
            let lastName = user.lastName ?? ""
            let profileItem = AccountViewModelGeneralItem(imgUrl: imgUrl, name: "\(firstName) \(lastName)")
            self.items.append(profileItem)
            let email = user.email ?? ""
            let phone = user.phone ?? ""
            let emailItem = AccountViewModelPersonalItem(email: email, phone: phone)
            self.items.append(emailItem)
        }
    }
}

extension AccountViewModel: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items[section].rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section]
        switch item.type {
        case .general:
            switch indexPath.row {
            case 0:
                print("ITEM: \(item)")
                if let cell = tableView.dequeueReusableCell(withIdentifier: PictureCell.id, for: indexPath) as? PictureCell {
                    cell.item = item
                    cell.imagePicker = ImagePicker(presentationController: self.viewController, delegate: cell, allowsEditing: true)
                    return cell
                }
            case 1:
                print("ITEM: \(item)")
                if let cell = tableView.dequeueReusableCell(withIdentifier: EditAccountGeneralCell.id, for: indexPath) as? EditAccountGeneralCell {
                    cell.configure(index: 1, title: "Name", item: item)
                    return cell
                }
            default:
                break
            }
        case .personal:
            if indexPath.row == 0 {
                if let cell = tableView.dequeueReusableCell(withIdentifier: EditAccountPrivateCell.id, for: indexPath) as? EditAccountPrivateCell {
                    cell.configure(index: 0, title: "Email", item: item)
                    return cell
                }
            } else if indexPath.row == 1 {
                if let cell = tableView.dequeueReusableCell(withIdentifier: EditAccountPrivateCell.id, for: indexPath) as? EditAccountPrivateCell {
                    cell.configure(index: 1, title: "Phone", item: item)
                    return cell
                }
            }
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            return 160.0
        }
        return 50.0
    }

    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 20, y: 0, width: tableView.frame.width, height: 60.0))
        headerView.backgroundColor = .systemBackground
        let label = UILabel(frame: headerView.frame)
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = UIColor.darkText
        label.text = self.items[section].sectionTitle
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 1.0
        }
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let generalVC = UpdateGeneralInfoVC()
        let personalVC = UpdatePersonalInfoVC()
        
        if indexPath.section == 0 && indexPath.row == 2 {
            generalVC.currentUser = self.user
            viewController.navigationController?.pushViewController(generalVC, animated: true)
        } else if indexPath.section == 1 && indexPath.row == 0 {
            personalVC.isEmail = true
            viewController.navigationController?.pushViewController(personalVC, animated: true)
        } else if indexPath.section == 1 && indexPath.row == 1 {
            viewController.navigationController?.pushViewController(personalVC, animated: true)
        }
    }
}


class AccountViewModelGeneralItem: AccountModelItem {
    var type: AccountModelItemType {
        .general
    }
    
    var sectionTitle: String? {
        nil
    }
    
    var rowCount: Int {
        2
    }
    
    var imgUrl: String
    var name: String
    
    init(imgUrl: String, name: String) {
        self.imgUrl = imgUrl
        self.name = name
    }
}


class AccountViewModelPersonalItem: AccountModelItem {
    var type: AccountModelItemType {
        .personal
    }
    
    var sectionTitle: String? {
        "Private Information"
    }
    
    var rowCount: Int {
        2
    }
    
    var email: String
    var phone: String
    
    
    init(email: String, phone: String) {
        self.email = email
        self.phone = phone
    }
}
