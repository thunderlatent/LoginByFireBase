//
//  PostCell.swift
//  FirebaseDemo
//
//  Created by Simon Ng on 21/6/2017.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell,LoadAnimationAble {
  
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var voteButton: LineButton! {
        didSet {
            voteButton.tintColor = .white
        }
    }
    @IBOutlet var photoImageView: UIImageView!
    {
        didSet
        {
            stopLoading()
        }
    }
   
    
    @IBOutlet var avatarImageView: UIImageView! {
        didSet {
            avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2
            avatarImageView.clipsToBounds = true
        }
    }
    
    private var currentPost: Post?

//MARK: Class Function
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func layoutSubviews() {
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
//MARK: Custom Function
    func configure(post: Post)
    {
        self.currentPost = post
        self.selectionStyle = .none
        nameLabel.text = post.user
        voteButton.setTitle("\(post.votes)", for: .normal)
        voteButton.tintColor = .white
 
        photoImageView.image = nil
        if let image = CacheManager.shared.getFromCache(key: post.imageFileURL) as? UIImage
        {
            photoImageView.image = image
        }else
        {
            if let url = URL(string: post.imageFileURL)
            {
               URLSession.shared.dataTask(with: url) { (data, _, error) in
                
                    if let error = error{
                        print("快取抓不到圖片，並且之後連網抓圖也抓不到，錯誤訊息： ", error.localizedDescription)
                        return
                    }
                    
                    guard let imageData = data else{
                        print("下載圖片任務後，從Data獲取資料失敗")
                        return
                        
                    }

                    guard let image = UIImage(data: imageData) else{
                        print("下載後獲得的Data轉型成image失敗")
                        return
                    }
                DispatchQueue.main.async {
                    if self.currentPost?.imageFileURL == post.imageFileURL
                    {

                        self.photoImageView.image = image
                    }
                }
                    
                    CacheManager.shared.saveIntoCache(object: image, key: post.imageFileURL)
                }.resume()
            }
        }
        
    }
    
}
