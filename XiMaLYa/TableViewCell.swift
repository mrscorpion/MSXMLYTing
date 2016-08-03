//
//  TableViewCell.swift
//  XiMaLYa
//
//  Created by mr.scorpion on 16/7/29.
//  Copyright © 2016年 mr.scorpion. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    
    @IBOutlet weak var title1: UILabel!
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var subTitle1: UILabel!
    
    var model:TableOneModel?{
        get{
            return self.model
        }
        set{
            
            title1.frame = CGRectMake(90, 10, WIDTH-100, 27)
            subTitle1.frame = CGRectMake(90, 42, WIDTH-100, 48)
            
            imageView1.clipsToBounds = true
            imageView1.layer.cornerRadius = 40
            //title1.adjustsFontSizeToFitWidth = true
            //subTitle1.sizeToFit()
            
            imageView1.frame = CGRectMake(5, 10, 80, 80)
            title1.text = newValue?.title
            subTitle1.text = newValue?.subtitle
            imageView1.sd_setImageWithURL(NSURL (string: (newValue?.coverPathSmall)!))
        }
    }
    
    var model1:First_01Model?{
        get{
            return self.model1
        }
        set{
            imageView1.frame = CGRectMake(5, 10, 80, 80)
            if ((newValue?.coverSmall) != nil) {
                imageView1.sd_setImageWithURL(NSURL (string: (newValue?.coverSmall)!))
            }else{
                imageView1.sd_setImageWithURL(NSURL (string: (newValue?.albumCoverUrl290)!))
            }
            
            if ((newValue?.nickname) != nil) {
                
                title1.frame = CGRectMake(90, 10, WIDTH-100, 55)
                
                subTitle1.frame = CGRectMake(90, 70, WIDTH-100, 20)
                
                title1.text = newValue?.title
                subTitle1.text = newValue?.nickname
            }else{
                
                title1.frame = CGRectMake(90, 10, WIDTH-100, 27)
                
                subTitle1.frame = CGRectMake(90, 42, WIDTH-100, 48)
                
                title1.text = newValue?.title
                subTitle1.text = newValue?.intro
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
