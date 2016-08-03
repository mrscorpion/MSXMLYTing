//
//  CollectionViewCell.swift
//  XiMaLYa
//
//  Created by mr.scorpion on 16/7/28.
//  Copyright © 2016年 mr.scorpion. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!

    @IBOutlet weak var imageView: UIImageView!
    
    var model:CollectioModel?{
        get{
            return self.model
        }
        set{
//            self.model = newValue
            self.title.text = newValue?.title
            self.imageView .sd_setImageWithURL(NSURL.init(string: (newValue?.coverPath)!))
            //print("\(newValue?.title)+++++++ \(newValue?.coverPath)")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
