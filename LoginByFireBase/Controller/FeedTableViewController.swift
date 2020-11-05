//
//  FeedTableViewController.swift
//  FirebaseDemo
//
//  Created by Simon Ng on 21/6/2017.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import ImagePicker
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class FeedTableViewController: UITableViewController,GetFirRef,LoadAnimationAble {
    //MARK: Properties
    var postFeed:[Post] = []
    
    fileprivate var isLoadingPost = false
    override func viewDidLoad() {
        super.viewDidLoad()
        startLoading(view)
        loadRecentPosts()
        refreshData()
    }
    //MARK: Custom Functions - Get Data From Firebase Database
    func getDatabaseData()
    {
        PostService.shared.getRecentPosts(limit: 5) { (newPosts) in
            print("資料總共有：",newPosts.count,"筆")
            newPosts.forEach({ (post) in
                print("-------")
                print("Post ID: \(post.postID)")
                print("Image URL: \(post.imageFileURL)")
                print("User: \(post.user)")
                print("Votes: \(post.votes)")
                print("Timestamp: \(post.timestamp)")
            })
        }
    }
    //MARK: Custom Functions - Get and show posts from Firebase
    @objc fileprivate func loadRecentPosts()
    {
        self.isLoadingPost = true
        //閉包內的newPosts就是從Firebase抓到的指定筆數的資料，並且由時間由大至小排列
        PostService.shared.getRecentPosts(start: postFeed.first?.timestamp, limit: 10) { (newPosts) in
            print(newPosts)
            if newPosts.count > 0
            {
                self.postFeed.insert(contentsOf: newPosts, at: 0)
//                self.displayNewPosts(newPosts: newPosts)

            }
            self.isLoadingPost = false
            if self.refreshControl?.isRefreshing == true
            {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    self.refreshControl?.endRefreshing()
                    self.displayNewPosts(newPosts: newPosts)
                    print("A")
                }
            }else
            {
                self.displayNewPosts(newPosts: newPosts)
                print("B")
            }
            
        }
    }
    
    private func displayNewPosts(newPosts posts:[Post])
    {
        guard posts.count > 0 else
        {
            let alertController = UIAlertController(title: "目前已是最新資料", message: "", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(OKAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        var indexPaths:[IndexPath] = []
        self.tableView.beginUpdates()
        for row in 0..<posts.count
        {
            let indexPath = IndexPath(row: row, section: 0)
            indexPaths.append(indexPath)
        }
//        self.stopLoading()
        self.tableView.insertRows(at: indexPaths, with: .fade)
        self.tableView.endUpdates()
    }
    
    func refreshData()
    {
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = .black
        refreshControl?.tintColor = .white
        refreshControl?.addTarget(self, action: #selector(loadRecentPosts), for: .valueChanged)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func openCamera(_ sender: UIBarButtonItem) {
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 1
        present(imagePickerController, animated: true, completion: nil)
    }
    
}
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
        PostService.shared.uploadImage(image: image) {
            self.dismiss(animated: true, completion: nil)
            self.loadRecentPosts()
        }
        
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}

//MARK: UITableViewDataSource
extension FeedTableViewController
{
  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postFeed.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostCell
        cell.configure(post: postFeed[indexPath.row])
        
        return cell
    }
}

//MARK: UITableViewDelegate
extension FeedTableViewController
{
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard !isLoadingPost, (postFeed.count - indexPath.row == 2) else {return}
        
        isLoadingPost = true
        
        
    }
}
