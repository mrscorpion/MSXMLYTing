//
//  MusicPlayer.swift
//  XiMaLYa
//
//  Created by mr.scorpion on 16/7/28.
//  Copyright © 2016年 mr.scorpion. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

protocol UpdateList {
    func updateList()
}

let kPLAYURL = "http://mobile.ximalaya.com/v1/track/baseInfo?device=iPhone&trackId=%@"

let kMENUURL = "http://mobile.ximalaya.com/mobile/playlist/album?trackId=%@&albumId=%@&device=android"

class MusicPlayer: UIResponder,UITableViewDelegate,UITableViewDataSource {
    
    var player:AVPlayer?
    var playURL:String?
    var playerView:UIView?
    var playerBackView:UIImageView?
    var playerButton:UIButton?

    var isFavorite:Bool = false
    var isXunHuan:Bool = true
    var isPlay:Bool = true

    var playerTitle:UILabel?
    var playerCollect:UIButton?
    var playerImage:UIImageView?
    var playerSlider:UISlider?
    var playerTotalTime:UILabel?
    var playerCurrentLabel:UILabel?
    var playerPlay:UIButton?
    var playerData:NSDictionary?
    var nextData:NSMutableArray = NSMutableArray()
    var nextPage:Int?
    var timers:NSTimer?
    var currentPage = 1
    
    var menuView:UIView?
    var tableView:UITableView?
    
    var updateDelegate:UpdateList?
    
    var beforeTrackId:NSNumber?
    var beforeTitle:String?
    
    static let shareInstance = MusicPlayer()
    
    //MARK:-- 初始化，只执行一次
    private override init() {
        
        super.init()

        print("单例播放器,只创建一次")
        
        self.playerView = UIView.init(frame: CGRectMake(0, 0, WIDTH, HEIGHT))
        self.playerView?.backgroundColor = UIColor.whiteColor()
        
        UIApplication.sharedApplication().keyWindow?.addSubview(self.playerView!)

        playerBackView = UIImageView.init(frame: (self.playerView?.bounds)!)
        playerBackView?.alpha = 0.3
        self.playerView?.addSubview(playerBackView!)

        let playerBackBtn = UIButton.init(type: .Custom)
        playerBackBtn.frame = CGRectMake(5, 45, 40, 40)
        playerBackBtn.tag = 1
        playerBackBtn.setBackgroundImage(UIImage.init(named: "3"), forState: .Normal)
        playerBackBtn.addTarget(self, action: #selector(self.btnClick(_:)), forControlEvents: .TouchUpInside)
        self.playerView?.addSubview(playerBackBtn)
        
        let space1 = (WIDTH-120)/2
        let playerMenu = UIButton.init(type: .Custom)
        playerMenu.frame = CGRectMake(space1, 45, 40, 40)
        playerMenu.setBackgroundImage(UIImage.init(named: "7"), forState: .Normal)
        playerMenu.addTarget(self, action: #selector(self.menuClick(_:)), forControlEvents: .TouchUpInside)
        self.playerView?.addSubview(playerMenu)
        
        playerCollect = UIButton.init(type: .Custom)
        playerCollect!.frame = CGRectMake(space1+80, 45, 40, 40)
        
        
        let imageName = isFavorite ? "unLike":"isLike"
        
        //print(imageName)
        
        playerCollect!.setBackgroundImage(UIImage.init(named: imageName), forState: .Normal)
        playerCollect!.tag = 2
        playerCollect!.addTarget(self, action: #selector(self.btnClick(_:)), forControlEvents: .TouchUpInside)
        self.playerView?.addSubview(playerCollect!)
        
        let playerType = UIButton.init(type: .Custom)
        playerType.frame = CGRectMake(WIDTH-45, 45, 40, 40)
        playerType.setTitle(isXunHuan ? "全部":"单曲", forState: .Normal)
        playerType.setTitleColor(UIColor.tomatoColor(), forState: .Normal)
        playerType.tag = 3
        playerType.addTarget(self, action: #selector(self.btnClick(_:)), forControlEvents: .TouchUpInside)
        self.playerView?.addSubview(playerType)
        
        //print(HEIGHT)
        let space2 = (HEIGHT-444-85)/2+65-20
        
        playerTitle = UILabel.init(frame: CGRectMake(40, 20+space2, WIDTH-80, 64))
        playerTitle?.numberOfLines = 0
        playerTitle?.text = "测试"
        playerTitle?.textAlignment = .Center
        self.playerView?.addSubview(playerTitle!)

        playerImage = UIImageView.init(frame: CGRectMake((WIDTH-240)/2, space2+84, 240, 240))
        playerImage?.layer.cornerRadius = 120
        playerImage?.clipsToBounds = true
        playerImage?.image = UIImage.init(named: "i0.jpg")
        
        self.playerView?.addSubview(playerImage!)
        
        playerCurrentLabel = UILabel.init(frame: CGRectMake(10, space2+84+195+65, 60, 40))
        playerCurrentLabel?.text = "1.04"
        playerCurrentLabel?.textAlignment = .Left
        //playerCurrentLabel?.backgroundColor = UIColor.redColor()
        self.playerView?.addSubview(playerCurrentLabel!)
        
        playerSlider = UISlider.init(frame: CGRectMake(80, space2+84+195+65, WIDTH-160, 31))
        playerSlider?.minimumValue = 0
        playerSlider?.maximumValue = 1
        playerSlider?.value = 0
        
        self.playerView?.addSubview(playerSlider!)
        
        playerTotalTime = UILabel.init(frame: CGRectMake(WIDTH-70, space2+84+195+65, 60, 40))
        playerTotalTime?.textAlignment = .Center
        playerTotalTime?.text = "3.45"
        //playerTotalTime?.backgroundColor = UIColor.redColor()
        self.playerView?.addSubview(playerTotalTime!)
        
        let space3 = (WIDTH-120)/4
        
        let playerPrevious = UIButton.init(type: .Custom)
        playerPrevious.frame = CGRectMake(space3, space2+279+60+65, 40, 40)
        playerPrevious.setBackgroundImage(UIImage.init(named: "last"), forState: .Normal)
        playerPrevious.imageView?.contentMode = .ScaleAspectFit
        playerPrevious.clipsToBounds = true
        playerPrevious.layer.cornerRadius = 20
        playerPrevious.tag = 4
        playerPrevious.addTarget(self, action: #selector(self.btnClick(_:)), forControlEvents: .TouchUpInside)
        self.playerView?.addSubview(playerPrevious)
        

        playerPlay = UIButton.init(type: .Custom)
        playerPlay!.frame = CGRectMake(space3+90, space2+279+60+65, 40, 40)
        playerPlay!.setBackgroundImage( UIImage.init(named: "pasu"), forState: .Normal)
        
        
        
        playerPlay!.imageView?.contentMode = .ScaleAspectFit
        playerPlay!.clipsToBounds = true
        playerPlay!.layer.cornerRadius = 20
        playerPlay!.tag = 5
        playerPlay!.addTarget(self, action: #selector(self.btnClick(_:)), forControlEvents: .TouchUpInside)
        self.playerView?.addSubview(playerPlay!)
        
        let playerNext = UIButton.init(type: .Custom)
        playerNext.frame = CGRectMake(space3+180, space2+279+60+65, 40, 40)
        playerNext.setBackgroundImage(UIImage.init(named: "next"), forState: .Normal)
        playerNext.imageView?.contentMode = .ScaleAspectFit
        playerNext.clipsToBounds = true
        playerNext.layer.cornerRadius = 20
        playerNext.tag = 6
        playerNext.addTarget(self, action: #selector(self.btnClick(_:)), forControlEvents: .TouchUpInside)
        self.playerView?.addSubview(playerNext)
        
        menuView = UIView.init(frame: CGRectMake(0, HEIGHT, WIDTH, HEIGHT))
        menuView?.backgroundColor = UIColor.whiteColor()
        
        UIApplication.sharedApplication().keyWindow?.addSubview(menuView!)
        
        
        let menuBack = UIButton.init(type: .Custom)
        menuBack.frame = CGRectMake(10, 20, 40, 40)
        menuBack.setTitle("返回", forState: .Normal)
        menuBack.setTitleColor(UIColor.redColor(), forState: .Normal)
        menuBack.addTarget(self, action: #selector(self.menuBack), forControlEvents: .TouchUpInside)
        menuView?.addSubview(menuBack)
        
        tableView = UITableView.init(frame: CGRectMake(0, 60, WIDTH, HEIGHT-64), style: .Plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        menuView?.addSubview(tableView!)
        
//        self.playerButton = UIButton.init(type: .Custom)
//        playerButton?.frame = CGRectMake(WIDTH-60, 64, 60, 60)
//        self.playerButton?.setTitle("隐藏", forState: .Normal)
//        self.playerButton?.setTitleColor(UIColor.redColor(), forState: .Normal)
//        self.playerButton?.addTarget(self, action: #selector(self.btnClick1), forControlEvents: .TouchUpInside)
//        self.playerView?.addSubview(self.playerButton!)
        
    }
    
    
//    func btnClick1(sender:UIButton){
//        self.playerMusicViewHidden(true)
//    }
    
    //MARK:--隐藏播放界面
    func playerMusicViewHidden(sender:Bool){
        if sender {
            self.playerView?.frame = CGRectMake(0, HEIGHT, WIDTH, HEIGHT)
        }else{
            self.playerView?.frame = CGRectMake(0, 0, WIDTH, HEIGHT)
            
            if self.playerData?["trackId"] != nil {
                isFavorite = DBManager.shareManager.isDataExist(playerData!["trackId"] as! NSNumber)
                let imageName = isFavorite ? "unLike":"isLike"
                playerCollect!.setBackgroundImage(UIImage.init(named: imageName), forState: .Normal)
            }
            
            
        }
        
    }

    //MARK:--播放界面按钮实现
    func btnClick(sender:UIButton){
        if sender.tag == 1 {
            self.playerMusicViewHidden(true)
        }else if sender.tag == 2{
           
            isFavorite = !isFavorite
            
            if isFavorite == true {
                let model = ZhuanJiModel()
                model.trackId = self.playerData!["trackId"] as? NSNumber
                model.coverMiddle = self.playerData!["coverLarge"] as? String
                model.title = self.playerData!["title"] as? String
                model.playtimes = self.playerData!["playtimes"] as? NSNumber
                
                DBManager.shareManager.insertData(model)
            }else{
                let trackID = self.playerData!["trackId"] as? NSNumber
                DBManager.shareManager.deleteDataById(trackID!)
            }
            
            let imageName = isFavorite ? "unLike":"isLike"
            //print(imageName)
            sender.setBackgroundImage(UIImage.init(named: imageName), forState: .Normal)
            
            if (self.updateDelegate != nil) {
                self.updateDelegate?.updateList()
            }
            
        }else if sender.tag == 3{
            isXunHuan = !isXunHuan
            if isXunHuan {
                sender.setTitle("全部", forState: .Normal)
            }else{
                sender.setTitle("单曲", forState: .Normal)
            }
            
        }else if sender.tag == 4{
            self.previousTrackMusic()
            
        }else if sender.tag == 5{
            isPlay = !isPlay
            if isPlay {
                sender.setBackgroundImage(UIImage.init(named: "play"), forState: .Normal)
                player?.play()
            }else{
                sender.setBackgroundImage(UIImage.init(named: "pasu"), forState: .Normal)
                player?.pause()
            }
            
        }else if sender.tag == 6{
            self.nextPlayMusic()
            
        }
    }
    
    func previousTrackMusic(){
        currentPage = 2
        
        var k = 0
        nextPage = 0
        
        for i in 0..<nextData.count {
            let model = nextData[i] as! MenuModel
            
            let str1 = model.trackId
            let str2 = playerData!["trackId"] as! NSNumber
            //print("\(str1)+++\(str2)")
            if str1 == str2 {
                k = nextPage!
                break
            }else{
                nextPage = nextPage!+1
            }
            
        }
        
        if k>0 {
            let model = nextData[k-1] as! MenuModel
            self.creatPlayer(model.trackId!)
        }else{
            let model = nextData.lastObject as! MenuModel
            self.creatPlayer(model.trackId!)
        }
    }
    
    func nextPlayMusic(){
        currentPage = 2
        var k = 0
        nextPage = 0
        for i in 0..<nextData.count {
            let model = nextData[i] as! MenuModel
            
            let str1 = model.trackId
            let str2 = playerData!["trackId"] as! NSNumber
            //print("\(str1)+++\(str2)")
            if str1 == str2 {
                k = nextPage!
                break
            }else{
                nextPage = nextPage!+1
            }
            
        }
        
        //print(k)
        if k<nextData.count-1 {
            let model = nextData[k+1] as! MenuModel
            self.creatPlayer(model.trackId!)
        }else{
            let model = nextData[0] as! MenuModel
            self.creatPlayer(model.trackId!)
        }
    }
    
    //MARK: -- 创建Menu
    func menuClick(sender:UIButton){
        
        menuView?.frame = CGRectMake(0, 0, WIDTH, HEIGHT)
        
        if nextData.count>0 {
            tableView?.reloadData()
            
            let str1 = playerTitle?.text
            for i in 0..<nextData.count {
                let model = nextData[i] as! MenuModel
                if str1 == model.title {
                    tableView?.selectRowAtIndexPath(NSIndexPath.init(forRow: i, inSection: 0), animated: true, scrollPosition: .Middle)
                }
            }
        }else{
            let alertShow = UIAlertView.init(title: "糟糕", message: "由于后台数据缘故，没有相关播放列表，请返回（反正我又不上线，没有就没有）", delegate: self, cancelButtonTitle: "OK")
            alertShow.show()
        }
        
    }
    
    func menuBack(){
        menuView?.frame = CGRectMake(0, HEIGHT, WIDTH, HEIGHT)
    }
    
    //MARK:-- 播放的数据
    func creatPlayer(sender:NSNumber){
        
        //print(sender)
        self.playerMusicViewHidden(false)
        
        if sender == self.beforeTrackId {
            return
        }
        if (timers != nil) {
            print("timers释放")
            timers?.invalidate()
        }
        let strURL = NSString (format: kPLAYURL, sender) as String
        print(strURL)
        let networking = ZSLNetworking()
        networking.starRequest(strURL, finishedBlcok: { (data) in
            let dic = try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves) as! NSDictionary
            //print(dic["duration"])
            //print(dic)
            self.playURL = dic["playUrl64"] as? String
            self.playerData = dic
            self.beforeTrackId = dic["trackId"] as? NSNumber
            self.beforeTitle = dic["title"] as? String
            if self.currentPage == 1{
                print("创建播放列表")
                self.nextData.removeAllObjects()
                
                if (dic["albumId"] != nil){
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                        let urlString = NSString (format: kMENUURL, dic["albumId"]as! NSNumber,dic["albumId"]as! NSNumber) as String
                        let networking1 = ZSLNetworking()
                        networking1.starRequest(urlString, finishedBlcok: { (data) in
                            
                            let dic1 = try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves) as! NSDictionary
                            //print(dic1)
                            let array = dic1["data"] as! NSArray
                            
                            for i in 0..<array.count{
                                let dictionary1 = array[i] as!NSDictionary
                                let model = MenuModel.myModelWithDic(dictionary1 as [NSObject : AnyObject])
                                self.nextData.addObject(model)
                            }
                            
                            }, failedBlock: { (error) in
                                print(error)
                        })
                        
                    })
                }else{
                    
                }
                
                
                
                
            }else{
                self.currentPage = 1
            }
            
            
            dispatch_async(dispatch_get_main_queue(), {
                print("播放网址:\(self.playURL)")
                
                if (self.playURL != nil) {
                    self.playMusic()
                }else{
//                    let alertController = UIAlertController.init(title: "糟糕", message: "由于后台数据缘故，没有播放网址，请换曲（反正我又不上线，没有就没有）", preferredStyle: .Alert)
//                    let action = UIAlertAction.init(title: "OK", style: .Cancel, handler: nil)
//                    alertController.addAction(action)
                    let alertShow = UIAlertView.init(title: "糟糕", message: "由于后台数据缘故，没有播放网址，请换曲（反正我又不上线，没有就没有）", delegate: self, cancelButtonTitle: "OK")
                    alertShow.show()
                    
                }
                
                
            })
            
            }) { (error) in
                print(error)
        }
        
    }
    
    
    
    //MARK: -- 创建播放器
    func playMusic(){
        
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        
        self.becomeFirstResponder()
        
        self.configNowPlayingInfoCenter()
        
        
        isPlay = true
        
        playerBackView?.sd_setImageWithURL(NSURL.init(string: (playerData!["coverLarge"] as? String)!))
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if delegate.firstPlayMusic == "yes" {
            playerPlay!.setBackgroundImage( UIImage.init(named: "pasu"), forState: .Normal)
            self.isPlay = false
        }else{
            playerPlay!.setBackgroundImage( UIImage.init(named: "play"), forState: .Normal)
            self.isPlay = true
        }
        
        playerTitle?.text = playerData!["title"] as? String
        playerImage?.transform = CGAffineTransformMakeRotation(0)
        
        playerImage?.sd_setImageWithURL(NSURL.init(string: (playerData!["coverLarge"] as? String)!))
        let totalTime = playerData!["duration"]?.intValue
        let fen = totalTime!/60
        let miao = totalTime!-fen*60
        
        playerTotalTime?.text = NSString (format: "%02d:%02d", fen,miao) as String
        
        
        isFavorite = DBManager.shareManager.isDataExist(playerData!["trackId"] as! NSNumber)
        let imageName = isFavorite ? "unLike":"isLike"
        playerCollect!.setBackgroundImage(UIImage.init(named: imageName), forState: .Normal)
        
        
        //print(playURL)
        
        let playItem = AVPlayerItem (URL: NSURL.init(string: playURL!)!)
        self.player = AVPlayer.init(playerItem: playItem)
        
        playerSlider?.addTarget(self, action: #selector(self.playerSliderChange(_:)), forControlEvents: .ValueChanged)
        
        weak var mySlider = playerSlider
        weak var myCurrentLabel = playerCurrentLabel
        //weak var myPlayerImage = playerImage
        weak var mySelf = self
        
        player?.addPeriodicTimeObserverForInterval(CMTimeMake(1, 100), queue: dispatch_get_main_queue(), usingBlock: { (time) in

            let time1 = Float((mySelf!.player?.currentItem?.currentTime().value)!)
            let time2 = Float((mySelf?.player?.currentItem?.currentTime().timescale)!)
            
            let playerPlayTime = time1/time2
            
            let playerTimeFen = Int(playerPlayTime/60)
            let playerTimeMiao = Int(playerPlayTime) - playerTimeFen*60
            
            myCurrentLabel?.text = NSString (format: "%02d:%02d", playerTimeFen,playerTimeMiao) as String
            //print(myCurrentLabel?.text)
            
            let time3 = Float((mySelf?.player?.currentItem?.duration.value)!)
            let time4 = Float((mySelf?.player?.currentItem?.duration.timescale)!)
            
            let totalTime = time3/time4
            
            mySlider?.value = playerPlayTime/totalTime
            
            //myPlayerImage?.transform = CGAffineTransformRotate((myPlayerImage?.transform)!, CGFloat(M_PI/8))
            
            
        })
        
        timers = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(self.timeChange), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timers!, forMode: NSRunLoopCommonModes)
        timers?.fire()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.playBack), name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
        if delegate.firstPlayMusic == "yes" {
            delegate.firstPlayMusic = "no"
        }else{
            player?.play()
        }

        delegate.isPlayMusic = "yes"
        
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(true)
        try! session.setCategory(AVAudioSessionCategoryPlayback)
    }
    
    //MARK: -- playerImage旋转
    func timeChange(){
        
        UIView.animateWithDuration(2) {
            self.playerImage?.transform = CGAffineTransformRotate((self.playerImage?.transform)!, CGFloat(M_PI/8))
        }
        
    }
    
    //MARK:--监听播放结束
    func playBack(){
        currentPage = 2
        if !isXunHuan {
            
            self.creatPlayer(playerData!["trackId"] as! NSNumber)
            NSNotificationCenter.defaultCenter().removeObserver(self, name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
        }else{
            
            var k = 0
            nextPage = 0
            for i in 0..<nextData.count {
                let model = nextData[i] as! MenuModel
                
                let str1 = model.trackId
                let str2 = playerData!["trackId"] as! NSNumber
                //print("\(str1)+++\(str2)")
                if str1 == str2 {
                    k = nextPage!
                    break
                }else{
                    nextPage = nextPage!+1
                }
                
            }
            NSNotificationCenter.defaultCenter().removeObserver(self, name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
            //print(k)
            if k<nextData.count-1 {
                let model = nextData[k+1] as! MenuModel
                self.creatPlayer(model.trackId!)
            }else{
                let model = nextData[0] as! MenuModel
                self.creatPlayer(model.trackId!)
            }
        }
    }
    
    //MARK:--Slider滑动实现
    func playerSliderChange(sender:UISlider){
        
        let durationValue = self.player?.currentItem?.duration.value
        
        let max = Float(durationValue!)*sender.value
        
        let max1 = Int64(max)
        
        let currentTime = CMTimeMake(max1, (self.player?.currentItem?.duration.timescale)!)

        player?.seekToTime(currentTime)
        if sender.value == 1 {
            player?.pause()
        }else{
            player?.play()
        }
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nextData.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")
        if cell == nil {
            cell = UITableViewCell.init(style: .Default, reuseIdentifier: "cell")
        }
        let model = nextData[indexPath.row] as! MenuModel
        cell?.textLabel?.text = model.title
        cell?.textLabel?.numberOfLines = 0
        cell?.textLabel?.font = UIFont.systemFontOfSize(16)
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let model = nextData[indexPath.row] as! MenuModel
        self.creatPlayer(model.trackId!)
        UIView.animateWithDuration(0.2) { 
            self.menuView?.frame = CGRectMake(WIDTH, 0, WIDTH, HEIGHT)
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let model = nextData[indexPath.row] as! MenuModel
        print("\((model.title! as NSString))")
        let size = (model.title! as NSString).myBoundingRectWithSize(CGSizeMake(WIDTH/2, 0), withFontSize: 16)
        print(size.height)
        
        if  size.height<45 {
            return 45
        }else{
            return size.height
        }
        
    }
    
    func configNowPlayingInfoCenter(){
        if (NSClassFromString("MPNowPlayingInfoCenter") != nil) {
            
            var dic = [String:AnyObject]()
            dic[MPMediaItemPropertyTitle] = playerData!["title"] as! String
            dic[MPMediaItemPropertyArtist] = "赵少"
            dic[MPMediaItemPropertyAlbumTitle] = "带你装逼带你飞"
            dic[MPNowPlayingInfoPropertyPlaybackRate] = NSNumber.init(float: 1.0)
            dic[MPMediaItemPropertyPlaybackDuration] = playerData!["duration"] as! NSNumber
            let url = NSURL.init(string: playerData!["coverLarge"] as! String)
            let data = NSData.init(contentsOfURL: url!)
            let image = UIImage.init(data: data!)
            let artwork = MPMediaItemArtwork.init(image: image!)
            dic[MPMediaItemPropertyArtwork] = artwork
            //print(dic)
            MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = dic
            
        }
    }
    
    
    
    override func remoteControlReceivedWithEvent(event: UIEvent?) {
        super.remoteControlReceivedWithEvent(event)
        print(0)
        if event?.type == .RemoteControl {
            print(1)
            if event?.subtype == UIEventSubtype.RemoteControlPlay {
                print(2)
                player?.play()
            }else if event?.subtype == UIEventSubtype.RemoteControlPause{
                print(3)
                player?.pause()
            }else if event?.subtype == UIEventSubtype.RemoteControlPreviousTrack{
                print(4)
                self.previousTrackMusic()
            }else if event?.subtype == UIEventSubtype.RemoteControlNextTrack{
                print(5)
                self.nextPlayMusic()
            }
        }
    }
    override func canBecomeFirstResponder() -> Bool {
        super.canBecomeFirstResponder()
        print(6666)
        return true
    }
}


