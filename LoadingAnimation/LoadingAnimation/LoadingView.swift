//
//  LoadingView.swift
//  LoadingAnimation
//
//  Created by huangbaoyu on 16/9/27.
//  Copyright © 2016年 chachong. All rights reserved.
//

import UIKit

class LoadingView: UIView,CAAnimationDelegate {
    
    var round1Color = UIColor.init(red: 206/255.0, green: 7/255.0, blue: 85/255.0, alpha: 1)
    var round2Color = UIColor.init(red: 206/255.0, green: 7/255.0, blue: 85/255.0, alpha: 0.6)
    var round3Color = UIColor.init(red: 206/255.0, green: 7/255.0, blue: 85/255.0, alpha: 0.3)

    
    let animTime = 1.5
    let animRepeatTime:Float = 50
    
    var round1:UIView!
    var round2:UIView!
    var round3:UIView!
    

    //显示加载动画在指定的view上
    class func showLoadingWith(view:UIView)->LoadingView
    {
        let loadingView = LoadingView.init(frame: CGRect.init(x: 0, y: 0, width: view.width, height: view.height))
        view.addSubview(loadingView)
    
        return loadingView
    }
    
    //显示加载动画在指定的window上
    class func showLoadingWithWindow()->LoadingView
    {
        let lastWindow = UIApplication.shared.windows.last
        
        let loadingView = LoadingView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        lastWindow?.addSubview(loadingView)
        
        return loadingView
        
    }
    
    
    
    //可以手动调用隐藏动画
    func hideLoadingView()
    {
        
        round1.layer.removeAllAnimations()
        round2.layer.removeAllAnimations()
        round3.layer.removeAllAnimations()
        self.removeFromSuperview()
    }
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        let round1 = UIView.init()
        round1.width = 10
        round1.height = 10
        round1.layer.cornerRadius = round1.height/2
        round1.backgroundColor = round1Color
        self.round1 = round1

        let round2 = UIView.init()
        round2.width = 10
        round2.height = 10
        round2.backgroundColor = round2Color
        round2.layer.cornerRadius = round2.height/2
        self.round2 = round2
        
        let round3 = UIView.init()
        self.round3 = round3
        round3.width = 10
        round3.height = 10
        round3.backgroundColor = round3Color
        round3.layer.cornerRadius = round3.height/2

        self.addSubview(round1)
        self.addSubview(round2)
        self.addSubview(round3)
        
        round2.centerX = self.centerX
        round2.centerY = self.centerY - self.width/10
        
        round1.centerX = round2.centerX - 20
        round1.centerY = round2.centerY
        
        round3.centerX = round2.centerX + 20
        round3.centerY = round2.centerY
        
        startAnim()
        
    }
    
    func startAnim()
    {
        let otherRoundCenter1 = CGPoint.init(x: round1.centerX+10, y: round2.centerY)
        
        let otherRoundCenter2 = CGPoint.init(x: round2.centerX+10, y: round2.centerY)
        
        //圆1的路径
        let path1 = UIBezierPath.init()
        path1.addArc(withCenter: otherRoundCenter1, radius: 10, startAngle: -CGFloat(M_PI), endAngle: 0, clockwise: true)
        
        let path1_1 = UIBezierPath.init()
        path1_1.addArc(withCenter: otherRoundCenter2, radius: 10, startAngle: -CGFloat(M_PI), endAngle: 0, clockwise: false)
        path1.append(path1_1)

        viewMovePathAnim(view: round1, path: path1, time: animTime)
        
        //添加round1的颜色效果
        viewColorAnim(view: round1, fromColor: round1Color, toColor: round3Color, time: animTime)

        //添加round2的轨迹
        let path2 = UIBezierPath.init()
        path2.addArc(withCenter: otherRoundCenter1, radius: 10, startAngle: 0, endAngle: -(CGFloat(M_PI)), clockwise: true)
        //添加round2的轨迹动画
        viewMovePathAnim(view: round2, path: path2, time: animTime)
        
        //圆2的颜色渐变
        viewColorAnim(view: round2, fromColor: round2Color, toColor: round1Color, time: animTime)
        
        
        //圆3的路径
        let path3 = UIBezierPath.init()
        
        path3.addArc(withCenter: otherRoundCenter2, radius: 10, startAngle: 0, endAngle: -CGFloat(M_PI), clockwise: false)
        //轨迹动画
        viewMovePathAnim(view: round3, path: path3, time: animTime)
        //颜色动画
        viewColorAnim(view: round3, fromColor: round3Color, toColor: round2Color, time: animTime)

        
    }
    
    ///设置view的移动路线，这样抽出来因为每个圆的只有路径不一样
    func viewMovePathAnim(view:UIView,path:UIBezierPath,time:Double)
    {
        let anim = CAKeyframeAnimation.init(keyPath: "position")
        anim.path = path.cgPath
        anim.isRemovedOnCompletion = false
        anim.fillMode = kCAFillModeForwards
        anim.calculationMode = kCAAnimationCubic
        anim.repeatCount = animRepeatTime
        
        anim.duration = animTime
        anim.delegate = self
        anim.autoreverses = false
        
        anim.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
        view.layer.add(anim, forKey: "animation")
    }
    
    ///设置view的颜色动画
    func viewColorAnim(view:UIView,fromColor:UIColor,toColor:UIColor,time:Double)
    {
        let colorAnim = CABasicAnimation.init(keyPath: "backgroundColor")
        colorAnim.toValue = toColor.cgColor
        colorAnim.fromValue = fromColor.cgColor
        colorAnim.duration = time
        colorAnim.autoreverses = false
        colorAnim.fillMode = kCAFillModeForwards;
        colorAnim.isRemovedOnCompletion = false;
        colorAnim.repeatCount = animRepeatTime
        
        view.layer.add(colorAnim, forKey: "backgroundColor")
    }
    
  
   
    override func layoutSubviews() {
        super.layoutSubviews()
        round2.centerX = self.centerX
        round2.centerY = self.centerY
        
        round1.centerX = round2.centerX - 20
        round1.centerY = round2.centerY
        
        round3.centerX = round2.centerX + 20
        round3.centerY = round2.centerY
    }

    
    ///动画停止
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        round1.layer.removeAllAnimations()
        round2.layer.removeAllAnimations()
        round3.layer.removeAllAnimations()
        //直接销毁
        self.removeFromSuperview()
        
    }
    
    deinit {
        print("销毁了")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
