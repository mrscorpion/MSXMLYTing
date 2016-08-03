//
//  CollectionSubView.swift
//  XiMaLYa
//
//  Created by mr.scorpion on 16/8/4.
//  Copyright © 2016年 mr.scorpion. All rights reserved.
//

import UIKit

let kXIANGQINGURL = "http://mobile.ximalaya.com/mobile/discovery/v2/category/recommends?categoryId=%@&contentType=album&device=android&scale=2&version=4.3.20.2"

class CollectionSubView: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SDCycleScrollViewDelegate {

    var Id:NSNumber?
    var dataArray1 = NSMutableArray()
    var dataArray2 = NSMutableArray()
    var scrollData = NSMutableArray()
    var collectionView:UICollectionView?
    var scrollerView:SDCycleScrollView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        //print(Id)
        
        creatData()
        creatUI()
        
        // Do any additional setup after loading the view.
    }

    
    func creatUI(){
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSizeMake((WIDTH-8)/3, 40)
        flowLayout.minimumLineSpacing = 2
        flowLayout.minimumInteritemSpacing = 2
        collectionView = UICollectionView.init(frame: CGRectMake(2, 0, WIDTH-4, HEIGHT-64), collectionViewLayout: flowLayout)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(collectionView!)
        
        collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "collection")
        collectionView?.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
    }
    
    func creatData(){
        let urlString = NSString.init(format: kXIANGQINGURL, Id!) as String
        let networking = ZSLNetworking()
        networking.starRequest(urlString, finishedBlcok: { (data) in
            
            let dic = try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves) as! NSDictionary
            let array = dic["focusImages"]!["list"] as! NSArray
            
            for i in 0..<array.count{
                let dict = array[i] as! NSDictionary
                let stringURL = dict["pic"] as! String
                
                let type = dict["type"] as! NSNumber
                if type.isEqualToNumber(3){
                    //let trackId:Int = (dict["trackId"]?.integerValue)!
                    let dict1: Dictionary = ["URL": stringURL, "trackId": dict["trackId"] as! NSNumber]
                    self.scrollData.addObject(dict1)
                    
                }else if type.isEqualToNumber(4) || type.isEqualToNumber(8){
                    let webURL = dict["url"] as!String
                    let dict2:Dictionary = ["URL":stringURL,"webUrl":webURL]
                    self.scrollData.addObject(dict2)
                    
                }else if type.isEqualToNumber(2){
                    //let albumId:Int = (dict["albumId"]?.integerValue)!
                    let dict3: Dictionary = ["URL": stringURL, "trackId": dict["albumId"] as! NSNumber]
                    self.scrollData.addObject(dict3)
                }
            }
            
            
            
            let array2 = dic["tags"]!["list"] as! NSArray
            for i in 0..<array2.count{
                let dictionary = array2[i] as! NSDictionary
                self.dataArray1.addObject(dictionary["tname"] as! String)
                self.dataArray2.addObject(dictionary["category_id"] as! NSNumber)
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                //self.scrollerView?.imageURLsGroup = urlArray as [AnyObject]
                self.collectionView?.reloadData()
            })
            
            }) { (error) in
                print(error)
        }
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {

        var headerView = UICollectionReusableView()
        if kind == UICollectionElementKindSectionHeader {

            headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "header", forIndexPath: indexPath)
            let urlArray = NSMutableArray()
            for i in 0..<self.scrollData.count {
                let dic = self.scrollData[i]
                let url = NSURL.init(string: dic["URL"] as! String)
                urlArray.addObject(url!)
            }
            
            scrollerView = SDCycleScrollView.init(frame: CGRectMake(0, 0, WIDTH, (WIDTH-10)/2), imageURLsGroup: urlArray as [AnyObject])
            scrollerView!.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter
            scrollerView!.delegate = self
            scrollerView!.autoScrollTimeInterval = 2.0
            scrollerView!.dotColor = UIColor.whiteColor()
            headerView.addSubview(scrollerView!)
        }
        return headerView
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if scrollData.count == 0 {
            let size = CGSizeMake(0, 0)
            return size
        }
        let size = CGSizeMake(WIDTH, (WIDTH-10)/2+5)
        return size
    }
    
    func cycleScrollView(cycleScrollView: SDCycleScrollView!, didSelectItemAtIndex index: Int) {
        let dic = scrollData[index] as! NSDictionary
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
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collection", forIndexPath: indexPath)
        let title = UILabel.init(frame: cell.contentView.bounds)
        title.backgroundColor = UIColor.lightCoral()
        title.text = dataArray1[indexPath.item] as? String
        title.textAlignment = .Center
        cell.contentView.addSubview(title)
        return cell
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray1.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let collectDetail = CollectionDetailController()
        collectDetail.name = dataArray1[indexPath.row] as? String
        collectDetail.categeId = dataArray2[indexPath.row] as? NSNumber
        self.navigationController?.pushViewController(collectDetail, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.rootViewController?.isHidden = true
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
