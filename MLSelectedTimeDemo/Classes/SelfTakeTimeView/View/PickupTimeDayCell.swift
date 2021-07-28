//
//  PickupTimeDayCell.swift
//  MLSelectedTimeDemo
//
//  Created by Melo on 2021/7/23.
//

import UIKit

class PickupTimeDayCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!

    var titleText: String? {
        didSet {
            timeLabel.text = titleText
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.init(red: 254 / 255, green: 252 / 255, blue: 235 / 255, alpha: 1.0)
        self.selectedBackgroundView = bgColorView
    }
    
}
