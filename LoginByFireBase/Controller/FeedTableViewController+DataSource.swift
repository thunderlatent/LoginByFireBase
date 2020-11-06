//
//  FeedTableViewController+DataSource.swift
//  FirebaseDemo
//
//  Created by Jimmy on 2020/11/5.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import UIKit
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
