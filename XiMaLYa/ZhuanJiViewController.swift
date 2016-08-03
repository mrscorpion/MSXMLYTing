//
//  ZhuanJiViewController.swift
//  XiMaLYa
//
//  Created by mr.scorpion on 16/7/29.
//  Copyright © 2016年 mr.scorpion. All rights reserved.
//

import UIKit

let kZHUANJIURL = "http://mobile.ximalaya.com/mobile/others/ca/album/track/%@/true/%d/20"

let kZHUANJIURL1 = "http://mobile.ximalaya.com/mobile/v1/artist/tracks?device=android&pageId=1&toUid=%@"

class ZhuanJiViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var albumId:NSNumber?
    var page:Int?
    var headerDic:NSDictionary = NSDictionary()
    
    var tableView:UITableView?
    var tableData:NSMutableArray = NSMutableArray()
    
    var titleView:UIView?
    
    var wangzhiChange = false
    var i:Int?
    
    var bringSize:CGSize?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        page = 1
        i = 1
        // Do any additional setup after loading the view.
        creatUI()
        creatData()
    }
    
    func creatUI(){
        self.automaticallyAdjustsScrollViewInsets = false
        tableView = UITableView.init(frame: CGRectMake(0, 64, WIDTH, HEIGHT-64), style: .Grouped)
        tableView?.delegate = self
        tableView?.dataSource = self
        self.view.addSubview(tableView!)
        
        weak var mySelf = self
        tableView?.es_addPullToRefresh(handler: {
            mySelf?.page = 1
            mySelf?.creatData()
        })
        tableView?.refreshIdentifier = NSStringFromClass(FirstViewController)
        tableView?.expriedTimeInterval = 20.0
        tableView?.es_addInfiniteScrolling(handler: {
            mySelf?.page = (mySelf?.page)! + 1
            mySelf?.creatData()
        })
        
        
    }
    func creatData(){
        let networking = ZSLNetworking()
        
        var urlString:String
        if wangzhiChange == false{
            i=1
            urlString = NSString (format: kZHUANJIURL, albumId!,page!) as String
        }else{
            i=2
            urlString = NSString (format: kZHUANJIURL1, albumId!) as String
            wangzhiChange = false
        }
        if page == 1 {
            tableData.removeAllObjects()
        }
        print(urlString)
        networking.starRequest(urlString, finishedBlcok: { (data) in
            let dic = try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves) as! NSDictionary
            //print(dic)
            
            if self.i == 2{
                let array = dic["list"] as! NSArray
                for i in 0..<array.count{
                    let dict = array[i] as! NSDictionary
                    let model = ZhuanJiModel.myModelWithDic(dict as [NSObject : AnyObject])
                    self.tableData.addObject(model!)
                }
                
            }else{
                self.headerDic = dic["album"] as! NSDictionary
                let array = dic["tracks"]!["list"] as! NSArray
                for i in 0..<array.count{
                    let dict = array[i] as! NSDictionary
                    let model = ZhuanJiModel.myModelWithDic(dict as [NSObject : AnyObject])
                    self.tableData.addObject(model!)
                }
            }
            
            
            
            dispatch_async(dispatch_get_main_queue(), { 
//                print(self.tableData)
//                    for i in 0..<self.tableData.count{
//                        let model = self.tableData[i] as! ZhuanJiModel
//                        print("\(model.title)")
//
//                }
                if self.i == 2{
                    
                }else{
                    self.creatHeaderView()
                }
                
                
                self.tableView?.reloadData()
                self.tableView?.es_stopPullToRefresh(completion: true)
                self.tableView?.es_stopLoadingMore()
                
            })
            }) { (error) in
                print(error)
        }
    }
    
    func creatHeaderView(){
        let string = self.headerDic["intro"]
        var size:CGSize?
        if (string != nil) {
            size = string?.myBoundingRectWithSize(CGSizeMake(WIDTH-20, 1000), withFontSize: 17)
        }else{
            size = self.headerDic["title"]?.myBoundingRectWithSize(CGSizeMake(WIDTH-20, 1000), withFontSize: 17)
        }
        bringSize = size
        titleView = UIView()
        
        let backgroundView = UIImageView()

        backgroundView.sd_setImageWithURL(NSURL (string: self.headerDic["coverOrigin"] as! String))
        backgroundView.alpha = 0.3
        titleView!.addSubview(backgroundView)
        
        let imageView1 = UIImageView.init(frame: CGRectMake(5, 10, 100, 100))
        imageView1.clipsToBounds = true
        imageView1.layer.cornerRadius = 50
        titleView!.addSubview(imageView1)
        
        let string1 = self.headerDic["coverMiddle"] as! NSString
        let imageArray = ["i0.jpg","i1.jpg","i3.jpg","i4.jpg","i5.jpg","i6.jpg"]
        if string1.length != 0 {
            imageView1.sd_setImageWithURL(NSURL (string: string1 as String))
        }else{
            imageView1.sd_setImageWithURL(NSURL (string: imageArray[Int(arc4random()%6)]))
        }
        
        let label1 = UILabel.init(frame: CGRectMake(120, 10, WIDTH-130, 35))
        label1.text = NSString.init(format: "作者:%@", headerDic["nickname"] as! NSString) as String
        titleView!.addSubview(label1)
        
        let label2 = UILabel.init(frame: CGRectMake(120, 55, WIDTH-130, 50))
        label2.text = NSString.init(format: "题目:%@", headerDic["title"] as! NSString)  as String
        label2.numberOfLines = 0
        titleView!.addSubview(label2)
        
        let label3 = UILabel()
        
        if size?.height>50 {
            
            let bringBtn = UIButton.init(type: .Custom)
            bringBtn.frame = CGRectMake(WIDTH-65, 170, 60, 20)
            bringBtn.setTitle("v 展开", forState: .Normal)
            bringBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
            bringBtn.addTarget(self, action: #selector(self.btnClick(_:)), forControlEvents: .TouchUpInside)
            titleView?.addSubview(bringBtn)
            
            backgroundView.frame = CGRectMake(0, 0, WIDTH, 120+50+22)
            titleView?.frame = CGRectMake(0, 0, WIDTH, 120+50+5+22)
            label3.frame = CGRectMake(10, 120, (size?.width)!, 50)
        }else{
            backgroundView.frame = CGRectMake(0, 0, WIDTH, (size?.height)!+120)
            titleView?.frame = CGRectMake(0, 0, WIDTH, (size?.height)!+120+5)
            label3.frame = CGRectMake(10, 120, (size?.width)!, (size?.height)!)
        }
        
        
        if (headerDic["intro"] != nil) {
            label3.text = headerDic["intro"] as? String
        }else{
            label3.text = headerDic["title"] as? String
        }
        
        label3.numberOfLines = 0
        titleView!.addSubview(label3)

        tableView?.tableHeaderView = titleView
        
    }
    
    func btnClick(sender:UIButton){
        titleView?.removeFromSuperview()
        creatTableHeader2()
    }
    func btnClick1(sender:UIButton){
        titleView?.removeFromSuperview()
        creatHeaderView()
        tableView?.setContentOffset(CGPointMake(0, 0), animated: true)
    }
    
    func creatTableHeader2(){
        let string = self.headerDic["intro"]
        var size:CGSize?
        if (string != nil) {
            size = string?.myBoundingRectWithSize(CGSizeMake(WIDTH-20, 1000), withFontSize: 17)
        }else{
            size = self.headerDic["title"]?.myBoundingRectWithSize(CGSizeMake(WIDTH-20, 1000), withFontSize: 17)
        }
        bringSize = size
        titleView = UIView()
        
        let backgroundView = UIImageView()
        
        backgroundView.sd_setImageWithURL(NSURL (string: self.headerDic["coverOrigin"] as! String))
        backgroundView.alpha = 0.3
        titleView!.addSubview(backgroundView)
        
        let imageView1 = UIImageView.init(frame: CGRectMake(5, 10, 100, 100))
        imageView1.clipsToBounds = true
        imageView1.layer.cornerRadius = 50
        titleView!.addSubview(imageView1)
        
        let string1 = self.headerDic["coverMiddle"] as! NSString
        let imageArray = ["i0.jpg","i1.jpg","i3.jpg","i4.jpg","i5.jpg","i6.jpg"]
        if string1.length != 0 {
            imageView1.sd_setImageWithURL(NSURL (string: string1 as String))
        }else{
            imageView1.sd_setImageWithURL(NSURL (string: imageArray[Int(arc4random()%6)]))
        }
        
        let label1 = UILabel.init(frame: CGRectMake(120, 10, WIDTH-130, 35))
        label1.text = NSString.init(format: "作者:%@", headerDic["nickname"] as! NSString) as String
        titleView!.addSubview(label1)
        
        let label2 = UILabel.init(frame: CGRectMake(120, 55, WIDTH-130, 50))
        label2.text = NSString.init(format: "题目:%@", headerDic["title"] as! NSString)  as String
        label2.numberOfLines = 0
        titleView!.addSubview(label2)
        
        let label3 = UILabel()
        if (headerDic["intro"] != nil) {
            label3.text = headerDic["intro"] as? String
        }else{
            label3.text = headerDic["title"] as? String
        }
        
        label3.numberOfLines = 0
        titleView!.addSubview(label3)
        
        let bringBtn = UIButton.init(type: .Custom)
        bringBtn.frame = CGRectMake(WIDTH-65, (size?.height)!+120, 60, 20)
        bringBtn.setTitle("^ 收起", forState: .Normal)
        bringBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        bringBtn.addTarget(self, action: #selector(self.btnClick1(_:)), forControlEvents: .TouchUpInside)
        titleView?.addSubview(bringBtn)
        
        backgroundView.frame = CGRectMake(0, 0, WIDTH, (size?.height)!+120+20)
        titleView?.frame = CGRectMake(0, 0, WIDTH, (size?.height)!+120+5+20)
        label3.frame = CGRectMake(10, 120, (size?.width)!, (size?.height)!)
        
        tableView?.tableHeaderView = titleView
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier)
        if cell == nil {
            cell = UITableViewCell.init(style: .Subtitle, reuseIdentifier: identifier)
        }
        let model = self.tableData[indexPath.row] as! ZhuanJiModel
        
        cell?.textLabel?.text = model.title
        //cell?.detailTextLabel?.text = model.playtimes?.stringValue
        cell?.detailTextLabel?.text = NSString (format: "播放量:%@", (model.playtimes?.stringValue)!) as String
        cell?.selectionStyle = .None
        
        cell?.textLabel?.textColor = UIColor.mycolorWithString("#ff7730")
        cell?.textLabel?.numberOfLines = 3

//        cell?.textLabel?.sizeToFit()
//        cell?.detailTextLabel?.sizeToFit()
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if self.i == 2 {
            return 150
        }else{
            
            return 100
        }
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let model = tableData[indexPath.row] as! ZhuanJiModel
        
//        if (model.priceTypeId != nil) {
//            let alertShow = UIAlertController.init(title: "警告", message: "此专辑是收费专辑(这个系列你就别点了)", preferredStyle: .Alert)
//            let alertAction = UIAlertAction.init(title: "ok", style: .Cancel, handler: { (action) in
//                
//            })
//            
//            alertShow.addAction(alertAction)
//            self.presentViewController(alertShow, animated: true, completion: { 
//                
//            })
//            
//        }else{
            MusicPlayer.shareInstance.creatPlayer(model.trackId!)
//        }
        
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.rootViewController?.isHidden = true
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
