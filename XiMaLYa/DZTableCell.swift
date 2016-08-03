//
//  DZTableCell.swift
//  XiMaLYa
//
//  Created by mr.scorpion on 16/8/5.
//  Copyright © 2016年 mr.scorpion. All rights reserved.
//

import UIKit

class DZTableCell: UITableViewCell {
    
    @IBOutlet weak var coverImage: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var lastTitle: UILabel!
    
    @IBOutlet weak var uodataAt: UILabel!
    
    var model:DZModel?{
        get{
            return self.model
        }
        set{
            coverImage.sd_setImageWithURL(NSURL.init(string: (newValue?.coverMiddle)!))
            title.text = newValue?.title
            lastTitle.text = newValue?.lastUptrackTitle
            uodataAt.text = newValue?.intro
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        title.frame = CGRectMake(90, 10, WIDTH-100, 30)
        lastTitle.frame = CGRectMake(90, 45, WIDTH-100, 20)
        uodataAt.frame = CGRectMake(90, 70, WIDTH-100, 20)
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
