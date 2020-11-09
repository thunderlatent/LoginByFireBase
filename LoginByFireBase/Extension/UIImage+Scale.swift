//
//  UIImage+Scale.swift
//  FirebaseDemo
//
//  Created by Jimmy on 2020/10/30.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import UIKit
extension UIImage
{
    func scale(newWidth: CGFloat) -> UIImage
    {
        guard self.size.width != newWidth else{return self}
        print("原本圖片大小為",self.size)
        let scaleFactor = newWidth / self.size.width
        
        let newHeight = self.size.height * scaleFactor
        let newSize = CGSize(width: newWidth, height: newHeight)
        
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        
        print("更改後的圖片大小為：",newImage?.size)
        return newImage ?? self
    }
}
