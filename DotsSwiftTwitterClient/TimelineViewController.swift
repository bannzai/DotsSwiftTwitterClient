//
//  ViewController.swift
//  DotsSwiftTwitterClient
//
//  Created by 田中賢治 on 2017/02/14.
//  Copyright © 2017年 田中賢治. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl(frame: CGRect.zero)
        refreshControl.addTarget(self, action: #selector(TimelineViewController.refresh(for :)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        LoginCommunicator().login() { isSuccess in
            switch isSuccess {
            case false:
                print("ログイン失敗")
            case true:
                print("ログイン成功")
                
                TwitterCommunicator().getTimeline() { [weak self] data, error in
                    
                    if let error = error {
                        print(error)
                        return
                    }
                    
                    let timelineParser = TimelineParser()
                    let tweets = timelineParser.parse(data: data!)
                    self?.tweets = tweets
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.tableView.reloadData()
                    }
                }
            }
        }
    }
   
    func refresh(for refreshControl: UIRefreshControl) {
        print("refreshed")
        refreshControl.endRefreshing()
    }
}

extension TimelineViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}

extension TimelineViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineTableViewCell") as! TimelineTableViewCell
        
        cell.fill(tweet: tweets[indexPath.row])
        
        return cell
    }
    
}

