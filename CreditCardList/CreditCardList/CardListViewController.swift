//
//  CardListViewController.swift
//  CreditCardList
//
//  Created by 김초원 on 2023/01/12.
//

import UIKit
import Kingfisher
import FirebaseDatabase


// UITableViewController를 상속함으로써 별도의 Delegate, DataSource를 선언하지 않아도 됨
// 또한, RootView로 TableView를 가지게 됨
class CardListViewController: UITableViewController {

    var ref: DatabaseReference! // Firebase Realtime Database 참조값
    
    var creditCardList: [CreditCard] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UITableView Cell 등록
        let nibName = UINib(nibName: "CardListCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "CardListCell")
        
        ref = Database.database().reference()
        
        ref.observe(.value) { snapshot in
            guard let value = snapshot.value as? [String: [String: Any]] else { return }
            
            do {
                
                // snapshot 내의 value값을 통해 JSON 데이터로 파싱하기
                let jsonData = try JSONSerialization.data(withJSONObject: value)
                let cardData = try JSONDecoder().decode([String: CreditCard].self, from: jsonData)
                let cardList = Array(cardData.values)
                self.creditCardList = cardList.sorted(by: { $0.rank < $1.rank })
                
                // tableView reload
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            } catch let error {
                print("ERROR JSON Parsing :: \(error.localizedDescription)")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.creditCardList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CardListCell", for: indexPath) as? CardListCell else { return UITableViewCell() }
        
        cell.rankLabel.text = "\(self.creditCardList[indexPath.row].rank)위"
        cell.promotionLabel.text = "\(self.creditCardList[indexPath.row].promotionDetail.amount)원 증정"
        cell.cardNameLabel.text = "\(self.creditCardList[indexPath.row].name)"
        
        let imgURL = URL(string: self.creditCardList[indexPath.row].cardImageURL)
        cell.cardImgView.kf.setImage(with: imgURL)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 카드 혜택 상세화면 전달
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let detailViewController = storyboard.instantiateViewController(identifier: "CardDetailViewController") as? CardDetailViewController else { return }
        detailViewController.promotionDetail = creditCardList[indexPath.row].promotionDetail
        self.show(detailViewController, sender: nil)
        
        // 방법 1
        let cardID = creditCardList[indexPath.row].id
        ref.child("Item\(cardID)/isSelected").setValue(true)
        
        // 방법 2
//        ref.queryOrdered(byChild: "id").queryEqual(toValue: cardID).observe(.value) { [weak self] snapshot in
//            guard let self = self,
//                  let value = snapshot.value as? [String: [String: Any]],
//                  let key = value.keys.first else { return }
//
//            self.ref.child("\(key)/isSelected").setValue(true)
//
//        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // 방법 1
            let cardID = creditCardList[indexPath.row].id
            ref.child("Item\(cardID)").removeValue()
            
            // 방법 2
//            ref.queryOrdered(byChild: "id").queryEqual(toValue: cardID).observe(.value) { [weak self] snapshot in
//                guard let self = self,
//                      let value = snapshot.value as? [String: [String: Any]],
//                      let key = value.keys.first else { return }
//                self.ref.child("\(key)").removeValue()
//            }

        }
    }
}
