//
//  ViewController.swift
//  DemoApp
//
//  Created by vivek bajirao deshmukh on 24/06/20.
//  Copyright © 2020 vivek bajirao deshmukh. All rights reserved.
//

import UIKit
import SDWebImage


class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var tableView = UITableView()
    var dataArray : NSArray = [] //Array of your data to be displayed
    var activityView: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpNavigation()
        tableView = UITableView(frame: self.view.bounds, style: UITableView.Style.plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.white
        // register your class with cell identifier
        self.tableView.register(myCell.self as AnyClass, forCellReuseIdentifier: "Cell")
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo:view.safeAreaLayoutGuide.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        self.apiCall()
        // Do any additional setup after loading the view.
    }
    
    func setUpNavigation() {
     self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.2431372549, green: 0.7647058824, blue: 0.8392156863, alpha: 1)
     self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor(red: 1, green: 1, blue: 1, alpha: 1)]
    }
    

    // MARK: - Tableview delegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // let myCell = tableView.dequeueReusableCellWithIdentifier("myIdentifier", forIndexPath: indexPath)
        var cell:myCell? = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? myCell
        if cell == nil {
            cell = myCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        }
        if let data = self.dataArray[indexPath.row] as? [String:AnyObject]{
            cell?.nameLabel.text = data["title"] as? String
            cell?.jobTitleDetailedLabel.text = data["description"] as? String
            cell?.profileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell?.profileImageView.sd_setImage(with: URL(string: data["imageHref"] as? String ?? ""), completed: nil)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 80
       }
    
    func apiCall(){
        let service = UserService()
        service.getFactslist( target: self, complition: { (response) in
            DispatchQueue.main.async {
                if let eventsData = response as? Dictionary<String,Any>{
                    self.dataArray = eventsData["rows"] as! NSArray
                    self.navigationItem.title = eventsData["title"] as? String
                }
                self.tableView.reloadData()
            }
        })
    }


}


class myCell: UITableViewCell {
       let containerView:UIView = {
           let view = UIView()
           view.translatesAutoresizingMaskIntoConstraints = false
           view.clipsToBounds = true // this will make sure its children do not go out of the boundary
           return view
       }()
       
       let profileImageView:UIImageView = {
           let img = UIImageView()
           img.contentMode = .scaleAspectFill // image will never be strecthed vertially or horizontally
           img.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
           img.layer.cornerRadius = 35
           img.clipsToBounds = true
           return img
       }()
       
       let nameLabel:UILabel = {
           let label = UILabel()
           label.font = UIFont.boldSystemFont(ofSize: 14)
           label.textColor = .black
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
       
       let jobTitleDetailedLabel:UILabel = {
           let label = UILabel()
           label.font = UIFont.boldSystemFont(ofSize: 10)
           label.textColor =  .darkGray
           label.numberOfLines = 5
           label.layer.cornerRadius = 5
           label.clipsToBounds = true
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
       
       

       override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
           super.init(style: style, reuseIdentifier: reuseIdentifier)
           
           self.contentView.addSubview(profileImageView)
           containerView.addSubview(nameLabel)
           containerView.addSubview(jobTitleDetailedLabel)
           self.contentView.addSubview(containerView)
           
           profileImageView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
           profileImageView.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor, constant:10).isActive = true
           profileImageView.widthAnchor.constraint(equalToConstant:70).isActive = true
           profileImageView.heightAnchor.constraint(equalToConstant:70).isActive = true
           
           containerView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
           containerView.leadingAnchor.constraint(equalTo:self.profileImageView.trailingAnchor, constant:10).isActive = true
           containerView.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant:-10).isActive = true
           containerView.heightAnchor.constraint(equalToConstant:40).isActive = true
           
           nameLabel.topAnchor.constraint(equalTo:self.containerView.topAnchor).isActive = true
           nameLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor).isActive = true
           nameLabel.trailingAnchor.constraint(equalTo:self.containerView.trailingAnchor).isActive = true
           
           jobTitleDetailedLabel.topAnchor.constraint(equalTo:self.nameLabel.bottomAnchor).isActive = true
           jobTitleDetailedLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor).isActive = true
           jobTitleDetailedLabel.topAnchor.constraint(equalTo:self.nameLabel.bottomAnchor).isActive = true
           jobTitleDetailedLabel.trailingAnchor.constraint(equalTo:self.containerView.trailingAnchor).isActive = true
       }
       
       required init?(coder aDecoder: NSCoder) {
           
           super.init(coder: aDecoder)
       }

}
