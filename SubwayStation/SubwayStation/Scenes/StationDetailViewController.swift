//
//  StationDetailViewController.swift
//  SubwayStation
//
//  Created by 김초원 on 2023/01/19.
//

import UIKit
import SnapKit
import Alamofire

class StationDetailViewController: UIViewController {
    var stationName: String = ""
    var arrivalList: [RealTimeArrival] = []
    var stations: [Station] = []
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        return refreshControl
    }()
    
    @objc func fetchData() {
        let urlString = "http://swopenapi.seoul.go.kr/api/subway/sample/json/realtimeStationArrival/0/5/\(stationName.replacingOccurrences(of: "역", with: ""))"
        
        AF
            .request(urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            .responseDecodable(of: StationArrivalResponseModel.self) { [weak self] response in
                self?.refreshControl.endRefreshing()

                guard case .success(let data) = response.result else {
                    
                    let alertController = UIAlertController(
                        title: "네트워크 오류",
                        message: "실시간 도착정보 데이터를 불러올 수 없습니다",
                        preferredStyle: .alert
                    )
                    alertController.addAction(UIAlertAction(title: "확인", style: .default))
                    self?.present(alertController, animated: true)
                    
                    return
                }
                self?.arrivalList = data.realtimeArrivalList
                self?.collectionView.reloadData()
                print(data.realtimeArrivalList)
            }
            .resume()
        
    }


    
    private lazy var collectionView: UICollectionView = {
        
        self.title = self.stationName.replacingOccurrences(of: "역", with: "")
        
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: view.frame.width-32.0, height: 100.0)
        layout.sectionInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(StationDetailColloctionViewCell.self, forCellWithReuseIdentifier: "StationDetailColloctionViewCell")

        collectionView.dataSource = self
        collectionView.refreshControl = refreshControl
 
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { $0.edges.equalToSuperview() }
        fetchData()
    }

}

extension StationDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrivalList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StationDetailColloctionViewCell", for: indexPath) as? StationDetailColloctionViewCell else { return UICollectionViewCell() }
        let title = arrivalList[indexPath.row].line
        let subTitle = arrivalList[indexPath.row].remainTime
        cell.setUp(title: title, subTitle: subTitle)
        
        return cell
    }
}
