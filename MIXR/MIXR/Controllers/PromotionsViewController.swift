//
//  PromotionsViewController.swift
//  MIXR
//
//  Created by Michael Ciesielka on 8/22/16.
//  Copyright © 2016 MIXR LLC. All rights reserved.
//

import UIKit

struct PromotionModel {
    let status: String
    let timestamp: NSTimeInterval
    
    init(object: [String: String]) {
        status = object["promoters"] ?? ""
        if let hrString = object["userHr"],
            let intHr = Int(hrString) {
            timestamp = NSTimeInterval(intHr)
        } else {
            timestamp = NSDate().timeIntervalSince1970 - 60*3
        }
    }
}

class PromotionsViewController: BaseViewController {
    
    private struct Constants {
        static let PromotionTableViewCellIdentifier = "promotionTableViewCell"
    }

    @IBOutlet weak var promotionsHeaderView: UIView?
    @IBOutlet weak var promotionsTitleLabel: UILabel?
    @IBOutlet weak var tableView: UITableView?
    
    private var refreshControl = UIRefreshControl()
    
    private var promotionsDataSource = [PromotionModel]()
    
    override func viewDidLoad() {
        tableView?.delegate = self
        tableView?.dataSource = self
        
        promotionsHeaderView?.layer.borderWidth = 2.0
        promotionsHeaderView?.layer.cornerRadius = 5.0
        promotionsHeaderView?.layer.borderColor = UIColor.mixrGreen().CGColor
        
        promotionsTitleLabel?.font = UIFont.regularFontWithSize(24)
        
        refreshControl.addTarget(self, action: #selector(reloadData), forControlEvents: UIControlEvents.ValueChanged)
        tableView?.addSubview(refreshControl)
        
        reloadData()
    }
    
    @objc private func reloadData() {
        
        refreshControl.beginRefreshing()
        
        var promotersArray: [[String: String]] = []
        var dataSource = [PromotionModel]()
        
        promotersArray.append(["promoters":"Spanky's coupon valid until 1/2/2016","userHr":""])
        promotersArray.append(["promoters":"Jennifer's coupon valid until 2/2/2016","userHr":""])
        promotersArray.append(["promoters":"James Huccane's coupon valid until 4/2/2016","userHr":""])
        promotersArray.append(["promoters":"George Stapheny's coupon valid until 5/2/2016","userHr":""])
        promotersArray.append(["promoters":"Simon Hughs's coupon valid until 6/2/2016","userHr":""])
        promotersArray.append(["promoters":"Leon Smith's coupon valid until 7/2/2016","userHr":""])
        promotersArray.append(["promoters":"Heman Hasstle's coupon valid until 7/2/2016","userHr":""])
        promotersArray.append(["promoters":"Mawra Samuaels's coupon valid until 10/2/2016","userHr":""])
        promotersArray.append(["promoters":"Carl Stuart's coupon valid until 12/2/2016","userHr":""])
        promotersArray.append(["promoters":"Mark Houser's coupon valid until 13/2/2016","userHr":""])
        
        var indexPaths = [NSIndexPath]()
        for i in 0..<promotersArray.count {
            let promoter = promotersArray[i]
            dataSource.append(PromotionModel(object: promoter))
            indexPaths.append(NSIndexPath(forRow: i, inSection: 0))
        }
        
        var deleteIndexPaths = [NSIndexPath]()
        for i in 0..<promotionsDataSource.count {
            deleteIndexPaths.append(NSIndexPath(forRow: i, inSection: 0))
        }
        
        refreshControl.endRefreshing()
        promotionsDataSource = dataSource
        tableView?.beginUpdates()
        tableView?.deleteRowsAtIndexPaths(deleteIndexPaths, withRowAnimation: .Fade)
        tableView?.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Fade)
        tableView?.endUpdates()
    }
}

extension PromotionsViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return promotionsDataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier(Constants.PromotionTableViewCellIdentifier, forIndexPath: indexPath) as? PromotionTableViewCell {
            let model = promotionsDataSource[indexPath.row]
            cell.status = model.status
            cell.timestamp = model.timestamp
            
            return cell
        }
        
        return UITableViewCell()
    }
}

extension PromotionsViewController: UITableViewDelegate {
    
}
