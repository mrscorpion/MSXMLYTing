//
//  BDSubViewController.swift
//  XiMaLYa
//
//  Created by mr.scorpion on 16/8/4.
//  Copyright © 2016年 mr.scorpion. All rights reserved.
//

import UIKit

let kBDXQURL = "http://mobile.ximalaya.com/mobile/discovery/v1/rankingList/%@?device=android&key=%@&pageId=%d&pageSize=40"


class BDModel: NSObject {
    var title:String?
    var nickname:String?
    var coverSmall:String?
    var coverMiddle:String?
    var trackId:NSNumber?
    var albumId:NSNumber?
}
class BDModel1: NSObject {
    var nickname:String?
    var middleLogo:String?
    var personDescribe:String?
    var uid:NSNumber?
}

class BDSubViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var key:String?
    var contentType:String?
    var currentPage:Int?
    
    var tableView:UITableView?
    var dataArray = NSMutableArray()
    
    var page:Int?
    
    var refreshFooter :SDRefreshFooterView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        //print("\(self.key)+\(self.contentType)+\(self.currentPage)")
        
        page = 1
        dataArray.removeAllObjects()
        //creatData()
        creatUI()
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    func creatUI(){
        //self.automaticallyAdjustsScrollViewInsets = false
        tableView = UITableView.init(frame: CGRectMake(0, 64, WIDTH, HEIGHT-20))
        tableView?.delegate = self
        tableView?.dataSource = self
        self.view.addSubview(tableView!)
        
        let header = WeChatTableHeaderView.init(frame: CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: self.view.bounds.size.width, height: 0)))
        tableView?.tableHeaderView = header
        weak var mySelf = self
        tableView?.es_addPullToRefresh(animator: WCRefreshHeaderAnimator.init(frame: CGRect.zero), handler: { 
            mySelf?.page = 1
            mySelf?.creatData()
        })
        
        refreshFooter = SDRefreshFooterView()
        refreshFooter.addToScrollView(tableView)
        weak var myFotter = refreshFooter
        refreshFooter.beginRefreshingOperation = {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), { 
                mySelf?.page = (mySelf?.page)! + 1
                mySelf?.creatData()
                myFotter?.endRefreshing()
            })
        }
        
    }
    func creatData(){
        key = key?.stringByReplacingOccurrencesOfString(":", withString: "%3A")
        let urlString = NSString.init(format: kBDXQURL, contentType!,key!,page!) as String
        print(urlString)
        if page == 1 {
            self.dataArray.removeAllObjects()
        }
        
        let networking = ZSLNetworking()
        networking.starRequest(urlString, finishedBlcok: { (data) in
            let dic = try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves) as! NSDictionary
            
            let array = dic["list"] as! NSArray
            for i in 0..<array.count{
                let dict = array[i] as! NSDictionary
                if self.contentType == "anchor"{
                    let model = BDModel1.myModelWithDic(dict as [NSObject : AnyObject])
                    self.dataArray.addObject(model)
                }else{
                    let model = BDModel.myModelWithDic(dict as [NSObject : AnyObject])
                    self.dataArray.addObject(model)
                }
                
                dispatch_async(dispatch_get_main_queue(), { 
                    self.tableView?.reloadData()
                    self.tableView?.es_stopPullToRefresh(completion: true)
                })
            }
            }) { (error) in
                print(error)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "bdTableViewCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? BDTableViewCell
        if cell == nil {
            cell = NSBundle.mainBundle().loadNibNamed("BDTableViewCell", owner: self, options: nil)[0] as? BDTableViewCell
        }
        if contentType == "anchor" {
            let model = dataArray[indexPath.row] as! BDModel1
            cell?.model1 = model
            
        }else{
            let model = dataArray[indexPath.row] as! BDModel
            cell?.model = model
        }
        
        cell!.currentIndex.text = String(indexPath.row+1)
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        if currentPage == 0 {
//            let model = dataArray[indexPath.row] as! BDModel
//            MusicPlayer.shareInstance.creatPlayer(model.trackId!)
//        }else{
//            let zhuanJi = ZhuanJiViewController()
//            
//            if contentType == "anchor" {
//                let model = dataArray[indexPath.row] as! BDModel1
//                zhuanJi.albumId = model.uid
//            }else{
//                let model = dataArray[indexPath.row] as! BDModel
//                zhuanJi.albumId = model.albumId
//            }
//            self.navigationController?.pushViewController(zhuanJi, animated: true)
//        }
        
        if contentType == "track" {
            let model = dataArray[indexPath.row] as! BDModel
            MusicPlayer.shareInstance.creatPlayer(model.trackId!)
        }else if contentType == "album"{
            let zhuanJi = ZhuanJiViewController()
            let model = dataArray[indexPath.row] as! BDModel
            zhuanJi.albumId = model.albumId
            self.navigationController?.pushViewController(zhuanJi, animated: true)
        }else{
            let zhuanJi = ZhuanJiViewController()
            let model = dataArray[indexPath.row] as! BDModel1
            zhuanJi.albumId = model.uid
            zhuanJi.wangzhiChange = true
            self.navigationController?.pushViewController(zhuanJi, animated: true)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.rootViewController?.isHidden = true
        self.page = 1
        self.dataArray.removeAllObjects()
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
