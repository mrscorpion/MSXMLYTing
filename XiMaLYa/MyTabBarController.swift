//
//  MyTabBarController.swift
//  XiMaLYa
//
//  Created by mr.scorpion on 16/7/28.
//  Copyright © 2016年 mr.scorpion. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController {

    var bigView:UIImageView?
    
    
    var isHidden:Bool?{
        get{
            return self.isHidden
        }
        set{
            
            if newValue == true {
                UIView.animateWithDuration(0.2, animations: {
                    var fram:CGRect = (self.bigView?.frame)!
                    fram.origin.y = HEIGHT
                    self.bigView?.frame = fram
                    let delegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    delegate.screenView?.hidden = false
                })
                
                
            }else{
                UIView.animateWithDuration(0.2, animations: { 
                    var fram:CGRect = (self.bigView?.frame)!
                    fram.origin.y = HEIGHT-49
                    self.bigView?.frame = fram
                    let delegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    delegate.screenView?.hidden = true
                })
            }
        }
    }
    
    var beforeBtn:UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        creatTabBar()
        creatViewControllers()
        // Do any additional setup after loading the view.
    }

    
    func creatTabBar(){
        
        self.tabBar.hidden = true
        
        bigView = UIImageView.init(frame: self.tabBar.frame)
        bigView?.userInteractionEnabled = true
        bigView?.image = UIImage.init(named: "tabbar-light")
        self.view.addSubview(bigView!)
        
        let tabBarImage:NSArray = ["tabbar_find_n","tabbar_sound_n","4","tabbar_me_n"]
        
        let tabBarSelImage:NSArray = ["tabbar_find_h","tabbar_sound_h","4","tabbar_me_h"]
        
        for i in 0..<tabBarImage.count {
            let button:UIButton = UIButton.init(frame: CGRectMake(WIDTH/4*(CGFloat(Float(i))), 0, WIDTH/4, 49))
            button.setImage(UIImage.init(named: tabBarImage[i] as! String), forState: .Normal)
            button.setImage(UIImage.init(named: tabBarSelImage[i] as! String), forState: .Selected)
            button.tag = i+100;
            button.addTarget(self, action: #selector(self.buttonCilck(_:)), forControlEvents: .TouchUpInside)
            bigView?.addSubview(button)
            if i==0 {
                button.selected = true
                beforeBtn = button
            }
        }
        
        
    }
    
    func creatViewControllers(){
        let controllers = [FirstViewController(),SecondViewController(),ThirdViewController(),ForthViewController()]
        let viewControllers = NSMutableArray()
        for i in 0..<controllers.count {
            let root:UIViewController = controllers[i]
            let nav:UINavigationController = UINavigationController.init(rootViewController: root)
            viewControllers.addObject(nav)
  
        }
        
        self.viewControllers = viewControllers.copy() as? [UIViewController]
        
    }
    
    func buttonCilck(sender:UIButton) -> Void {
        
        if sender.tag == 102 {
            let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
            if delegate.isPlayMusic == "yes" {
                MusicPlayer.shareInstance.playerMusicViewHidden(false)
            }else{
                
                if (NSUserDefaults.standardUserDefaults().objectForKey("beforetrackId") != nil) {
                    let str = NSUserDefaults.standardUserDefaults().objectForKey("beforetrackId") as! NSNumber
                    delegate.firstPlayMusic = "yes"
                    MusicPlayer.shareInstance.creatPlayer(str)
                }else{
                    let alertShow = UIAlertView.init(title: "提示", message: "暂无播放歌曲", delegate: self, cancelButtonTitle: "OK")
                    alertShow.show()
                }
                
                
                
                
            }
        }else{
            beforeBtn?.selected = false
            sender.selected = true
            beforeBtn = sender
            self.selectedIndex = sender.tag-100
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
