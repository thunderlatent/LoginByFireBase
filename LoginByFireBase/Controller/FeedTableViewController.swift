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

class FeedTableViewController: UITableViewController,PostServiceAble,GetFirRef,LoadAnimationAble {
    //MARK: Properties
    var postFeed:[Post] = []
    
    var isLoadingPost = false
    override func viewDidLoad() {
        super.viewDidLoad()
        startLoading(view)
        loadRecentPosts()
        refreshData()
    }
    
    //MARK: Custom Functions - Get and show posts from Firebase
    @objc func loadRecentPosts()
    {
        self.isLoadingPost = true
        //閉包內的newPosts就是從Firebase抓到的指定筆數的資料，並且由時間由大至小排列
        
        getNewerPosts(start: postFeed.first?.timestamp, limit: 10) { (newPosts) in
            if newPosts.count > 0
            {
                self.postFeed.insert(contentsOf: newPosts, at: 0)
            }
            self.isLoadingPost = false
            if self.refreshControl?.isRefreshing == true
            {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    self.refreshControl?.endRefreshing()
                    self.displayNewPosts(newPosts: newPosts)
                }
            }else
            {
                self.displayNewPosts(newPosts: newPosts)
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
    }
    
    @IBAction func openCamera(_ sender: UIBarButtonItem) {
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 1
        present(imagePickerController, animated: true, completion: nil)
    }
    
}





