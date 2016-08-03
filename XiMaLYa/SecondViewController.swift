//
//  SecondViewController.swift
//  XiMaLYa
//
//  Created by mr.scorpion on 16/7/28.
//  Copyright © 2016年 mr.scorpion. All rights reserved.
//

import UIKit

let kDINGZHIURL = "http://mobile.ximalaya.com/mobile/album/recommend/list/unlogin?device=android"

class SecondViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var tableView:UITableView?
    
    var dataArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "定制听"
        creatData()
        creatUI()
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.rootViewController?.isHidden = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        dataArray.removeAllObjects()
        creatData()
    }
    
    func creatUI(){
        tableView = UITableView.init(frame: CGRectMake(0, 0, WIDTH, HEIGHT), style: .Plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        self.view.addSubview(tableView!)
        
    }
    
    func creatData(){
        let networking = ZSLNetworking()
        networking.starRequest(kDINGZHIURL, finishedBlcok: { (data) in
            
            let dic = try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves) as! NSDictionary
            let array = dic["frDatas"] as! NSArray
            for i in 0..<array.count{
                let dict = array[i] as! NSDictionary
                let model = DZModel.myModelWithDic(dict as [NSObject : AnyObject])
                self.dataArray.addObject(model)
            }
            
            dispatch_async(dispatch_get_main_queue(), { 
                self.tableView?.reloadData()
            })
            
            }) { (error) in
                print(error)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "DZTableCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? DZTableCell
        if cell == nil {
            cell = NSBundle.mainBundle().loadNibNamed("DZTableCell", owner: self, options: nil)[0] as? DZTableCell
        }
        let model = dataArray[indexPath.row] as! DZModel
        cell?.model = model
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let model = dataArray[indexPath.row] as! DZModel
        let zhuanJi = ZhuanJiViewController()
        zhuanJi.albumId = model.albumId
        self.navigationController?.pushViewController(zhuanJi, animated: true)
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
