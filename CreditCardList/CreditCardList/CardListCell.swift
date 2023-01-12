//
//  CardListCell.swift
//  CreditCardList
//
//  Created by 김초원 on 2023/01/12.
//

import UIKit

class CardListCell: UITableViewCell {

    @IBOutlet weak var cardImgView: UIImageView!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var promotionLabel: UILabel!
    @IBOutlet weak var cardNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
