//
//  WebViewController.swift
//  XiMaLYa
//
//  Created by mr.scorpion on 16/8/4.
//  Copyright © 2016年 mr.scorpion. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    var urlString:String?
    var webView:UIWebView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        webView = UIWebView.init(frame: CGRectMake(0, 0, WIDTH, HEIGHT))
        let request = NSURLRequest.init(URL: NSURL.init(string: urlString!)!)
        webView?.loadRequest(request)
        self.view.addSubview(webView!)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.rootViewController?.isHidden = true
        
        delegate.screenView?.hidden = true
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
