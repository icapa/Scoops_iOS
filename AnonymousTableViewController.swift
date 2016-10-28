//
//  AnonymousTableViewController.swift
//  Scoop_iOS
//
//  Created by Iván Cayón Palacio on 26/10/16.
//  Copyright © 2016 icapa. All rights reserved.
//

import UIKit

class AnonymousTableViewController: UITableViewController {

    var model: [AuthorRecord]? = []
    var client : MSClient?

    //MARK: - Init
    init (_ client: MSClient){
        self.client = client
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        readAllPosts()
    }
   
    override func numberOfSections(in tableView: UITableView) -> Int {
        if (model?.isEmpty)!{
            return 0
        }
        return 1
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (model?.isEmpty)!{
            return 0
        }
        return (model?.count)!
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "PostCell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        
        if cell == nil{
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        }
        
        let item = model?[indexPath.row]
        
        cell?.textLabel?.text = (item?["title"] as! String)
        cell?.detailTextLabel?.text = (item?["author"] as! String)
        
        return cell!

    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = model?[indexPath.row]
        let detVC = AnonymousDetailViewController(client!, model: item!)
        self.navigationController?.pushViewController(detVC, animated: true)

    }
    
    //MARK: - API
    func readAllPosts(){
        client?.invokeAPI("readAllRecords", body: nil, httpMethod: "GET", parameters: nil, headers: nil, completion: { (data, response, error) in
            if let _ = error{
                print(error)
            }
            else{
                if !((self.model?.isEmpty)!){
                    self.model?.removeAll()
                }
                
                if let _ = data{
                    print(data)
                    let json = data as! [AuthorRecord]
                    
                    for item in json {
                        self.model?.append(item)
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                }
            }
        })

    }
}
