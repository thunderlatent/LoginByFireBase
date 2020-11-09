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
        //取得在Database的參照路徑
        let postDatabaseRef = postDbRef().childByAutoId()
        
        //取得在Storage的參照路徑
        let imageStorageRef = photoStorageRef().child("\(postDatabaseRef.key).jpg")
        let scaleImage = image.scale(newWidth: 640)
        //將image轉成Data格式，因為Storage不支援UIImage格式，因此轉成Data
        guard let imageData = scaleImage.jpegData(compressionQuality: 0.9) else {return}
        
        //上傳照片時需要附加額外資訊，例如內容的格式，因此這邊實例化一個StorageMetadata來附加資訊
        let metaData = StorageMetadata()
        
        //將metaData內容設定為jpg圖片檔
        metaData.contentType = "image/jpg"
    
        //實例化一個上傳任務
        let uploadTask = imageStorageRef.putData(imageData, metadata: metaData)
        
        //在上傳任務增加成功事件觀察者，成功後通知觀察者，也就是呼叫這個方法，並且會將成功後所附帶的資訊丟給snapshot，可以從snapshot取得一些成功事件的資訊
        uploadTask.observe(.success) { (snapshot) in
            
            //取得使用者名稱
            guard let displayName = Auth.auth().currentUser?.displayName else{return}
            
            //上傳成功後，取得Storage參照路徑的圖片下載網址
            imageStorageRef.downloadURL { (url, error) in
                //error時則進入下方block
                if let error = error
                {
                    print("獲取圖片下載網址出現錯誤： ",error.localizedDescription)
                }
                
                //成功後將URL轉型成String，然後將String儲存進Post
                if let imageFileURL = url?.absoluteString
                {
                    //取得現在時戳，
                    let timestamp = Int(NSDate().timeIntervalSince1970)
                    
                    //將下載網址、使用者名稱、按讚數（未新增的功能）、時戳（這個功能是要做排列使用，我要讓新的文章顯示在最上層）
                    let post: [String: Any] = [PostInfoKey.imageFileURL.rawValue: imageFileURL,
                                               PostInfoKey.user.rawValue: displayName,
                                               PostInfoKey.votes.rawValue: Int(0),
                                               PostInfoKey.timestamp.rawValue:timestamp]
                    //呼叫DatabaseReference.setValue(_:)方法，將資料存進Database的參照路徑
                    postDatabaseRef.setValue(post)
                }
                
                //呼叫uploadImage(image:completion:)方法的地方，可以自定義一段閉包執行，這邊之所以留這個閉包，是要讓呼叫的人到時候上傳完畢後，可以進行dismiss(animated:completion:)行為
               completion()
            }
        }
        
        //這邊跟剛剛的成功事件觀察者類似，不過這邊觀察的則是進度事件，可以利用此觀察方法取的進度
        uploadTask.observe(.progress) { (snapshot) in
            
            //將目前執行的任務單元數除以執行任務的總單元數，就可以得到目前進度的百分比
            let percentComplete = (Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)) * 100.00
            
            //由於我只需要到小數點後兩位，因此針對percentComplete轉型成字串到小數點後兩位
            let percentStr = String(format: "%.2f", percentComplete)
            print("現在上傳進度\(percentStr)%")
        }
        
        //添加失敗事件的觀察者
        uploadTask.observe(.failure) { (snapshot) in
            //如果發生錯誤，則進入下方block
            if let error = snapshot.error
            {
                print("上傳照片失敗，錯誤訊息： ", error.localizedDescription)
            }
        }
    }
    
    
    func getNewerPosts(start timestamp: Int?, limit: UInt, completion: @escaping([Post]) -> Void)
    {
        //使用postDbRef路徑下的timestamp來做排序＝Database/posts/
        var postQuery = postDbRef().queryOrdered(byChild: PostInfoKey.timestamp.rawValue)
        
        //獲取最新的時戳
        if let newestPostTimestamp = timestamp, newestPostTimestamp > 0
        {
            //從最新的時戳開始抓資料，並且抓limit筆
            postQuery = postQuery.queryStarting(atValue: newestPostTimestamp + 1, childKey: PostInfoKey.timestamp.rawValue).queryLimited(toLast: limit)
            
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
    
    
    func getOlderPosts(start timestamp: Int, limit: UInt, completion: @escaping ([Post]) -> Void)
    {
        //設定按照timestamp來排序
        let postOrderQuery = postDbRef().queryOrdered(byChild: PostInfoKey.timestamp.rawValue)
        
        //排序的點在timestamp-1，並且排序limit筆，如果limit是5，則queryEnging會排序從timestamp-1開始，比這個時間小的五筆資料
        let postLimitQuery = postOrderQuery.queryEnding(atValue: timestamp - 1, childKey: PostInfoKey.timestamp.rawValue).queryLimited(toLast: limit)
        postLimitQuery.observeSingleEvent(of: .value) { (snapshot) in
            var newPosts: [Post] = []
            for item in (snapshot.children.allObjects as! [DataSnapshot])
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



