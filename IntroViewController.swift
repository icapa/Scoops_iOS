//
//  IntroViewController.swift
//  Scoop_iOS
//
//  Created by Iván Cayón Palacio on 25/10/16.
//  Copyright © 2016 icapa. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {

    @IBAction func launchFacebook(_ sender: AnyObject) {
    }
    @IBAction func launchAnonymous(_ sender: AnyObject) {
        
        //let anonyDet = AnonymousDetailViewController(nibName: nil, bundle: nil)
        //self.navigationController?.pushViewController(anonyDet, animated: true)

        
        let anonyVC = AnonymousTableViewController(nibName: nil, bundle: nil)
        self.navigationController?.pushViewController(anonyVC, animated: true)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

}
