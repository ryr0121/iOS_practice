//
//  ContentCollectionViewCell.swift
//  NetflixMainClone
//
//  Created by 김초원 on 2023/01/13.
//

import UIKit    // UI의 핵심 오브젝트를 구성하기 위한 라이브러리 가져오기
import SnapKit  // 코드를 이용하여 오토레이아웃을 설정할 수 있게 하는 라이브러리 가져오기

// UICollectionViewCell을 커스텀한 클래스 정의
class ContentCollectionViewCell: UICollectionViewCell {
    let imageView = UIImageView()   // Cell안에 포스터 이미지만 넣을거라 imageView 선언
    
    // layoutSubviews 메소드가 구체적으로 뭐해주는 메소드지,,?
    override func layoutSubviews() {
        super.layoutSubviews()  // 오버라이드니까 상위 메소드 호출
        
        // Cell에 기본적으로 포함된 contentView에 접근하여 UI 관련 설정
        self.contentView.backgroundColor = .white   // Cell의 배경색을 흰색으로 설정
        self.contentView.layer.cornerRadius = 5     // Cell의 테두리 둥글기를 5로 설정
        self.contentView.clipsToBounds = true       // clipsToBounds가 뭐지 -> subView가 superView의 밖으로 튀어나갈 경우 잘리는지(true) 아닌지(false)를 설정, contentView가 Cell의 밖으로 튀어나가면 잘리도록 설정해준다는건가?
        
        imageView.contentMode = .scaleAspectFill    // imageView에 포함되는 이미지가 어떤 모드로 포함될건지 설정, 비율이 상하지 않게 imageView 크기에 맞춰서 이미지를 포함하도록 모드 설정
        self.contentView.addSubview(imageView)      // Cell의 contentView에 subView로 위에서 커스텀해준 imageView를 추가
        
        // Snapkit을 사용하여 코드로 imageView의 오토레이아웃 설정
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview() // imageView의 모든 edge를 superView(여기서는 contentView)의 edge에 eqaul하게 맞추는 constraint 설정
        }
    }
}
