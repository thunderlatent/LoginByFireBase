//
//  FeedTableViewcontroller+ImagePicker.swift
//  FirebaseDemo
//
//  Created by Jimmy on 2020/11/5.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import UIKit
import ImagePicker
//MARK: Extension ImagePickerDelegate

extension FeedTableViewController: ImagePickerDelegate
{
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage])
    {
        
        //拿到第一張照片
        guard let image = images.first else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        uploadImage(image: image) {
            self.dismiss(animated: true, completion: nil)
            self.loadRecentPosts()
        }
        
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
