//
//  HomeViewController.swift
//  NetflixMainClone
//
//  Created by 김초원 on 2023/01/13.
//

import UIKit    // UI의 핵심 오브젝트를 구성하기 위한 라이브러리 가져오기

class HomeViewController: UICollectionViewController {
    
    var contents: [Content] = []    // Content.plist로부터 가져온 데이터를 저장하기 위한 배열
    
    // 맨 처음 뷰가 로딩되면 호출되는 메소드
    override func viewDidLoad() {
        super.viewDidLoad() // 오버라이드라 상위 메소드 우선 호출
        
        // navigation 설정
        navigationController?.navigationBar.backgroundColor = .clear    // navigationController의 navigationBar의 배경색을 없애줌
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)    // navigationController의 navigationBar의 배경 이미지를 빈 이미지로 설정
        navigationController?.navigationBar.shadowImage = UIImage()     // navigationController의 navigationBar의 그림자 이미지를 빈 이미지로 설정 (그냥 clear시켜준다는 의미인 듯??)
        navigationController?.hidesBarsOnSwipe = true       // 스와이프하면 navigationBar가 hide되도록 설정 (아래에서 위로 스와이프하면 네브바가 숨겨지는,,!)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "netflix_icon"), style: .plain, target: nil, action: nil)  // "netflix_icon"이름의 이미지를 가진 bar button 아이템을 왼쪽에 추가
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle"), style: .plain, target: nil, action: nil)  // 사람 모양의 이미지를 가진 bar button 아이템을 오른쪽에 추가
        
        // 데이터 설정, 가져오기
        self.contents = self.getContents()
        
        // CollectionView의 Item(Cell) 설정, 즉, CollectionView가 어떤 구색을 갖춘 Cell을 포함시킬건지 그 Cell의 정보를 등록
        self.collectionView.register(ContentCollectionViewCell.self, forCellWithReuseIdentifier: "ContentCollectionViewCell")
        self.collectionView.register(ContentCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ContentCollectionViewHeader")   // 헤더 라벨 등록

    }
    
    func getContents() -> [Content] {
        // path값을 통해 Content.plist에 접근하여 plist내의 데이터를 얻고, decode하여 Content 배열로 바꾸기
        guard let path = Bundle.main.path(forResource: "Content", ofType: "plist"), // Bundle은 구체적으로 뭐하는 애일까
              let data = FileManager.default.contents(atPath: path),    // FileManager를 이용하여 위에서 얻은 경로값(path)을 통해 해당되는 데이터 가져오기
              let list = try? PropertyListDecoder().decode([Content].self, from: data) else { return [] }   // PropertyListDecoder를 통해, 위에서 가져온 data를 'Content 배열' 타입으로 decode해줌
        return list
    }
}

// UICollectionView DataSource, Delegate 설정
extension HomeViewController {
    // 섹션 당 보여질 셀의 개수
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 데이터 구성 형태에 따라 0번째 섹션만 1개의 셀을 가지도록 고정, 그 이후부터의 섹션은 그 안의 contentItem의 개수만큼 셀을 가져야 함
        switch section {
        case 0:
            return 1
        default:
            return contents[section].contentItem.count
        }
    }
    
    // CollectionView Cell 설정 (CollectionView을 어떤 Cell들로 구성할지, 그 Cell을 반환)
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // content 데이터의 섹션 타입에 따라 셀을 다르게 반환하기 위한 Switch문
        switch contents[indexPath.section].sectionType {
        case .basic, .large:
            guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "ContentCollectionViewCell", for: indexPath) as? ContentCollectionViewCell else { return UICollectionViewCell() }
                // dequeueReusableCell은 withReuseIdentifier로 전달되는 문자열값과 같은 이름의 셀 클래스를 찾아서 반환해주는 메소드?? , 반환할 셀을 못찾으면 기본 UICollectionViewCell을 반환
            cell.imageView.image = self.contents[indexPath.section].contentItem[indexPath.row].image    // contents 배열 내에서 indexPath를 사용하여 해당 위치의 image데이터를 가지고 imageView의 이미지로 포함시킴
            return cell // 위에서 가지고 와서 설정한 Cell을 반환
        default:
            return UICollectionViewCell()   // 기본셀 반환으로 임시 처리
        }
    }
    
    // Header로 쓰일 View 설정
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // View의 종류(kind)가 섹션의 헤더인지 아닌지에 따라 반환 값을 다르게 설정
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ContentCollectionViewHeader", for: indexPath) as? ContentCollectionViewHeader else { fatalError("Could not dequeue Header") }
                // dequeueReusableSupplementaryView 메소드를 사용하여 매개변수로 전달된 kind값의 종류를 가진, 그리고 "ContentCollectionViewHeader"라는 이름을 가진 View를 찾아와서 ContentCollectionViewHeader 타입으로 다운 캐스팅
                // 만약 못 찾으면 "Could not dequeue Header"라는 오류 발생시켜 처리
            headerView.sectionNameLabel.text = self.contents[indexPath.section].sectionName // 위에서 찾아온 헤더용 뷰에 포함되어 있을 label의 text를 contents배열내의 section위치에 따른 sectionName값으로 설정
            return headerView
        } else {
            return UICollectionReusableView()   // view 종류가 헤더가 아니면 그냥 빈 UICollectionReusableView를 반환
        }
    }
    
    // 섹션의 개수 설정
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return contents.count   // 데이터의 가장 상위 묶음(?)의 개수를 반환
    }
    
    // Cell이 선택되었을때의 처리
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 선택된 Cell에 관한 정보를 출력
        let selectedItemName = contents[indexPath.row].sectionName
        print("TEST :: \(selectedItemName)섹션의 \(indexPath.row + 1)번째 컨텐츠가 선택됨")
    }
}
