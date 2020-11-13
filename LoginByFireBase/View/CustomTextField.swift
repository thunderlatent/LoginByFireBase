//
//  UITextFieldPadding.swift
//  SnapKitDemo
//
//  Created by Jimmy on 2020/11/11.
//

import UIKit

class CustomTextField: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTF()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    //MARK: Custom Function
    func setupTF()
    {
        self.backgroundColor = .systemGray6
        self.layer.borderColor = UIColor.systemGray4.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
    }
    
    
   
}
