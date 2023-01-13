//
//  ContentCollectionViewHeader.swift
//  NetflixMainClone
//
//  Created by 김초원 on 2023/01/13.
//

import UIKit    // UI의 핵심 오브젝트를 구성하기 위한 라이브러리 가져오기

// UICollectionReusableView를 커스텀한 클래스 정의인데, UICollectionReusableView가 구체적으로 뭐지?
class ContentCollectionViewHeader: UICollectionReusableView {
    let sectionNameLabel = UILabel()    // section의 header로 쓰일 UILabel 선언
    
    // layoutSubviews가 구체적으로 뭐지?
    override func layoutSubviews() {
        super.layoutSubviews()  // 오버라이드니까 상위 메소드 호출
        
        sectionNameLabel.font = .systemFont(ofSize: 17, weight: .bold)  // 라벨에 표시될 글자의 폰트 설정(글자 크기 = 17, bold체로)
        sectionNameLabel.textColor = .black // 라벨의 글자색을 검정색으로 설정
        sectionNameLabel.sizeToFit()    // 라벨의 크기를 글자 크기에 맞추도록 설정
        
        addSubview(sectionNameLabel)    // subView에 위에서 커스텀한 UILabel 추가, 근데 왜 subView에 하지,,?
        
        // Snapkit을 사용하여 sectionNameLabel의 오토레이아웃 설정
        sectionNameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()   // sectionNameLabel를 Y축에 대하여 SuperView의 중심으로 설정
            $0.top.bottom.leading.equalToSuperview().offset(10) // sectionNameLabel의 top, bottom, leading을 superView에서 10만큼 떨어지도록 constraints 설정 (위, 아래, 왼쪽에 크기 10의 철심박기)
        }
    }
}
