//
//  PostService+PostServiceAble.swift
//  FirebaseDemo
//
//  Created by Jimmy on 2020/11/5.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import UIKit
protocol PostServiceAble {
    func uploadImage(image: UIImage, completion:@escaping () -> Void)
    func getNewerPosts(start timestamp: Int?, limit: UInt, completion: @escaping([Post]) -> Void)
    func getOlderPosts(start timestamp: Int, limit: UInt, completion: @escaping ([Post]) -> Void)
}
extension PostServiceAble
{
    func uploadImage(image: UIImage, completion:@escaping () -> Void)
    {
        PostService.shared.uploadImage(image: image, completion: completion)
    }
    func getNewerPosts(start timestamp: Int?, limit: UInt, completion: @escaping([Post]) -> Void)
    {
        PostService.shared.getNewerPosts(start: timestamp, limit: limit, completion: completion)
    }
    func getOlderPosts(start timestamp: Int, limit: UInt, completion: @escaping ([Post]) -> Void)
    {
        PostService.shared.getOlderPosts(start: timestamp, limit: limit, completion: completion)
    }
}
