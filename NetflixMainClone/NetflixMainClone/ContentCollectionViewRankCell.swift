//
//  ContentCollectionViewRankCell.swift
//  NetflixMainClone
//
//  Created by 김초원 on 2023/01/15.
//

import UIKit

class ContentCollectionViewRankCell: UICollectionViewCell {
    let imageView = UIImageView()
    let rankLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // contentView 설정
        self.contentView.layer.cornerRadius = 5
        self.contentView.clipsToBounds = true
        
        // imageView 설정
        self.imageView.contentMode = .scaleToFill
        self.contentView.addSubview(self.imageView)
        self.imageView.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.8)
        }
        
        // rankLabel 설정
        self.rankLabel.font = .systemFont(ofSize: 100, weight: .black)
        self.rankLabel.textColor = .white
        self.contentView.addSubview(self.rankLabel)
        self.rankLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview().offset(25)
        }
        
    }
    
}
