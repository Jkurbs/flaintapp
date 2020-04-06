//
//  EditArtVC.swift
//  Flaint
//
//  Created by Kerby Jean on 5/10/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//


/* Abstract:
 View controller for editing art
 */

import UIKit

protocol ArtEdited: NSObjectProtocol {
    var newArt: Art? { get set }
}

class EditArtVC: UITableViewController, ArtDescDelegate {
    
    // MARK: - Properties
    
    var artImg: UIImage?
    var art: Art? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var userUID: String?
    
    var artProperties = ArtProperties.self
    
    var titles = ["Title", "Price"]
    var array = ["Title", "Price", "Description", "Style", "Medium", "Substrate", "Width", "Height", "Depth"]
    
    weak var delegate: ArtEdited?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .backgroundColor
        self.title = "Edit Painting"
        self.restorationIdentifier = "EditArtVCRestorationID"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        tableView?.backgroundColor = .backgroundColor
        tableView?.register(EditArtCell.self, forCellReuseIdentifier: EditArtCell.id)
        tableView?.register(InfoTextFieldCell.self, forCellReuseIdentifier: InfoTextFieldCell.id)
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView?.tableFooterView = UIView()
    }
    
    
    // MARK: - Functions
    
    @objc func cancel() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func done() {
        self.navigationItem.addActivityIndicator()
        // Save Edit Art
        
        guard let userId = userUID ?? UserDefaults.standard.string(forKey: .userId), let artId = self.art?.id else { return }
        
        print("USER ID: \(userId)")
        
        let infoCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! InfoTextFieldCell
        let priceCell = tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as! InfoTextFieldCell
        let descCell = tableView.cellForRow(at: IndexPath(row: 0, section: 2))
        let styleCell = tableView.cellForRow(at: IndexPath(row: 0, section: 3)) as! AUPickerCell
        let mediumCell = tableView.cellForRow(at: IndexPath(row: 0, section: 4)) as! AUPickerCell
        let substrateCell = tableView.cellForRow(at: IndexPath(row: 0, section: 5)) as! AUPickerCell
        
        let heightCell = tableView.cellForRow(at: IndexPath(row: 0, section: 6)) as! AUPickerCell
        let widthCell = tableView.cellForRow(at: IndexPath(row: 0, section: 7)) as! AUPickerCell
        let depthCell = tableView.cellForRow(at: IndexPath(row: 0, section: 8)) as! AUPickerCell
        
        if let title = infoCell.textField.text, let price = priceCell.textField.text?.replacingOccurrences(of: "$", with: ""), let description = descCell?.detailTextLabel?.text, let style = styleCell.rightLabel.text, let medium = mediumCell.rightLabel.text, let substrate = substrateCell.rightLabel.text, let height = heightCell.rightLabel.text?.replacingOccurrences(of: "cm", with: ""), let width = widthCell.rightLabel.text?.replacingOccurrences(of: "cm", with: ""), let depth = depthCell.rightLabel.text?.replacingOccurrences(of: "cm", with: "") {
            
            let data = ["title": title, "price": price, "description": description, "style": style, "medium": medium, "substrate": substrate, "height": height, "width": width, "depth": depth] as [String: Any]
            
            DataService.shared.editArt(userId: userId, artId: artId, style: style, data: data) { success, _ in
                if !success {
                    print("Error updating art")
                } else {
                    self.showMessage("Painting Successfully updated", type: .success)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
}

// MARK: - TableView

extension EditArtVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        9
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return titles.count
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        let cell = PickerCell(type: .default, reuseIdentifier: PickerCell.id)
        
        let title = array[indexPath.section]
        let range = Array(10...100).map(String.init)
        
        switch section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: EditArtCell.id, for: indexPath) as! EditArtCell
            cell.configure(imgUrl: art?.imgUrl)
            return cell
        case 1:
            let title = self.titles[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: InfoTextFieldCell.id, for: indexPath) as! InfoTextFieldCell
            cell.configure(title: title, art: art!)
            return cell
        case 2:
            let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
            cell.textLabel?.text = title
            cell.textLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            cell.accessoryType = .disclosureIndicator
            cell.detailTextLabel?.text = art?.description
            return cell
        case 3:
            cell.leftLabel.text = title
            cell.rightLabel.text = "\(art?.style ?? "Unkown")"
            cell.values = artProperties.style.values
            if let index = cell.values.firstIndex(of: art?.style ?? "") {
                cell.selectedRow = index
            }
            return cell
        case 4:
            cell.leftLabel.text = title
            cell.rightLabel.text = "\(art?.medium ?? "Unkown")"
            cell.values = artProperties.medium.values
            if let index = cell.values.firstIndex(of: art?.medium ?? "") {
                cell.selectedRow = index
            }
            return cell
        case 5:
            cell.leftLabel.text = title
            cell.rightLabel.text = "\(art?.substrate ?? "Unkown")"
            cell.values = artProperties.substrate.values
            if let index = cell.values.firstIndex(of: art?.substrate ?? "") {
                cell.selectedRow = index
            }
            return cell
        case 6, 7, 8:
            cell.leftLabel.text = title
            cell.rightLabel.text = "\(art?.width ?? "")cm"
            cell.values = range
            return cell
        default:
            break
        }
        return UITableViewCell()

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        if section == 0 {
            return view.frame.height / 4
        } else if section == 1 {
            return 45.0
        } else if section == 2 {
            if let cell = tableView.cellForRow(at: indexPath) as? AddDescCell {
                if !cell.textView.isFirstResponder {
                    return 80.0
                }
            }
            return UITableView.automaticDimension
        } else {
            if let cell = tableView.cellForRow(at: indexPath) as? AUPickerCell {
                return cell.height
            }
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 2 && indexPath.row == 0 {
            let vc = DescriptionVC()
            vc.textView.text = art?.description
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        if let cell = tableView.cellForRow(at: indexPath) as? AUPickerCell {
            cell.selectedInTableView(tableView)
        }
    }
    
    func finishPassing(description: String) {
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 2))
        cell?.detailTextLabel?.text = "\(description)"
    }
}
