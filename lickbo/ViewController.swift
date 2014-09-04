//
//  ViewController.swift
//  lickbo
//
//  Created by Stephanie Emila on 2014-09-02.
//  Copyright (c) 2014 Stephanie Emila. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var products : NSArray = []
    var searchQuery : NSString = ""
    var tableView : UITableView?
    var searchField : UITextField?
    let lcboClient = LcboClient()
    
    func queryChanged(sender: UITextField!) {
        searchQuery = (searchField!.text as NSString)
        refresh()
    }
    
    // force a light status bar style
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    // only allow portrait orientation in this view
    override func shouldAutorotate() -> Bool  {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set background color
        view.backgroundColor = UIColor.grayColor()
        
        // create search field
        searchField = UITextField(frame: CGRectMake(10, 40, CGRectGetWidth(view.frame)-20, 30))
        searchField!.borderStyle = UITextBorderStyle.RoundedRect
        searchField!.keyboardType = UIKeyboardType.WebSearch
        searchField!.addTarget(self, action: "queryChanged:", forControlEvents: UIControlEvents.EditingChanged)
        view.addSubview(searchField!)
        
        
        // create table view for lcbo resultssty
        tableView = UITableView(frame:
            CGRectMake(
                0,
                CGRectGetMaxY(searchField!.frame) + 10,
                CGRectGetWidth(view.frame),
                CGRectGetHeight(view.frame) - CGRectGetMaxY(searchField!.frame) - 10
            )
        )
        tableView!.delegate = self
        tableView!.dataSource = self
        view.addSubview(tableView!)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refresh() {
        println(self.searchQuery)
        lcboClient.getProducts(self.searchQuery, completion: { (productsArray:NSArray!) in
            self.products = productsArray
            self.tableView!.reloadData()
        })
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = UITableViewCell(style: UITableViewCellStyle.Value2, reuseIdentifier: nil)
        cell.detailTextLabel.text = self.products[indexPath.row]["name"] as NSString
        return cell
    }
}

