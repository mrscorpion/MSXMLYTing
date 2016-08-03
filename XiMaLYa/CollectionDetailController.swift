//
//  CollectionDetailController.swift
//  XiMaLYa
//
//  Created by mr.scorpion on 16/8/4.
//  Copyright © 2016年 mr.scorpion. All rights reserved.
//

import UIKit

let kXQTWOURL = "http://mobile.ximalaya.com/mobile/discovery/v1/category/album?calcDimension=hot&categoryId=%@&device=android&pageId=%d&pageSize=20&status=0&tagName=%@"

class CollectionDetailController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var name:String?
    var categeId:NSNumber?
    var dataArray = NSMutableArray()
    var tableView:UITableView?
    var page:Int?
    var refreshFooter :SDRefreshFooterView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        page = 1;
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
        
        let zhuanName = name?.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.whitespaceCharacterSet())
        let urlString = NSString.init(format: kXQTWOURL, categeId!,page!,zhuanName!) as String
        print(urlString)
        if page == 1 {
            dataArray.removeAllObjects()
        }
        let networking = ZSLNetworking()
        networking.starRequest(urlString, finishedBlcok: { (data) in
            let dic = try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves) as! NSDictionary
            let array = dic["list"] as! NSArray
            for i in 0..<array.count{
                let dict = array[i] as! NSDictionary
                let model = CollectionDetalModel.myModelWithDic(dict as [NSObject : AnyObject])
                self.dataArray.addObject(model)
            }
            
            dispatch_async(dispatch_get_main_queue(), { 
                self.tableView?.reloadData()
                self.tableView?.es_stopPullToRefresh(completion: true)
            })
            
            }) { (error) in
                print(error)
        }
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "collectionDetail"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? CollectionDetailCell
        if cell == nil {
            cell = NSBundle.mainBundle().loadNibNamed("CollectionDetailCell", owner: self, options: nil)[0] as? CollectionDetailCell
        }
        let model = dataArray[indexPath.row] as! CollectionDetalModel
        cell!.model = model
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let model = dataArray[indexPath.row] as! CollectionDetalModel
        let size = ((model.intro)! as NSString).myBoundingRectWithSize(CGSizeMake(WIDTH-88, 0), withFontSize: 15)
        
        return 80+size.height
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let zhuanJi = ZhuanJiViewController()
        let model = dataArray[indexPath.row] as! CollectionDetalModel
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
