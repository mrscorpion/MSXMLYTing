//
//  ForthViewController.swift
//  XiMaLYa
//
//  Created by mr.scorpion on 16/7/28.
//  Copyright © 2016年 mr.scorpion. All rights reserved.
//

import UIKit





class ForthViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UpdateList {

    var tableView:UITableView?
    var dataArray = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我"
        self.view.backgroundColor = UIColor.whiteColor()
        creatData()
        creatUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        creatData()
        
    }
    
    func creatUI(){
        tableView = UITableView.init(frame: CGRectMake(0, 0, WIDTH, HEIGHT), style: .Plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        //tableView?.separatorStyle = .None
        self.view.addSubview(tableView!)
    }
    func creatData(){
        dataArray = DBManager.shareManager.fetchData()
        tableView?.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "FavoriteCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? FavoriteTableCell
        if cell == nil {
            cell = NSBundle.mainBundle().loadNibNamed("FavoriteTableCell", owner: self, options: nil)[0] as? FavoriteTableCell
        }
        let model = dataArray[indexPath.row] as! ZhuanJiModel
        cell?.model = model
        cell?.selectionStyle = .None
        
        let backview = UIView.init(frame: (cell?.contentView.frame)!)
        backview.backgroundColor = UIColor.clearColor()
        cell?.selectedBackgroundView = backview
        let deleteButton = MGSwipeButton.init(title: "取消收藏", backgroundColor: UIColor.redColor()) { (sender) -> Bool in
            
            DBManager.shareManager.deleteDataById(model.trackId!)
            self.creatData()
            
            return true
        }
        cell?.rightButtons = [deleteButton]
        
        return cell!
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let model = dataArray[indexPath.row] as! ZhuanJiModel
        MusicPlayer.shareInstance.updateDelegate = self
        MusicPlayer.shareInstance.creatPlayer(model.trackId!)
    }
    
    func updateList() {
        creatData()
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
