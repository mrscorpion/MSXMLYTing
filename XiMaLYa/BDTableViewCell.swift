//
//  BDTableViewCell.swift
//  XiMaLYa
//
//  Created by mr.scorpion on 16/8/5.
//  Copyright © 2016年 mr.scorpion. All rights reserved.
//

import UIKit

class BDTableViewCell: UITableViewCell {

    
    @IBOutlet weak var currentIndex: UILabel!
    
    @IBOutlet weak var coverSmall: UIImageView!

    @IBOutlet weak var title: UILabel!
    
    
    @IBOutlet weak var nickname: UILabel!
    
    
    var model:BDModel?{
        get{
            return self.model
        }
        set{
            if ((newValue?.coverSmall) != nil) {
                coverSmall.sd_setImageWithURL(NSURL.init(string: (newValue?.coverSmall)!))
            }else{
                coverSmall.sd_setImageWithURL(NSURL.init(string: (newValue?.coverMiddle)!))
            }
//            coverSmall.clipsToBounds = true
//            coverSmall.layer.cornerRadius = 40
            title.text = newValue?.title
            nickname.text = newValue?.nickname
        }
    }
    
    var model1:BDModel1?{
        get{
            return self.model1
        }
        set{
            coverSmall.sd_setImageWithURL(NSURL.init(string: (newValue?.middleLogo)!))
            
            title.text = newValue?.nickname
            nickname.text = newValue?.personDescribe
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        coverSmall.clipsToBounds = true
        coverSmall.layer.cornerRadius = 40
        title.frame = CGRectMake(130, 10, WIDTH-140, 55)
        nickname.frame = CGRectMake(130, 70, WIDTH-140, 20)
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
