//
//  LearnMoreViewModel.swift
//  Flaint
//
//  Created by Kerby Jean on 8/15/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import Foundation
import UIKit

enum LearnModelItemType {
    case primary
    case secondary
}

protocol LearnModelItem {
    var type: LearnModelItemType { get }
    var sectionTitle: String? { get }
    var rowCount: Int { get }
}


class LearnMoreViewModel: NSObject {
    
    var items = [LearnModelItem]()
    
    var tableView: UITableView!
    var viewController: UIViewController!
    var artImg: UIImage?
    
    
    var art: Art? {
        didSet {
            guard let art = art else {
                return
            }
            
            if let title = art.title {
                let imgUrl = art.imgUrl ?? ""
                let style = art.style ?? "Uknown"
                let medium = art.medium ?? "Uknown"
                let substrate = art.substrate ?? "Uknown"
                let size =  "\(art.width ?? "")cm x \(art.height ?? "")cm"
                let price = "$\(art.price ?? "$0.00")"
                let date = art.date ?? ""
                
                let primaryItem = LearnViewModelGeneralItem(title: title, imgUrl: imgUrl, style: style, medium: medium, substrate: substrate, size: size, price: price, date: date)
                self.items.append(primaryItem)
            }
            if let description = art.description {
                let secondaryItem = LearnViewModelMoreItem(description: description)
                self.items.append(secondaryItem)
            }
        }
    }
    
    
    override init() {
        super.init()
        
    }
}

extension LearnMoreViewModel: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items[section].rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section]
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "test")
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 15)
        cell.detailTextLabel?.textColor = .darkText
        switch item.type {
        case .primary:
            let item = item as! LearnViewModelGeneralItem
            switch indexPath.row {
            case 0:
                if let cell = tableView.dequeueReusableCell(withIdentifier: EditArtCell.id, for: indexPath) as? EditArtCell {
                     cell.artImg = self.artImg
                     cell.item = item
                    return cell
                }
            case 1:
                cell.textLabel?.text = "Style"
                cell.detailTextLabel?.text = item.style
                return cell
            case 2:
                cell.textLabel?.text = "Medium"
                cell.detailTextLabel?.text = item.medium
                return cell
            case 3:
                cell.textLabel?.text = "Substrate"
                cell.detailTextLabel?.text = item.substrate
                return cell
            case 4:
                cell.textLabel?.text = "Size"
                cell.detailTextLabel?.text = item.size
                return cell
            case 5:
                cell.textLabel?.text = "Price"
                cell.detailTextLabel?.text = item.price
                return cell
            case 6:
                cell.textLabel?.text = "Date"
                cell.detailTextLabel?.text = item.date
                return cell
            default:
                return cell
            }
        case .secondary:
            let item = item as! LearnViewModelMoreItem
            if let cell = tableView.dequeueReusableCell(withIdentifier: LearnMoreDescCell.id, for: indexPath) as? LearnMoreDescCell {
            cell.artDescription = item.description
            return cell
            }
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let width = viewController.view.frame.width
        let descHeight = LearnMoreDescCell.textHeight(art!.description, width: width)
        let row = indexPath.row
        if indexPath.section == 0 {
            if row == 0 {
                return 300.0
            } else {
                return 45.0
            }
        }
        return descHeight
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60.0))
        if section == 0 {
            headerView.backgroundColor = .backgroundColor
        } else {
            headerView.backgroundColor = .white
        }
        let label = UILabel(frame: headerView.bounds)
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = UIColor.darkText
        label.textAlignment = .center
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
}


class LearnViewModelGeneralItem: LearnModelItem {
    var type: LearnModelItemType {
        .primary
    }
    
    var sectionTitle: String? {
        nil
    }
    
    var rowCount: Int {
        7
    }
    
    var title: String
    var imgUrl: String
    var style: String
    var medium: String
    var substrate: String
    var size: String
    var price: String
    var date: String
    
    init(title: String, imgUrl: String, style: String, medium: String, substrate: String, size: String, price: String, date: String) {
        self.title = title
        self.imgUrl = imgUrl
        self.style = style
        self.medium = medium
        self.substrate = substrate
        self.size = size
        self.price = price
        self.date = date
    }
}


class LearnViewModelMoreItem: LearnModelItem {
    var type: LearnModelItemType {
        .secondary
    }
    
    var sectionTitle: String? {
        "Description"
    }
    
    var rowCount: Int {
        1
    }
    
    var description: String
    
    
    init(description: String) {
        self.description = description
    }
}
