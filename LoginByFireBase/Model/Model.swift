//
//  Model.swift
//  FirebaseDemo
//
//  Created by Jimmy on 2020/11/2.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import Foundation
struct Post
{
    //MARK: 屬性
    var postID: String
    var imageFileURL: String
    var user: String
    var votes: Int
    var timestamp: Int
    
    //MARK: 初始化器
    init(postID:String, imageFileURL: String, user:String, votes:Int, timestamp: Int = Int(NSDate().timeIntervalSince1970)) {
        self.postID = postID
        self.imageFileURL = imageFileURL
        self.user = user
        self.votes = votes
        self.timestamp = timestamp
    }
    
    init?(postID: String, postInfo: [String:Any])
    {
        guard let imageFileURL = postInfo[PostInfoKey.imageFileURL.rawValue] as? String,
              let user = postInfo[PostInfoKey.user.rawValue] as? String,
              let votes = postInfo[PostInfoKey.votes.rawValue] as? Int ,
              let timestamp = postInfo[PostInfoKey.timestamp.rawValue] as? Int else {return nil}
        
        self = Post(postID: postID, imageFileURL: imageFileURL, user: user, votes: votes, timestamp: timestamp)
    }
    
}
enum PostInfoKey: String {
    case imageFileURL,user,votes,timestamp
  
}
