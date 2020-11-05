//
//  PostService.swift
//  FirebaseDemo
//
//  Created by Jimmy on 2020/11/3.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

protocol GetFirRef {
    func baseDbRef() -> DatabaseReference
    func postDbRef() -> DatabaseReference
    func photoStorageRef() -> StorageReference

}
extension GetFirRef
{
    func baseDbRef() -> DatabaseReference
    {
        return PostService.shared.baseDbRef()
    }
    
    func postDbRef() -> DatabaseReference
    {
        return PostService.shared.postDbRef()
    }
    
    func photoStorageRef() -> StorageReference
    {
        return PostService.shared.photoStorageRef()
    }
    
}

class PostService{
    private init(){}
    static let shared = PostService()
    func baseDbRef() -> DatabaseReference
    {
        return Database.database().reference()
    }
    
    func postDbRef() -> DatabaseReference
    {
       return Database.database().reference().child("posts")
    }
    
    func photoStorageRef() -> StorageReference
    {
        return Storage.storage().reference().child("photos")
    }
    func uploadImage(image: UIImage, completion:@escaping () -> Void)
    {
        let postDatabaseRef = postDbRef().childByAutoId()
        let imageStorageRef = photoStorageRef().child("\(postDatabaseRef.key).jpg")
        let scaleImage = image.scale(newWidth: 640)
        guard let imageData = scaleImage.jpegData(compressionQuality: 0.9) else {return}
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        let uploadTask = imageStorageRef.putData(imageData, metadata: metaData)
        
        uploadTask.observe(.success) { (shapshot) in
            
            guard let displayName = Auth.auth().currentUser?.displayName else{return}
            
            
            imageStorageRef.downloadURL { (url, error) in
                if let error = error
                {
                    print("獲取圖片下載網址出現錯誤： ",error.localizedDescription)
                }
                if let imageFileURL = url?.absoluteString
                {
                    let timestamp = Int(NSDate().timeIntervalSince1970)
                    let post: [String: Any] = [PostInfoKey.imageFileURL.rawValue: imageFileURL,
                                               PostInfoKey.user.rawValue: displayName,
                                               PostInfoKey.votes.rawValue: Int(0),
                                               PostInfoKey.timestamp.rawValue:timestamp]
                    postDatabaseRef.setValue(post)
                }
               completion()
            }
        }
        uploadTask.observe(.progress) { (snapshot) in
            let percentComplete = (Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)) * 100.00
            let percentStr = String(format: "%.2f", percentComplete)
            print("現在上傳進度\(percentStr)%")
        }
        uploadTask.observe(.failure) { (snapshot) in
            if let error = snapshot.error
            {
                print("上傳照片失敗，錯誤訊息： ", error.localizedDescription)
            }
        }
    }
    
    func getRecentPosts(start timestamp: Int? = nil, limit: UInt, completion: @escaping([Post]) -> Void)
    {
        //使用postDbRef路徑下的timestamp來做排序＝Database/posts/
        var postQuery = postDbRef().queryOrdered(byChild: PostInfoKey.timestamp.rawValue)
        
        //獲取最新的時戳
        if let lastPostTimestamp = timestamp, lastPostTimestamp > 0
        {
            //從最新的時戳開始抓資料，並且抓limit筆
            postQuery = postQuery.queryStarting(atValue: lastPostTimestamp + 1, childKey: PostInfoKey.timestamp.rawValue).queryLimited(toLast: limit)
            
        }else
        {
            //如果沒有指定特定時戳，則預設從最新的開始抓，所以只要寫limit筆數就好
            postQuery = postQuery.queryLimited(toLast: limit)
        }
        
        //觀察postQuery，如果資料有改變，就會觸發這個方法，snapshot則儲存了資料
        postQuery.observeSingleEvent(of: .value) { (snapshot) in
            var newPosts: [Post] = []
            
            //撈Database/Posts/的所有物件
            for item in (snapshot.children.allObjects as! [DataSnapshot])
            {
                //儲存每一筆物件的資料
                let postInfo = item.value as? [String:Any] ?? [:]
                
                //確定能得到每筆物件的資料
                if let post =  Post(postID: item.key, postInfo: postInfo)
                {
                    newPosts.append(post)
                }
                if newPosts.count > 0
                {
                    newPosts.sort {
                        $0.timestamp > $1.timestamp
                    }
                }
            }
            //把資料陣列丟到逃逸閉包內
            completion(newPosts)
        }
    }
    
    
    func getOldPosts(start timestamp: Int, limit: UInt, completion: @escaping ([Post]) -> Void)
    {
        let postOrderQuery = postDbRef().child(PostInfoKey.timestamp.rawValue)
        let postLimitQuery = postOrderQuery.queryEnding(atValue: timestamp - 1, childKey: PostInfoKey.timestamp.rawValue).queryLimited(toLast: limit)
        
        postLimitQuery.observeSingleEvent(of: .value) { (snapshot) in
            var newPosts: [Post] = []
            for item in snapshot.children.allObjects as! [DataSnapshot]
            {
                let postInfo = item.value as? [String : Any] ?? [:]
                if let post = Post(postID: item.key, postInfo: postInfo)
                {
                    newPosts.append(post)
                }
                
            }
            
            newPosts.sort
            {
                $0.timestamp > $1.timestamp
            }
            
            completion(newPosts)
        }
    }
}

