//
//  LoadAnimation.swift
//  FirebaseDemo
//
//  Created by Jimmy on 2020/10/29.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import UIKit
import Lottie
protocol LoadAnimationAble {
    func startLoading(_ view: UIView)
    func stopLoading()
}
//extension內的where Self意思是這個擴充只在UIViewController生效，若是其他類別遵從這個協議，則這個擴充無效
extension LoadAnimationAble
{
    func startLoading(_ view: UIView)
    {
        LoadAnimation.share.startLoading(view)
        
    }
    func stopLoading()
    {
        LoadAnimation.share.stopLoading()
    }
}
class LoadAnimation
{
     
    static let share = LoadAnimation()
    let animationView = AnimationView(name: "instagramLoading")
    let loadingLabel: UILabel =
        {
            let label = UILabel()
            label.font = UIFont.boldSystemFont(ofSize: 30)
            label.text = "Loading..."
            label.textColor = .white
            label.adjustsFontSizeToFitWidth = true
            return label
        }()
    func startLoading(_ view:UIView){
//        animationView.addSubview(loadingLabel)
        view.addSubview(animationView)
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        let frame = CGRect(x: width / 2, y: height / 2, width: width / 5, height: width / 5)
        animationView.frame = frame
        animationView.center = view.center
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFill
        animationView.animationSpeed = 1
        animationView.play()
        loadingLabel.frame.size = CGSize(width: animationView.bounds.width / 2, height: animationView.bounds.width / 4)
        loadingLabel.center.x = animationView.bounds.midX
        loadingLabel.center.y = animationView.bounds.height / 4
        
    }
     func stopLoading()
    {
        animationView.stop()
        animationView.removeFromSuperview()
        
    }
    deinit {
        print("身為一個動畫，我被釋放了")
    }
    
}

