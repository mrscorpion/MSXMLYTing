//
//  CollectionDetailCell.swift
//  XiMaLYa
//
//  Created by mr.scorpion on 16/8/4.
//  Copyright © 2016年 mr.scorpion. All rights reserved.
//

import UIKit

class CollectionDetailCell: UITableViewCell {

    @IBOutlet weak var coverMiddle: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var introLabel: UILabel!
    
    @IBOutlet weak var playsCounts: UILabel!
    
    @IBOutlet weak var tracksCounts: UILabel!
    
    @IBOutlet weak var imageView1: UIImageView!
    
    @IBOutlet weak var imageView2: UIImageView!
    
    var model:CollectionDetalModel?{
        get{
            return self.model
        }
        set{
            
            let size = ((newValue?.intro)! as NSString).myBoundingRectWithSize(CGSizeMake(WIDTH-88, 0), withFontSize: 14)
            
            let imageHeight = size.height+75
            
            coverMiddle.center = CGPointMake(38, imageHeight/2)
            
            //coverMiddle.frame = CGRectMake(5, 10, 70, imageHeight)
            
            titleLabel.frame = CGRectMake(83, 8, WIDTH-83-5, 21)
            introLabel.frame = CGRectMake(83, 37, WIDTH-88, size.height)
            introLabel.numberOfLines = 0
            
            imageView1.frame = CGRectMake(83, size.height+42, 30, 30)
            playsCounts.frame = CGRectMake(115, size.height+42, (WIDTH-158)/2, 30)
            imageView2.frame = CGRectMake((WIDTH-158)/2+120, size.height+42, 30, 30)
            tracksCounts.frame = CGRectMake((WIDTH-158)/2+152, size.height+42, (WIDTH-158)/2, 30)
            
            titleLabel.text = newValue?.title
            introLabel.text = newValue?.intro
            playsCounts.text = newValue?.playsCounts?.stringValue
            
            tracksCounts.text = newValue?.tracks?.stringValue
            if newValue?.coverMiddle?.characters.count != 0 {
                coverMiddle.sd_setImageWithURL(NSURL.init(string: (newValue?.coverMiddle)!))
            }else{
                coverMiddle.image = UIImage.init(named: "i0.jpg")
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
