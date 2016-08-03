//
//  WCRefreshHeaderAnimator.swift
//  ESPullToRefreshExample
//
//  Created by lihao on 16/5/9.
//  Copyright © 2016年 egg swift. All rights reserved.
//

import UIKit

public class WCRefreshHeaderAnimator: UIView, ESRefreshProtocol, ESRefreshAnimatorProtocol {
    public var insets: UIEdgeInsets = UIEdgeInsetsZero
    public var view: UIView { return self }
    public var trigger: CGFloat = 56.0
    public var executeIncremental: CGFloat = 0.0
    private var state: ESRefreshViewState = .PullToRefresh
    private var timer: NSTimer?
    private var timerProgress: Double = 0.0
    private let imageView: UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = UIImage.init(named: "icon_wechat")
        imageView.sizeToFit()
        let size = imageView.image?.size ?? CGSize.zero
        print(size.height)
        imageView.center = CGPoint.init(x: 22.0 + size.width / 2.0, y: -size.height)
        return imageView
    }()
    
    
    private let headerView: UIView = {
//        let imageView = UIImageView (frame: CGRectMake(0, 0, WIDTH, 60))
//        imageView.image = UIImage.init(named: "icon_wechat_header")
//        let size = imageView.image?.size ?? CGSize.zero
//        print(size.height)
//        imageView.center = CGPoint.init(x: 100.0, y: -size.height)
//        return imageView
        let view = UIView (frame: CGRectMake(0,0,WIDTH,63));
        let label = UILabel();
        label.frame = CGRectMake(0, 5, view.frame.size.width, view.frame.size.height/2);
        label.text = "Loading...";
        label.textAlignment = NSTextAlignment.Center;
        label.backgroundColor = UIColor.lightGrayColor();
        
        let subLabel = UILabel();
        subLabel.frame = CGRectMake(0, view.frame.size.height/2+5, view.frame.size.width, view.frame.size.height/2-5);
        subLabel.text = "雷哥带你装逼，带你飞";
        subLabel.textAlignment = NSTextAlignment.Center;
        subLabel.backgroundColor = UIColor.lightGrayColor();
        
        view.addSubview(label);
        view.addSubview(subLabel);
        return view;
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(headerView)
        self.addSubview(imageView)
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func refreshAnimationDidBegin(view: ESRefreshComponent) {
        self.startAnimating()
        UIView.animateWithDuration(0.2, delay: 0, options: .CurveLinear, animations: {
            let size = self.imageView.image?.size ?? CGSize.zero
            self.imageView.center = CGPoint.init(x: 22.0 + size.width / 2.0, y: 16.0 + size.height / 2.0)
            self.headerView.center = CGPoint.init(x: 160.0 , y: 16.0 + size.height / 2.0-5)
            }, completion: { (finished) in

        })
    }
    
    public func refreshAnimationDidEnd(view: ESRefreshComponent) {
        self.stopAnimating()
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: {
            let size = self.imageView.image?.size ?? CGSize.zero
            self.imageView.transform = CGAffineTransformIdentity
            self.imageView.center = CGPoint.init(x: 22.0 + size.width / 2.0, y: -size.height)
            self.headerView.center = CGPoint.init(x: 160.0, y:  -size.height-5)
            }, completion: { (finished) in
                
        })
    }
    
    public func refresh(view: ESRefreshComponent, progressDidChange progress: CGFloat) {
        let size = imageView.image?.size ?? CGSize.zero
        let p = min(1.0, max(0.0, progress))
        self.imageView.center = CGPoint.init(x: 22.0 + size.width / 2.0, y: -self.trigger * progress + 16.0 - (size.height + 16.0) * (1 - p) + size.height / 2.0)
        self.imageView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI) * progress)
    }
    
    public func refresh(view: ESRefreshComponent, stateDidChange state: ESRefreshViewState) {
        if self.state == state { return }
        self.state = state
    }

    func timerAction() {
        timerProgress += 0.01
        self.imageView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI) * CGFloat(timerProgress))
    }
    
    func startAnimating() {
        if timer == nil {
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(WCRefreshHeaderAnimator.timerAction), userInfo: nil, repeats: true)
            NSRunLoop.currentRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
        }
    }
    
    func stopAnimating() {
        if timer != nil {
            timerProgress = 0.0
            timer?.invalidate()
            timer = nil
        }
    }
    
}
