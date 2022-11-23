//
//  CovidDetailViewController.swift
//  TodayCOVID19
//
//  Created by 김초원 on 2022/11/23.
//

import UIKit

class CovidDetailViewController: UITableViewController {

    
    @IBOutlet weak var newCaseCell: UITableViewCell!
    @IBOutlet weak var todayCaseCell: UITableViewCell!
    @IBOutlet weak var recoveredCell: UITableViewCell!
    @IBOutlet weak var deathCell: UITableViewCell!
    @IBOutlet weak var percentageCell: UITableViewCell!
    @IBOutlet weak var overseaInflowCell: UITableViewCell!
    @IBOutlet weak var regionalOutBreakCell: UITableViewCell!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
