//
//  AuthorViewController.swift
//  Scoop_iOS
//
//  Created by Iván Cayón Palacio on 26/10/16.
//  Copyright © 2016 icapa. All rights reserved.
//

import UIKit

typealias AuthorRecord = Dictionary<String,AnyObject>


class AuthorViewController: UIViewController {

    var client : MSClient
    var model : AuthorRecord?
    @IBOutlet weak var viewPostAuthor: UITextField!
    
    @IBOutlet weak var viewPostTitle: UITextField!
    
    @IBOutlet weak var viewPostGeo: UITextField!
    @IBOutlet weak var viewPostText: UITextView!
    
    
    @IBOutlet weak var publishButton: UIBarButtonItem!
    
    @IBOutlet weak var updateInserPost: UIBarButtonItem!
    
    @IBAction func updateInsertPost(_ sender: AnyObject) {
        if (model?["id"] == nil){
            addPosts()
        }else{
            updatePost()
        }
    }
    @IBAction func publishAction(_ sender: AnyObject) {
        let pub = model?["published"] as! Bool
        let want = model?["wantPublish"] as! Bool
        
        // Change the status
        publishPost(!(pub||want))
        
    }
    
    
    // MARK: - Init
    init(_ client: MSClient){
        self.client = client
        super.init(nibName: nil, bundle: nil)
        
    }
    init (_ client: MSClient, model : AuthorRecord){
        self.client = client
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        syncViewWithModel()
        
    }
    
    // MARK: - Sync
    func syncViewWithModel(){
        self.viewPostTitle.text = model?["title"] as! String?
        self.viewPostAuthor.text = model?["author"] as! String?
        self.viewPostText.text = model?["text"] as! String!
        self.viewPostText.text = "fake text"
        let pub = model?["published"] as! Bool
        let want = model?["wantPublish"] as! Bool
        
        if ( (pub||want) == false){
            self.publishButton.title="Publish"
        }else{
            self.publishButton.title="UnPublish"
        }
        
        if (model?["id"] == nil){
            self.updateInserPost.title="Insert"
        }
        else{
            self.updateInserPost.title="Update"
        }
        
    }
    
    // MARK: - API
    func publishPost(_ pub : Bool){
        var params = Dictionary<String,String>()
        
        if (pub == true){
            params = ["id": model?["id"] as! String, "wantpublish" : "1"]
        }else{
            params = ["id": model?["id"] as! String, "wantpublish" : "0"]
        }
        
        client.invokeAPI("publish", body: nil, httpMethod: "PUT", parameters: params, headers: nil) { (data, result, error) in
            if (result?.statusCode==200){
                print(data)
                // Habria que sincronizar, devolveria el estado y el valor de modelo
                DispatchQueue.main.async {
                    self.model?["wantPublish"] = pub as AnyObject?
                    self.syncViewWithModel()
                }

            }
            else{
                
                if let _ = error {
                    print(error)
                }

            }
        }
        
    }
    func addPosts(){
        let json: Dictionary<String,String> =
            ["author":self.viewPostAuthor.text!,
             "title":self.viewPostTitle.text!,
             "text":self.viewPostText.text]
        
        
        client.invokeAPI("add",
                          body: nil,
                          httpMethod: "POST",
                          parameters: json,
                          headers: nil,
                          completion: { (data, response, error) in
                            if let _ = error{
                                print(error)
                                
                            }else{
                                // Si es correcto, se puede recoger el id y meterlo al modelo
                                print(data)
                                
                                let _ = self.navigationController?.popViewController(animated: true)
                            }
        })
        
        
    }
    
    func updatePost(){
        var params = Dictionary<String,String>()
        
        params = ["id" : model?["id"] as! String,
                  "title": self.viewPostTitle.text!,
                  "author" : self.viewPostAuthor.text!,
                  "text" : self.viewPostText.text
        ]
        
        
        
        client.invokeAPI("updatepost", body: nil, httpMethod: "PUT", parameters: params, headers: nil) { (data, result, error) in
            if (result?.statusCode==200){
                print(data)
                // Habria que sincronizar, devolveria el estado y el valor de modelo
                DispatchQueue.main.async {
                    let _ = self.navigationController?.popViewController(animated: true)
                }
                
            }
            else{
                
                if let _ = error {
                    print(error)
                }
                
            }
        }
        
    }


   
}
