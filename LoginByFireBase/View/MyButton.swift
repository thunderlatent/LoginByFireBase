//
//  IBDesignableIBInspectable.swift
//  IBDesignableAndIBInspectable
//
//  Created by Jimmy on 2020/10/10.
//

import UIKit
//@IBDesignable
class MyButton: UIButton {
    @IBInspectable var 圓角大小: CGFloat = 0.0
    {
        didSet
        {
            //這個屬性在設定圓角的大小
            layer.cornerRadius = 圓角大小
            
            //這個屬性在決定是否要讓元件被裁切，如果這個屬性是false，則設置cornerRadius不會有效果
            layer.masksToBounds = (圓角大小 > 0)
        }
    }
    @IBInspectable var 邊框大小: CGFloat = 0.0
    {
        didSet
        {
            layer.borderWidth = 邊框大小
        }
    }
    
    @IBInspectable var 邊框顏色: UIColor = .black {
        didSet
        {
            layer.borderColor = 邊框顏色.cgColor
        }
    }
    
    @IBInspectable var 標題左邊插值: CGFloat = 0.0
    {
        didSet
        {
            titleEdgeInsets.left = 標題左邊插值
        }
    }
    
    @IBInspectable var 標題右邊插值: CGFloat = 0.0
    {
        didSet
        {
            titleEdgeInsets.right = 標題右邊插值
        }
    }
    
    @IBInspectable var 標題上邊插值: CGFloat = 0.0
    {
        didSet
        {
            titleEdgeInsets.top = 標題上邊插值
        }
    }
    
    @IBInspectable var 標題下邊插值: CGFloat = 0.0
    {
        didSet
        {
            titleEdgeInsets.bottom = 標題下邊插值
        }
    }
    
    @IBInspectable var 圖片左邊插值: CGFloat = 0.0
    {
        didSet
        {
            imageEdgeInsets.left = 圖片左邊插值
        }
    }
    
    @IBInspectable var 圖片右邊插值: CGFloat = 0.0
    {
        didSet
        {
            imageEdgeInsets.right = 圖片右邊插值
        }
    }
    
    @IBInspectable var 圖片上邊插值: CGFloat = 0.0
    {
        didSet
        {
            imageEdgeInsets.top = 圖片上邊插值
        }
    }
    
    @IBInspectable var 圖片下邊插值: CGFloat = 0.0
    {
        didSet
        {
            imageEdgeInsets.bottom = 圖片下邊插值
            
        }
    }
    
    
    
    @IBInspectable var 是否產生漸層: Bool = false
    @IBInspectable var 漸層開始顏色: UIColor = UIColor.black
    @IBInspectable var 漸層中間顏色: UIColor = UIColor.clear
    @IBInspectable var 漸層結束顏色: UIColor = UIColor.white
    
    
    
    func creatGradient()
    {
        if 是否產生漸層
        {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = self.bounds
            gradientLayer.colors = [漸層開始顏色.cgColor ,漸層中間顏色.cgColor, 漸層結束顏色.cgColor]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
            self.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        creatGradient()
        
        
    }
    
}


@IBDesignable class ResizeImage: UIButton
{
    
    @IBInspectable var topInsets: CGFloat = 0.0
    @IBInspectable var leftInsets: CGFloat = 0.0
    @IBInspectable var rightInsets: CGFloat = 0.0
    @IBInspectable var bottomInsets: CGFloat = 0.0
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        imageEdgeInsets = UIEdgeInsets(top: self.topInsets , left: self.leftInsets, bottom: self.bottomInsets, right: self.rightInsets)
    }
}

