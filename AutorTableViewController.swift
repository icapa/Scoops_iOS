//
//  AutorTableViewController.swift
//  Scoop_iOS
//
//  Created by Iván Cayón Palacio on 26/10/16.
//  Copyright © 2016 icapa. All rights reserved.
//

import UIKit




class AutorTableViewController: UITableViewController {

    
    var model : [Post]?
    
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
        addPosts()
        
        
        super.viewWillAppear(true)
        segment  = UISegmentedControl(items: ["All","Published","Not Published"])
        segment?.sizeToFit()
        segment?.selectedSegmentIndex = 0;
        self.navigationItem.titleView = segment
        segment?.addTarget(self, action: #selector (segmentedControlValueChanged), for:.valueChanged)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    
    //MARK: - Actions
    func segmentedControlValueChanged(sender: AnyObject){
        let segment = sender as! UISegmentedControl
        print("Seleccionado: \(segment.selectedSegmentIndex)")
    }
    
    
    
   
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

    //MARK: - Help functions
    func addPosts(){
        /*
        let test = Post(_let: "titulo", text: "texto", photo: "photo", latitude: 0.0, longitude: 0.0, author: "autor", published: false, rate: 0.0, wantPublish: false, containerName: "containername", numberRates: 0)
        */
        
        let jsonItem = [["author": "ivan"],
                        ["title":"titulo"],
                        ["text":"texto"]]
        
        
        client?.invokeAPI("add", body: jsonItem, httpMethod: "POST", parameters: nil, headers: nil, completion: { (data, response, error) in
            if let _ = error{
                print(error)
                
            }else{
                print(response)
            }
        })
    
        
    }
    
    //MARK: - Fake post
    func addFakePost() {
        
        let tableMS = client?.table(withName: "Posts")
        
        tableMS?.insert(["title" : "titulo",
                        "text" : "texto",
                        "photo" : "foto",
                        "latitude" : 0.0,
                        "longitude" : 1.1,
                        "author" : "ivan",
                        "published" : false,
                        "rate" : 2.2,
                        "wantPublish" : false,
                        "container" : "container",
                        "numberRates" : 0
            ])
        { (result, error) in
            
            if let _ = error {
                print(error)
                return
            }
            //            self.readAllItemsInTable()
            print(result)
        }
    }
    
}
