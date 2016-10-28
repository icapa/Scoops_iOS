//
//  AnonymousDetailViewController.swift
//  Scoop_iOS
//
//  Created by Iván Cayón Palacio on 26/10/16.
//  Copyright © 2016 icapa. All rights reserved.
//

import UIKit

class AnonymousDetailViewController: UIViewController {
    
    var client : MSClient
    var model : AuthorRecord?

    

    @IBOutlet weak var segmentedRates: UISegmentedControl!
    @IBOutlet weak var textComplete: UITextView!
    @IBOutlet weak var labelAuthor: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    //MARK: - Init
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
    //MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        syncViewWithModel()
        
    }
    
    
   //MARK: - Sync
    func syncViewWithModel(){
        self.labelTitle.text = model?["title"] as! String?
        self.labelAuthor.text = model?["author"] as! String?
        self.textComplete.text = model?["text"] as! String!
        let rate = model?["rate"] as? Int
        if (rate != nil){
            self.segmentedRates.selectedSegmentIndex = rate!-1
        }else{
            self.segmentedRates.selectedSegmentIndex = 0
        }
        
        
        
    }
    //MARK: - Actions
    
    @IBAction func rate(_ sender: AnyObject) {
        print("Enviando valoracion \(segmentedRates.selectedSegmentIndex+1)")
        ratePost(segmentedRates.selectedSegmentIndex+1)
    }
    
    //MARK: - Rate new
    func ratePost(_ rate: Int){
        var params = Dictionary<String,String>()
        
        params = ["id" : model?["id"] as! String,
                  "rate" : String.init(format: "%d", rate)]
        
        
        
        
        
        client.invokeAPI("rate", body: nil, httpMethod: "PUT", parameters: params, headers: nil) { (data, result, error) in
            
            if let _ = error {
                print (error)
            }else{
                print(data)
                // Habria que sincronizar, devolveria el estado y el valor de modelo
                DispatchQueue.main.async {
                    //let _ = self.navigationController?.popViewController(animated: true)
                    print("SE HA HECHO BIEN EL POST")
                }
            }
        }

    }
}
