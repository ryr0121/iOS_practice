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
    
    var covidOverview: CovidOverview?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    func configureView() {
        guard let covidOverview = self.covidOverview else { return }
        self.title = covidOverview.countryName
        self.newCaseCell.detailTextLabel?.text = "\(covidOverview.newCase)명"
        self.todayCaseCell.detailTextLabel?.text = "\(covidOverview.totalCase)명"
        self.recoveredCell.detailTextLabel?.text = "\(covidOverview.recovered)명"
        self.deathCell.detailTextLabel?.text = "\(covidOverview.death)명"
        self.percentageCell.detailTextLabel?.text = "\(covidOverview.percentage)%"
        self.overseaInflowCell.detailTextLabel?.text = "\(covidOverview.newFcase)명"
        self.regionalOutBreakCell.detailTextLabel?.text = "\(covidOverview.newCcase)명"
    }
}
