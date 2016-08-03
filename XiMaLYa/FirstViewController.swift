//
//  FirstViewController.swift
//  XiMaLYa
//
//  Created by mr.scorpion on 16/7/28.
//  Copyright © 2016年 mr.scorpion. All rights reserved.
//

import UIKit

let kBANGDANURL = "http://mobile.ximalaya.com/mobile/discovery/v2/rankingList/group?channel=and-f6&device=android&includeActivity=true&includeSpecial=true&scale=2&version=4.3.20.2"

let kSCROLLERURL = "http://mobile.ximalaya.com/mobile/discovery/v1/recommends?channel=and-f6&device=android&includeActivity=true&includeSpecial=true&scale=2&version=4.3.20.2"

let kFENGLEIURL = "http://mobile.ximalaya.com/mobile/discovery/v1/categories?device=android&picVersion=10&scale=2"

let kJINGPINGURL = "http://mobile.ximalaya.com/m/subject_list?device=android&page=%d&per_page=10"


class FirstViewController: UIViewController,TopSlideViewDelegate,UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource {

    
    var page:Int?
    
    var titleView:UIView?
    var collectionView:UICollectionView?
    
    var tableView1:UITableView?
    var tableView2:UITableView?
    
    var table1Data:NSMutableArray = NSMutableArray()
    var table2Data:NSMutableArray = NSMutableArray()
    
    var scrollerData:NSMutableArray = NSMutableArray()
    var collectionData:NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "发现"
        self.view.backgroundColor = UIColor.whiteColor()
        page = 1
        // Do any additional setup after loading the view.
        
//        let button = UIButton.init(type: .Custom)
//        button.setTitle("测试", forState: .Normal)
//        button.frame = CGRectMake(10, 100, 60, 60)
//        button.setTitleColor(UIColor.redColor(), forState: .Normal)
//        button.addTarget(self, action: #selector(FirstViewController.btnCilck), forControlEvents: .TouchUpInside)
//        self.view.addSubview(button)
//        
//        let button1 = UIButton.init(type: .Custom)
//        button1.setTitle("测试", forState: .Normal)
//        button1.frame = CGRectMake(10, 200, 60, 60)
//        button1.setTitleColor(UIColor.redColor(), forState: .Normal)
//        button1.addTarget(self, action: #selector(FirstViewController.btnCilck1), forControlEvents: .TouchUpInside)
//        self.view.addSubview(button1)
//        
//        let playMusic:MusicPlayer = MusicPlayer.shareInstance
//        playMusic.playMusic()
//        
//        
//        let playMusic2:MusicPlayer = MusicPlayer.shareInstance
//        playMusic2.playMusic()
//        
//        print("\(playMusic) \(playMusic2)")
        
        creatSlider()
        creatUI()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.rootViewController?.isHidden = false
    }
    
    func creatSlider(){
        let slider:TopSlideView = TopSlideView()
        slider.frame = CGRectMake(0, 64, WIDTH, 42)
        slider.delegate = self;
        self.view.addSubview(slider)
    }
    
    func topSlideView(topSlide: TopSlideView!, didChanged index: UInt) {
        if index == 0 {
            self.view.bringSubviewToFront(tableView1!)
        }else{
            self.view.bringSubviewToFront(tableView2!)
        }
    }
    
    func creatUI(){
        creatData2()
        creatTableView2()
        
        titleView = UIView.init(frame: CGRectMake(0, 5, WIDTH, (WIDTH-10)/2+(WIDTH/6+15)*5))
//        self.view.addSubview(titleView!)
        
        creatScroller()
        creatCollectView()
        creatData1()
        creatTableView1()
    }
    
    func creatData2(){
        let networking = ZSLNetworking()
        networking.starRequest(kBANGDANURL, finishedBlcok: { (data) in
            
            let dic = try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves) as! NSDictionary
            let array = dic["datas"] as! NSArray
            //print(dic)
            if array.count>0{
                for i in 0..<array.count{
                    let dic1 = array[i]
                    
                    let array1 = dic1["list"] as! NSArray
                    
                    for i in 0..<array1.count{
                        let dic2 = array1[i]
                        let model = TableTwoModel.myModelWithDic(dic2 as! [NSObject : AnyObject])
                        self.table2Data.addObject(model)
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), { 
//                print(self.table2Data)
//                for i in 0..<self.table2Data.count{
//                    let model = self.table2Data[i] as! TableTwoModel
//                    //print("\(model.title) \(model.subtitle)")
//
//                }
                self.tableView2?.reloadData()
            })
            
            }) { (error) in
                print(error)
        }
    }
    func creatTableView2(){
        self.automaticallyAdjustsScrollViewInsets = false
        tableView2 = UITableView.init(frame: CGRectMake(0, 64+42, WIDTH, HEIGHT-64-42-49), style: .Plain)
        tableView2?.delegate = self
        tableView2?.dataSource = self
        self.view.addSubview(tableView2!)
        
    }
    func creatScroller(){
        
        let scrollView = SDCycleScrollView.init(frame: CGRectMake(0, 0, WIDTH, (WIDTH-10)/2))
        scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight
        scrollView.delegate = self
        scrollView.autoScrollTimeInterval = 2.0
        scrollView.dotColor = UIColor.whiteColor()
        self.titleView?.addSubview(scrollView)
        
        let networking = ZSLNetworking()
        networking.starRequest(kSCROLLERURL, finishedBlcok: { (data) in
            
            let dic = try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves) as! NSDictionary
            let array = dic["focusImages"]!["list"] as! NSArray
            for i in 0..<array.count{
                let dict = array[i] as! NSDictionary
                let str = dict["pic"] as! String
                //let scrollURL = NSURL.init(string: str)
                
                let type = dict["type"] as! NSNumber
                if type.isEqualToNumber(3){
                    //let trackId:Int = (dict["trackId"]?.integerValue)!
                    let dict1: Dictionary = ["URL": str, "trackId": dict["trackId"] as! NSNumber]
                    self.scrollerData.addObject(dict1)
                    
                }else if type.isEqualToNumber(4){
                    let webURL = dict["url"] as!String
                    let dict2:Dictionary = ["URL":str,"webUrl":webURL]
                    self.scrollerData.addObject(dict2)
                    
                }else if type.isEqualToNumber(2){
                    //let albumId:Int = (dict["albumId"]?.integerValue)!
                    let dict3: Dictionary = ["URL": str, "trackId": dict["albumId"] as! NSNumber]
                    self.scrollerData.addObject(dict3)
                }
                
            }
            
            let urlArray = NSMutableArray()
            for i in 0..<self.scrollerData.count{
                let dictionary = self.scrollerData[i] as!NSDictionary
                let string = dictionary["URL"] as! String
                let stringURL = NSURL.init(string: string)
                urlArray.addObject(stringURL!)
                
            }
            dispatch_async(dispatch_get_main_queue(), { 
                scrollView.imageURLsGroup = urlArray as [AnyObject]
            })
            
            
            }) { (error) in
                print(error)
        }
    }
    
    
    func cycleScrollView(cycleScrollView: SDCycleScrollView!, didSelectItemAtIndex index: Int) {
        let dic = scrollerData[index] as! NSDictionary
        if (dic["albumId"] != nil) {
            let zhuanJi = ZhuanJiViewController()
            zhuanJi.albumId = dic["albumId"] as? NSNumber
            self.navigationController?.pushViewController(zhuanJi, animated: true)
        }else if (dic["webUrl"] != nil){
            let webView = WebViewController()
            webView.urlString = dic["webUrl"] as? String
            self.navigationController?.pushViewController(webView, animated: true)
        }else if (dic["trackId"] != nil){
            MusicPlayer.shareInstance.creatPlayer(dic["trackId"] as! NSNumber)
        }
    }
    
    
    func creatCollectView(){
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSizeMake(WIDTH/6, WIDTH/6+15)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        collectionView = UICollectionView.init(frame: CGRectMake(0, (WIDTH-10)/2, WIDTH, (WIDTH/6+15)*5), collectionViewLayout: flowLayout)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = UIColor.whiteColor()
        self.titleView?.addSubview(collectionView!)
        collectionView?.registerNib(UINib.init(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "collectioncell")
        
        
        let networking = ZSLNetworking()
        networking.starRequest(kFENGLEIURL, finishedBlcok: { (data) in
            
            let dic = try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves) as!NSDictionary
            let array = dic["list"] as! NSArray
            for i in 0..<array.count{
                let dict = array[i] as!NSDictionary
                let model = CollectioModel.myModelWithDic(dict as [NSObject : AnyObject])
                self.collectionData.addObject(model!)
            }
            dispatch_async(dispatch_get_main_queue(), { 
//                print(self.collectionData)
//                for i in 0..<self.collectionData.count{
//                    let model = self.collectionData[i] as! CollectioModel
//                    print("\(model.title)")
//
//                }
                self.collectionView?.reloadData()
            })
            }) { (error) in
                print(error)
        }
        
    }
    func creatData1(){
        let urlString = NSString(format: kJINGPINGURL, page!) as String
        let networking = ZSLNetworking()
        if page == 1 {
            self.table1Data.removeAllObjects()
        }
        //print(urlString)
        networking.starRequest(urlString, finishedBlcok: { (data) in
            let dic = try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves) as! NSDictionary
            let array = dic["list"] as! NSArray
            for i in 0..<array.count{
                let dic = array[i] as! NSDictionary
                let model = TableOneModel.myModelWithDic(dic as [NSObject : AnyObject])
                self.table1Data.addObject(model)
            }
            dispatch_async(dispatch_get_main_queue(), {
//            print(self.table1Data)
//                for i in 0..<self.table1Data.count{
//                    let model = self.table1Data[i] as! TableOneModel
//                    print("\(model.title)")
//
//                }
                self.tableView1?.reloadData()
                self.tableView1?.es_stopPullToRefresh(completion: true)
                self.tableView1?.es_stopLoadingMore()
            })
            }) { (error) in
                print(error)
        }
        
        
    }
    func creatTableView1(){
        tableView1 = UITableView.init(frame: CGRectMake(0, 64+42, WIDTH, HEIGHT-64-42), style: .Grouped)
        tableView1?.delegate = self
        tableView1?.dataSource = self
        tableView1?.tableHeaderView = self.titleView
        //tableView1?.separatorStyle = .None
        self.view.addSubview(tableView1!)
        
        weak var mySelf = self
        tableView1?.es_addPullToRefresh(handler: {
            mySelf?.page = 1
            mySelf?.creatData1()
        })
        tableView1?.refreshIdentifier = NSStringFromClass(FirstViewController)
        tableView1?.expriedTimeInterval = 20.0
        tableView1?.es_addInfiniteScrolling(handler: { 
            mySelf?.page = (mySelf?.page)! + 1
            mySelf?.creatData1()
        })
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collectionData.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView .dequeueReusableCellWithReuseIdentifier("collectioncell", forIndexPath: indexPath) as! CollectionViewCell
        let model = collectionData[indexPath.row] as! CollectioModel
        cell.model = model
        return cell
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableView1 {
            return table1Data.count
        }else{
            return table2Data.count
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView == tableView1 {
            var cell = tableView.dequeueReusableCellWithIdentifier("tableViewCell") as? TableViewCell
            if cell == nil {
                cell = NSBundle.mainBundle().loadNibNamed("TableViewCell", owner: self, options: nil)[0] as? TableViewCell
            }
            
            let model = table1Data[indexPath.row] as! TableOneModel
            cell?.model = model
            cell?.selectionStyle = UITableViewCellSelectionStyle.None
            return cell!
            
        }else{
            let identifier = "cell"
            var cell = tableView.dequeueReusableCellWithIdentifier(identifier)
            if cell == nil {
                cell = UITableViewCell.init(style: UITableViewCellStyle.Subtitle, reuseIdentifier: identifier)
            }
            let array = ["bang0","bang1","bang2","bang3","bang4","bang5"]
            
            let imageArray = NSMutableArray()
            
            for i in 0..<self.table2Data.count {
                let number = i%6
                imageArray.addObject(array[number])
            }
            
            let model = table2Data[indexPath.row] as! TableTwoModel
            
            cell?.imageView?.image = UIImage.init(named: imageArray[indexPath.row] as! String)
            cell?.textLabel?.text = model.title;
            cell?.detailTextLabel?.text = model.subtitle
            cell?.selectionStyle = UITableViewCellSelectionStyle.None
            return cell!
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView == tableView2 {
            return 80
        }else{
            return 100
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let model = collectionData[indexPath.row] as! CollectioModel
        let sub = CollectionSubView()
        sub.Id = model.Id
        self.navigationController?.pushViewController(sub, animated: true)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == tableView1 {
            let model = table1Data[indexPath.row] as! TableOneModel
            let tb = First_01ViewController()
            tb.specialId = model.specialId
            tb.contentType = model.contentType
            self.navigationController?.pushViewController(tb, animated: true)
        }else{
            let model = table2Data[indexPath.row] as! TableTwoModel
            let bdSub = BDSubViewController()
            bdSub.key = model.key
            bdSub.contentType = model.contentType
            bdSub.currentPage = indexPath.row
            self.navigationController?.pushViewController(bdSub, animated: true)
        }
    }
    
    
    
//    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if tableView == tableView1 {
//            return (WIDTH-10)/2+(WIDTH/6+15)*5
//        }else{
//            return 0
//        }
//    }
    
    
//    func btnCilck(){
//        let delegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        delegate.rootViewController?.isHidden = true
//    }
//    func btnCilck1(){
//        let delegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        delegate.rootViewController?.isHidden = false
//        
//    }
    
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
