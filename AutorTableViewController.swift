//
//  AutorTableViewController.swift
//  Scoop_iOS
//
//  Created by Iván Cayón Palacio on 26/10/16.
//  Copyright © 2016 icapa. All rights reserved.
//

import UIKit






class AutorTableViewController: UITableViewController {

    
    var model: [AuthorRecord]? = []
    
    
    var client : MSClient?
    var segment : UISegmentedControl?
    
    
    //MARK: - Init
    init (_ client: MSClient){
        self.client = client
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        
        //addFakePost()
        //addPosts()
        readAuthorsTable(nil)
        
        super.viewWillAppear(true)
        segment  = UISegmentedControl(items: ["All","Published","Not Published"])
        segment?.sizeToFit()
        segment?.selectedSegmentIndex = 0;
        self.navigationItem.titleView = segment
        segment?.addTarget(self, action: #selector (segmentedControlValueChanged), for:.valueChanged)
        
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPost))
        
    }

    
    //MARK: - Actions
    
    func segmentedControlValueChanged(sender: AnyObject){
        let segment = sender as! UISegmentedControl
        print("Seleccionado: \(segment.selectedSegmentIndex)")
        switch segment.selectedSegmentIndex {
        case 0:
            print("All")
            readAuthorsTable(nil)
            break;
        case 1:
            print("Published")
            readAuthorsTable(true)
            break;
        default:
            print("Not published")
            readAuthorsTable(false)
            break;
            
        }
    }
    func addPost(sender: AnyObject){
        // Creamos un modelo vacío que valga
        let fakeModel : AuthorRecord =
            ["title":"" as AnyObject,
             "author":"" as AnyObject,
             "published":false as AnyObject,
             "wantPublish":false as AnyObject,
             "text":"" as AnyObject]
        
        
        let detailVC = AuthorViewController(client!, model: fakeModel)
        self.navigationController?.pushViewController(detailVC, animated: true)
        
        
    }
    
    
   
    // MARK: - Table view data source

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
        let detVC = AuthorViewController(client!, model: item!)
        self.navigationController?.pushViewController(detVC, animated: true)
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    //MARK: - BBDD functions
    func readAuthorsTable(_ published: Bool?){
        var query : Dictionary<String,String>?
        
        if (published != nil){
            if published==true{
                query = ["publish": "true"]
            }
            else{
                query = ["publish" : "false"]
            }
            
        }else{
            query = nil
        }
        
        client?.invokeAPI("authorposts", body: nil, httpMethod: "GET", parameters: query, headers: nil, completion: { (data, response, error) in
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
    
    /*
    //MARK: - Help functions
    func addPosts(){
        let json: Dictionary<String,String> = ["author":"ivan","title":"titulo","text":"texto"]
        
        
        client?.invokeAPI("add",
                          body: nil,
                          httpMethod: "POST",
                          parameters: json,
                          headers: nil,
                          completion: { (data, response, error) in
            if let _ = error{
                print(error)
                
            }else{
                print(response)
            }
        })
    
        
    }
     */
}
