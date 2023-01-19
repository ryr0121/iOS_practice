//
//  SearchTableViewCell.swift
//  SubwayStation
//
//  Created by 김초원 on 2023/01/19.
//

import UIKit
import SnapKit

class SearchTableViewCell: UITableViewCell {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    func setUpLayout(title: String, subTitle: String) {
        self.titleLabel.text = title
        self.subTitleLabel.text = subTitle
    }
    
    func setUp(title: String, subTitle: String) {
        [ titleLabel, subTitleLabel ].forEach { self.addSubview($0) }
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(10)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(10)
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.bottom.equalToSuperview().inset(10)
        }
        
        titleLabel.text = title
        subTitleLabel.text = subTitle
    }
    
    func setUpLayout() {
        self.layer.backgroundColor = UIColor.systemBackground.cgColor
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 10
    }
}
