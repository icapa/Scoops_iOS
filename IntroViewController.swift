//
//  IntroViewController.swift
//  Scoop_iOS
//
//  Created by Iván Cayón Palacio on 25/10/16.
//  Copyright © 2016 icapa. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {

    var client : MSClient = MSClient(applicationURL: URL(string: "https://icapa-mbass.azurewebsites.net")!)
    
    
    // MARK: - Actions
    
    @IBAction func launchFacebook(_ sender: AnyObject) {
        // Nos autenticamos
        if let _ = client.currentUser{
            print("Client is authenticated!!")
            self.launchAuthorView()
        }
        else{
            doLoginInFacebook()
            print("Saliendo de autenticar")
        }
        
        
        
    }
    @IBAction func launchAnonymous(_ sender: AnyObject) {
        
        //let anonyDet = AnonymousDetailViewController(nibName: nil, bundle: nil)
        //self.navigationController?.pushViewController(anonyDet, animated: true)

        
        let anonyVC = AnonymousTableViewController(client)
        self.navigationController?.pushViewController(anonyVC, animated: true)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
       // MARK: - FacebookLogin
    func doLoginInFacebook(){
        client.login(withProvider: "facebook", parameters: nil, controller: self, animated: true)
        { (user, error) in
            if let _ = error {
                print(error)
                return
            }else{
                // Load writer view controller
                DispatchQueue.main.async{
                    self.launchAuthorView()
                }
                return
            }
            
        }
    }
    
    func launchAuthorView(){
        let author = AutorTableViewController(client)
        self.navigationController?.pushViewController(author, animated: true)
    }

}
