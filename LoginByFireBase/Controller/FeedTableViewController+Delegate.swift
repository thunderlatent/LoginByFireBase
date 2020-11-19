//
//  FeedTableViewController+Delegate.swift
//  FirebaseDemo
//
//  Created by Jimmy on 2020/11/5.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import UIKit
//MARK: UITableViewDelegate
extension FeedTableViewController
{
    //Infinite rolling
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //滑到最下面兩個cell時觸發
        guard !isLoadingPost, (postFeed.count - indexPath.row == 2) else {return}
        
        isLoadingPost = true
        
        guard let timestamp = postFeed.last?.timestamp else
        {
                isLoadingPost = false
            return
        }
        
        getOlderPosts(start: timestamp, limit: 5) { (newPosts) in
            var indexPaths: [IndexPath] = []
            self.tableView.beginUpdates()
                for newPost in newPosts
                {
                    self.postFeed.append(newPost)
                    let index = IndexPath(row: self.postFeed.count - 1, section: 0)
                    indexPaths.append(index)
                    
                }
            tableView.insertRows(at: indexPaths, with: .fade)
            self.tableView.endUpdates()
            self.isLoadingPost = false
        }
        
        
    }
}
