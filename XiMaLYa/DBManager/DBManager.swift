//
//  DBManager.swift
//  XiMaLYa
//
//  Created by mr.scorpion on 16/8/5.
//  Copyright © 2016年 mr.scorpion. All rights reserved.
//

import UIKit


class DBManager: NSObject {
    
    var db:FMDatabase?
    
    static let shareManager = DBManager()
    private override init() {
        super.init()
        let path = NSHomeDirectory().stringByAppendingString("/Documents/music.db")
        print(path)
        db = FMDatabase.init(path: path)
        if db?.open() == true {
            let sql = "create table if not exists collect(collectId integer primary key autoincrement,trackId varchar(255),coverMiddle varchar(255),title varchar(255),playtimes varchar(255))"
            let ret = db?.executeUpdate(sql, withArgumentsInArray: nil)
            if ret == false {
                print("create table error:\(db?.lastErrorMessage())")
            }
        }else{
            print("数据库打开失败")
        }
    }
    
    func insertData(model:ZhuanJiModel){
        let str = "insert into collect(trackId,coverMiddle,title,playtimes)values(?,?,?,?)"
        //let sql = NSString.init(format: str, model.trackId!,model.coverMiddle!,model.title!,model.playtimes!) as String
        print("\(model.trackId)++\(model.coverMiddle)++\(model.title)++\(model.playtimes)")
        let ret = db?.executeUpdate(str, withArgumentsInArray: [model.trackId!,model.coverMiddle!,model.title!,model.playtimes!])
        if ret == false {
            print("insert error:\(db?.lastErrorMessage())")
        }
    }
    
    func deleteDataById(trackId:NSNumber){
        let str = "delete from collect where trackId=?"
        //let sql = NSString.init(format: str, trackId) as String
        let ret = db?.executeUpdate(str, withArgumentsInArray: [trackId])
        if  ret == false {
            print("delete error:\(db?.lastErrorMessage())")
        }
    }
    
    func fetchData() -> NSArray {
        let array = NSMutableArray()
        let sql = "select * from collect"
        let set = db?.executeQuery(sql, withArgumentsInArray: nil)
        while set?.next() == true {
            let model = ZhuanJiModel()
            let f = NSNumberFormatter()
            model.trackId = f.numberFromString((set?.stringForColumn("trackId"))!)
            model.coverMiddle = set?.stringForColumn("coverMiddle")
            model.title = set?.stringForColumn("title")
            model.playtimes = f.numberFromString((set?.stringForColumn("playtimes"))!)
            array.addObject(model)
        }
        return array
    }
    
    func isDataExist(trackId:NSNumber) -> Bool{
        let path = NSHomeDirectory().stringByAppendingString("/Documents/music.db")
        print(path)
        let str = "select * from collect where trackId = ?"
        //let sql = NSString.init(format: str, trackId) as String
        let set = db?.executeQuery(str, withArgumentsInArray: [trackId])
        return (set?.next())!
    }
    
    
    
    
}
