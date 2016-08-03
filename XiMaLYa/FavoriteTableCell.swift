//
//  FavoriteTableCell.swift
//  XiMaLYa
//
//  Created by mr.scorpion on 16/8/5.
//  Copyright © 2016年 mr.scorpion. All rights reserved.
//

import UIKit

class FavoriteTableCell: MGSwipeTableCell {
    
    @IBOutlet weak var coverImage: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var playTimes: UILabel!
    
    @IBOutlet weak var isLike: UIImageView!
    
    var model:ZhuanJiModel?{
        get{
            return self.model
        }
        set{
            coverImage.sd_setImageWithURL(NSURL.init(string: (newValue?.coverMiddle)!))
            title.text = newValue?.title
            playTimes.text = NSString.init(format: "播放量:%@", (newValue?.playtimes)!) as String
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        title.frame = CGRectMake(90, 10, WIDTH-100, 40)
        playTimes.frame = CGRectMake(90, 50, WIDTH-150, 40)
        isLike.frame = CGRectMake(WIDTH-50, 50, 40, 40)
        
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
