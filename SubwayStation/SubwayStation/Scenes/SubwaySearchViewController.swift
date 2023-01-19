//
//  SubwaySearchViewController.swift
//  SubwayStation
//
//  Created by 김초원 on 2023/01/18.
//

import UIKit
import SnapKit
import Alamofire

class SubwaySearchViewController: UIViewController {
    var stations: [Station] = []
    var searchKeyword: String = ""
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationItems()
        setTableViewLayout()
    }
    
    private func setNavigationItems() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "지하철 역"
        
        // search bar 추가
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "지하철 역을 검색해주세요"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
    }
    
    private func setTableViewLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
        tableView.isHidden = true
    }

    
    private func requestStationName(searchName: String) {
        let urlString = "http://openAPI.seoul.go.kr:8088/sample/json/SearchInfoBySubwayNameService/1/5/\(searchName)"
        
        AF
            .request(urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            .responseDecodable(of: StationResponseModel.self) { [weak self] response in
                guard case .success(let data) = response.result else {
                    return
                }
                self?.setStationNameOnTableView(stations: data.stations)
            }
            .resume()
    }
    
    private func setStationNameOnTableView(stations: [Station]) {
        self.stations = stations
        tableView.reloadData()
    }

}

extension SubwaySearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tableView.isHidden = false
        tableView.reloadData()
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        tableView.isHidden = true
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // requestStationName(searchText) -> 데이터 받아오기 성공하면 tableView에 뿌려주기
        requestStationName(searchName: searchText)
    }
}

extension SubwaySearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SearchTableViewCell()
        let title = self.stations[indexPath.row].stationName
        let subTitle = self.stations[indexPath.row].lineNumber
        cell.setUp(title: title, subTitle: subTitle)

        return cell
    }
}

extension SubwaySearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc =  StationDetailViewController()
        vc.stationName = self.stations[indexPath.row].stationName
        navigationController?.pushViewController(vc, animated: true)
    }
}
