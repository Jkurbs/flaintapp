//
//  AddInfoVC.swift
//  Flaint
//
//  Created by Kerby Jean on 5/18/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class AddInfoVC: UITableViewController, ArtDescDelegate {
        
    // MARK: - Properties
    
    var expandingCellHeight: CGFloat = 100
    
    var styles = ["Abstract", "Realism", "Surrealism", "Pop art"]
    var substrates = ["Canvas", "Wood", "Paper", "Metal"]
    var mediums = ["Oil", "Watercolor", "Acrylic"]
    
    var prediction: String?
    var classifications: Classifications?
    
    var artImage: UIImage!
    var imgUrl = ""
    var artId = ""
    var ref: StorageReference?
    
    var artsCount: Int?
    
    var expandedSectionIndexPath: IndexPath?
    var expandedSectionValue: String?
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    // MARK: - Functions
    
    func setup() {
        
        self.title = "Add details"
        self.restorationIdentifier = UIView.id
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        tableView?.register(AddArtInfoCell.self, forCellReuseIdentifier: "AddArtInfoCell")
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView?.tableFooterView = UIView()
        
        switch self.prediction {
        case "Realism":
            classifications = Classifications(style: self.prediction ?? "Unknow", substrate: "Canvas", medium: "Oil")
        case "Surrealism":
            classifications = Classifications(style: self.prediction ?? "Unknow", substrate: "Canvas", medium: "Acrylic")
        case "Abstract":
            classifications = Classifications(style: self.prediction ?? "Unknow", substrate: "Canvas", medium: "Acrylic")
        case "Pop-art":
            classifications = Classifications(style: self.prediction ?? "Unknow", substrate: "Canvas", medium: "Oil")
        default:
            print("default")
        }
        
        setupKeyboardNotification()
    }
    
    @objc func cancel() {
        alert()
    }
    
    @objc func done() {
        
        let infoCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! AddArtInfoCell
        let descCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0))!
        let styleCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! AUPickerCell
        let substrateCell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! AUPickerCell
        let mediumCell = tableView.cellForRow(at: IndexPath(row: 0, section: 3)) as! AUPickerCell
        let heightCell = tableView.cellForRow(at: IndexPath(row: 0, section: 4)) as! AUPickerCell
        let widthCell = tableView.cellForRow(at: IndexPath(row: 0, section: 5)) as! AUPickerCell
        let depthCell = tableView.cellForRow(at: IndexPath(row: 0, section: 6)) as! AUPickerCell
        
        guard let title = infoCell.titleField.text, let price = infoCell.priceField.text?.replacingOccurrences(of: "$", with: ""), let description = descCell.detailTextLabel?.text, let style = styleCell.rightLabel.text, let substrate = substrateCell.rightLabel.text, let medium = mediumCell.rightLabel.text, let height = heightCell.rightLabel.text?.replacingOccurrences(of: "cm", with: ""), let width = widthCell.rightLabel.text?.replacingOccurrences(of: "cm", with: ""), let depth = depthCell.rightLabel.text?.replacingOccurrences(of: "cm", with: ""), let imgData = artImage.jpegData(compressionQuality: 1.0) else {
            self.showMessage("Every value must be filled", type: .error)
            return
        }

        
        self.navigationItem.addActivityIndicator()
        let date = CachedDateFormattingHelper.shared.formatTodayDate()
        
        let data = ["title": title, "price": price, "sentiment": "sentiment", "description": description, "style": style, "substrate": substrate, "medium": medium, "height": height, "width": width, "depth": depth, "date": date, "index": artsCount ?? 0, "imgUrl": self.imgUrl] as [String: Any]
        DataService.shared.createArt(userID: (Auth.auth().currentUser?.uid)!, artId: self.artId, values: data, imgData: imgData) { success, error in
            if !success {
                self.showMessage("Error saving painting", type: .error)
            } else {
                self.dismiss(animated: true, completion: nil)
                self.navigationItem.removeActivityIndicator("Done", #selector(self.done))
            }
        }
    }
    
    func alert() {
        let alert = UIAlertController(title: "Are you sure want to cancel?", message: nil, preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .default) { _ in
            if self.ref != nil {
                self.ref!.delete { error in
                    if error != nil {
                        self.navigationController?.dismiss(animated: true, completion: nil)
                    } else {
                        self.navigationController?.dismiss(animated: true, completion: nil)
                    }
                }
            } else {
                self.navigationController?.dismiss(animated: true, completion: nil)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(yes)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func textChanged() {
        
        let infoCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! AddArtInfoCell
        let descCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! AddDescCell
        let styleCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! AUPickerCell
        let substrateCell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! AUPickerCell
        let mediumCell = tableView.cellForRow(at: IndexPath(row: 0, section: 3)) as! AUPickerCell
        let heightCell = tableView.cellForRow(at: IndexPath(row: 0, section: 4)) as! AUPickerCell
        let widthCell = tableView.cellForRow(at: IndexPath(row: 0, section: 3)) as! AUPickerCell
        let depthCell = tableView.cellForRow(at: IndexPath(row: 0, section: 4)) as! AUPickerCell
        
        if let style = styleCell.rightLabel.text, let substrate = substrateCell.rightLabel.text, let medium = mediumCell.rightLabel.text, let height = heightCell.rightLabel.text, let width = widthCell.rightLabel.text, let depth = depthCell.rightLabel.text {
            if infoCell.titleField.hasText && infoCell.priceField.hasText && descCell.textView.hasText && !style.isEmpty && !substrate.isEmpty && !medium.isEmpty && !height.isEmpty && !width.isEmpty && !depth.isEmpty {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            } else {
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            }
        }
    }
}


// MARK: - TableView
extension AddInfoVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        7
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = PickerCell(type: .default, reuseIdentifier: PickerCell.id)
        cell.delegate = self
        
        let range = Array(10...100).map(String.init)
        
        if indexPath.section == 0 && indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddArtInfoCell", for: indexPath) as! AddArtInfoCell
            cell.viewController = self
            cell.configure(img: artImage)
            return cell
        } else if indexPath.section == 0 && indexPath.row == 1 {
            let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
            cell.textLabel?.text = "Description"
            cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
            cell.accessoryType = .disclosureIndicator
            return cell
        } else if indexPath.section == 1 {
            cell.leftLabel.text = "Style"
            cell.values = ["Abstract", "Realism", "Surrealism", "Pop art"]
            if  let index = self.styles.firstIndex(of: self.classifications?.style ?? "") {
                cell.selectedRow = index
            }
            return cell
        } else if indexPath.section == 2 {
            cell.leftLabel.text = "Medium"
            cell.values = mediums
            if let index = self.mediums.firstIndex(of: self.classifications?.medium ?? "") {
                cell.selectedRow = index
            }
            return cell
        } else if indexPath.section == 3 {
            cell.leftLabel.text = "Substrate"
            cell.values = substrates
            if let index = self.substrates.firstIndex(of: self.classifications?.substrate ?? "" ) {
                cell.selectedRow = index
            }
            return cell
        } else if indexPath.section == 4 {
            cell.leftLabel.text = "Width"
            cell.values = range
            return cell
        } else if indexPath.section == 5 {
            cell.leftLabel.text = "Height"
            cell.values = range
            return cell
        } else {
            cell.leftLabel.text = "Depth"
            cell.values = range
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 && indexPath.row == 0 {
            return 90.0
        }
        
        if indexPath.section == 0 && indexPath.row == 1 {
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
        
        if let indexPath = self.expandedSectionIndexPath, let cell = tableView.cellForRow(at: indexPath) as? PickerCell {
            if !cell.isSelected {
                tableView.reloadRows(at: [indexPath], with: .automatic)
                cell.rightLabel.text = self.expandedSectionValue
            }
        }

        if let descriptionCell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) {
            if indexPath.section == 0 && indexPath.row == 1 {
                let vc = DescriptionVC()
                vc.artDescription = descriptionCell.detailTextLabel?.text ?? ""
                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        if let cell = tableView.cellForRow(at: indexPath) as? AUPickerCell {
            self.view.endEditing(true)
            self.expandedSectionIndexPath = indexPath
            cell.selectedInTableView(tableView)
        }
        tableView.scrollToRow(at: indexPath, at: .none, animated: true)
    }
    
    func finishPassing(description: String) {
        let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0))
        cell?.detailTextLabel?.text = "\(description)"
    }
}

extension AddInfoVC {
    
     func setupKeyboardNotification() {
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIWindow.keyboardWillShowNotification, object: nil)
     }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        //TODO: Fix - Reload tableViewSection when keyboard is up.
        if let expandedSectionIndexPath = self.expandedSectionIndexPath {
            self.tableView.reloadRows(at: [expandedSectionIndexPath], with: .automatic)
        }
    }
}


// MARK: - AUPickerCellDelegate

extension AddInfoVC: AUPickerCellDelegate {
    
    func auPickerCell(_ cell: AUPickerCell, didPick row: Int, value: Any) {
        if let value = value as? String {
            self.expandedSectionValue = value
        }
    }
}
