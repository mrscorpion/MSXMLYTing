//
//  AppDelegate.swift
//  XiMaLYa
//
//  Created by mr.scorpion on 16/7/28.
//  Copyright © 2016年 mr.scorpion. All rights reserved.
//

import UIKit

let WIDTH = UIScreen.mainScreen().bounds.size.width;
let HEIGHT = UIScreen.mainScreen().bounds.size.height;

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var isPlayMusic:String?
    var firstPlayMusic:String?
    
    var window: UIWindow?
    var screenView:UIImageView?
    var screenButton:UIButton?
    var rootViewController:MyTabBarController?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow.init(frame: UIScreen.mainScreen().bounds)
        self.window?.backgroundColor = UIColor.whiteColor()
        
        self.rootViewController = MyTabBarController()
        self.window?.rootViewController = self.rootViewController
        
        self.window?.makeKeyAndVisible()
        
        screenView = UIImageView.init(frame: CGRectMake(WIDTH/5*2, HEIGHT-49, WIDTH/5, 49))
        screenView?.image = UIImage.init(named: "tabbar-light")
        screenView?.layer.cornerRadius = 25
        screenView?.layer.masksToBounds = true
        screenView?.userInteractionEnabled = true
        
        screenButton = UIButton.init(type: .Custom)
        screenButton?.frame = CGRectMake(0,0,WIDTH/5,49)
        screenButton?.layer.masksToBounds = true
        screenButton?.layer.cornerRadius = 30
        screenButton?.setImage(UIImage.init(named: "4"), forState: .Normal)
        screenButton?.addTarget(self, action: #selector(self.btnClick), forControlEvents: .TouchUpInside)
        screenView?.addSubview(screenButton!)
        
        UIApplication.sharedApplication().keyWindow?.addSubview(screenView!)
        
        screenView?.hidden = true
        
        return true
    }
    
    func btnClick(){
        //print(555)
        
        MusicPlayer.shareInstance.playerMusicViewHidden(false)
        
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        application.beginBackgroundTaskWithExpirationHandler(nil)
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        let user = NSUserDefaults.standardUserDefaults()
        user.setObject(MusicPlayer.shareInstance.beforeTrackId, forKey: "beforetrackId")
        user.setObject(MusicPlayer.shareInstance.beforeTitle, forKey: "beforeTitle")
    }
    

}

