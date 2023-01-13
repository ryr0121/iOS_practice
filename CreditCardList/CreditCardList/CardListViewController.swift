//
//  CardListViewController.swift
//  CreditCardList
//
//  Created by 김초원 on 2023/01/12.
//

import UIKit    // UI 핵심 오브젝트를 구성하기 위한 프레임워크 가져오기
import Kingfisher   // url 문자열만 가지고 이미지 불러올 수 있게 하는 프레임워크 가져오기
import FirebaseDatabase // Firebase의 realtime database를 사용하기 위한 프레임워크 가져오기


// UITableViewController를 상속함으로써 별도의 Delegate, DataSource를 선언하지 않아도 됨
// 또한, RootView로 TableView를 가지게 됨
class CardListViewController: UITableViewController {

    var ref: DatabaseReference! // Firebase Realtime Database 참조값
    
    var creditCardList: [CreditCard] = []   // CreditCard 구조체를 자료형으로 가지는 배열 선언(이후 DB에서 JSON 데이터를 이 객체들로 파싱할 예정)
    
    // VC가 가장 먼저 로딩될 때 호출되는 메소드
    override func viewDidLoad() {
        super.viewDidLoad() // 오버라이딩한거라 부모 메소드는 호출이 필수인건가,,?
        
        // UITableView Cell 등록
        let nibName = UINib(nibName: "CardListCell", bundle: nil)   // Xib로 구성한 Cell 파일을 nibName을 통해 불러오기,,?
        tableView.register(nibName, forCellReuseIdentifier: "CardListCell") // "CardListCell"라는 이름의 cell을 테이블뷰에 등록
        
        ref = Database.database().reference()   // 이건 구체적으로 뭘까,,DB를 단순히 참조하기만 하는건가
        
        // DB 참조객체를 통해 값을 관찰, snapshot을 통해 값을 찍어와서 파싱 대상인 JSON의 형태로 다운캐스팅(?)
        ref.observe(.value) { snapshot in
            guard let value = snapshot.value as? [String: [String: Any]] else { return }
            
            do {
                // snapshot 내의 value값을 통해 JSON 데이터로 파싱하기 (아래 3줄은 좀 더 알아봐야 할 듯)
                let jsonData = try JSONSerialization.data(withJSONObject: value)
                let cardData = try JSONDecoder().decode([String: CreditCard].self, from: jsonData)
                let cardList = Array(cardData.values)
                self.creditCardList = cardList.sorted(by: { $0.rank < $1.rank })    // 파싱한 데이터를 배열로 바꾼 값들을 rank값을 통해 비교하여 정렬 및 저장
                
                // tableView reload
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            } catch let error {
                print("ERROR JSON Parsing :: \(error.localizedDescription)")    // JSON 데이터 파싱 중 에러가 나오면 description 출력 처리
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
