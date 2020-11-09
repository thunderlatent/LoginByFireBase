//
//  UIViewController+UIAlertController.swift
//  FirebaseDemo
//
//  Created by Jimmy on 2020/11/9.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import UIKit
extension UIViewController
{
    func popAlertController(title: String, message: String, style: UIAlertController.Style = .alert, actionTitle: String, actionStyle: UIAlertAction.Style = .default, handler: ((UIAlertAction) -> Void)? = nil, animated: Bool? = true, completion: (() -> Void)? = nil)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let alertAction = UIAlertAction(title: actionTitle, style: actionStyle, handler: handler)
        alertController.addAction(alertAction)
        present(alertController, animated: animated!, completion: completion)
        
    }
    
}
