//
//  ShowcaseVC.swift
//  Flaint
//
//  Created by Kerby Jean on 6/13/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit

class ShowcaseVC: UITableViewController {
    
    var titles = ["Title", "Type", "Size"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hero.isEnabled = true
        tableView?.backgroundColor = .backgroundColor
        tableView?.register(EditArtCell.self, forCellReuseIdentifier: "EditArtCell")
        
        tableView?.allowsSelection = false
        view.addSubview(tableView)
        
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditArtCell", for: indexPath) as! EditArtCell
        cell.backgroundColor = .red
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height/2
    }
}
