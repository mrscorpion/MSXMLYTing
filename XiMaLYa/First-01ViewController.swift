//
//  First-01ViewController.swift
//  XiMaLYa
//
//  Created by mr.scorpion on 16/7/29.
//  Copyright © 2016年 mr.scorpion. All rights reserved.
//

import UIKit

let kTABXIANGQINGURL = "http://mobile.ximalaya.com/m/subject_detail?device=android&id=%@"

class First_01ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var specialId:NSNumber?
    var contentType:NSNumber?
    
    var tableView:UITableView?
    var tableData:NSMutableArray = NSMutableArray()
    
    var headerView:UIImageView?
    
    var headerString:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        creatData()
        creatUI()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.rootViewController?.isHidden = true
    }
    
    func creatData(){
        let networking = ZSLNetworking()
        let urlString = NSString (format: kTABXIANGQINGURL, specialId!) as String
        networking.starRequest(urlString, finishedBlcok: { (data) in
            let dic = try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves) as! NSDictionary
            print(urlString)
            //print(dic)
            self.headerString = dic["info"]!["coverPathBig"] as? String
            let array = dic["list"] as! NSArray
            for i in 0..<array.count{
                let dict = array[i] as! NSDictionary
                let model = First_01Model.myModelWithDic(dict as [NSObject : AnyObject])
                self.tableData.addObject(model)
            }
            
            dispatch_async(dispatch_get_main_queue(), { 
                self.tableView?.reloadData()
                self.headerView?.sd_setImageWithURL(NSURL (string: self.headerString!))
            })
            
            }) { (error) in
                print(error)
        }
    }
    
    func creatUI() {
        self.automaticallyAdjustsScrollViewInsets = false
        tableView = UITableView.init(frame: CGRectMake(0, 64, WIDTH, HEIGHT-64), style: .Grouped)
        tableView?.delegate = self
        tableView?.dataSource = self
        headerView = UIImageView.init(frame: CGRectMake(0, 0, WIDTH, (WIDTH-10)/2))
        tableView?.tableHeaderView = headerView
        self.view.addSubview(tableView!)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("tableViewCell") as? TableViewCell
        if cell == nil {
            cell = NSBundle.mainBundle().loadNibNamed("TableViewCell", owner: self, options: nil)[0] as? TableViewCell
        }
        let model = tableData[indexPath.row] as!First_01Model
        cell!.model1 = model
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let isTwo = (contentType?.isEqualToNumber(2))! as Bool
        if (isTwo) {
            let model = tableData[indexPath.row] as! First_01Model
            let player = MusicPlayer.shareInstance
            player.creatPlayer(model.Id!)
        } else {
            let vc = ZhuanJiViewController()
            
            let model = tableData[indexPath.row] as!First_01Model
            vc.albumId = model.Id
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
