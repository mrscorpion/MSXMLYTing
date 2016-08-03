//
//  ThirdViewController.swift
//  XiMaLYa
//
//  Created by mr.scorpion on 16/7/28.
//  Copyright © 2016年 mr.scorpion. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {

    var array = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.purpleColor()
        // Do any additional setup after loading the view.
        
        let bringBtn = UIButton.init(type: .Custom)
        bringBtn.frame = CGRectMake(50, 100, 60, 60)
        bringBtn.setTitle("查询", forState: .Normal)
        bringBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        bringBtn.addTarget(self, action: #selector(self.btnClick), forControlEvents: .TouchUpInside)
        self.view.addSubview(bringBtn)
    }
    
    func btnClick(){
        array = DBManager.shareManager.fetchData()
        
        for i in 0..<array.count {
            let model = array[i] as! ZhuanJiModel
            print(model.title)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
