//
//  ProfileCollectionViewCell.swift
//  InstagramClone
//
//  Created by 김초원 on 2023/01/26.
//

import UIKit
import SnapKit

class ProfileCollectionViewCell: UICollectionViewCell {
    private let imageView = UIImageView()

    func setup(with image: UIImage) {
        addSubview(imageView)
        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }

        imageView.backgroundColor = .tertiaryLabel
    }
}
