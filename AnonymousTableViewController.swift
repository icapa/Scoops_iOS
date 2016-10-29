//
//  AnonymousTableViewController.swift
//  Scoop_iOS
//
//  Created by Iván Cayón Palacio on 26/10/16.
//  Copyright © 2016 icapa. All rights reserved.
//

import UIKit

typealias PhotoDataModel = Dictionary<String,UIImage>


class AnonymousTableViewController: UITableViewController {
    var blobClient : AZSCloudBlobClient?
    var model: [AuthorRecord]? = []
    var client : MSClient?
    var photoWithModelLink : [PhotoDataModel]? = []

    //MARK: - Init
    init (_ client: MSClient){
        self.client = client
        super.init(nibName: nil, bundle: nil)
        // Celda personalizada
        let cellNib = UINib(nibName: "PostCellTableViewTableViewCell", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: PostCellTableViewTableViewCell.cellId)
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
        // Cell default Init
        /*
        let cellId = "PostCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        
        if cell == nil{
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        }
         */
        
        let cell = tableView.dequeueReusableCell(withIdentifier: PostCellTableViewTableViewCell.cellId) as? PostCellTableViewTableViewCell
        
        let item = model?[indexPath.row]
        
        /* Esto era para la celda por defecto */
        //cell?.textLabel?.text = (item?["title"] as! String)
        //cell?.detailTextLabel?.text = (item?["author"] as! String)
        
        cell?.postTitle.text = (item?["title"] as! String)
        cell?.postAuthor.text = (item?["author"] as! String)
        let fecha = item?["updatedAt"] as! Date
        let fechaFormat = DateFormatter()
        fechaFormat.dateStyle = .long
        let f = fechaFormat.string(from: fecha)
        
        cell?.postDate.text = f
        
        cell?.setRate(item?["rate"] as! Int)
        
       
        
        var encontrado = false
        
        var dynImage : UIImage?
        for each in photoWithModelLink!{
            print("Buscando en \(each)")
            let photoS = item?["photo"] as! String
            
            if ( each[photoS] != nil){
                dynImage = each[photoS]
                encontrado = true
                break
            }
        }
        if encontrado == true{
            cell?.imageView?.image = dynImage!
        }else{
            getPhotoPost(item!)
        }
        
        
        
        
        return cell!

    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = model?[indexPath.row]
        let detVC = AnonymousDetailViewController(client!, model: item!)
        self.navigationController?.pushViewController(detVC, animated: true)

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 85
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
//MARK: - Storage
extension AnonymousTableViewController{
    func getPhotoPost(_ post : AuthorRecord)  {
        // Esta descarga la photo y la pone en el cuadro, si existe
        let foto = post["photo"] as? String
        
        
        
        
        
        if foto != nil{
            if !((foto?.isEmpty)!){
                // Recogemos el blob
                
                let credentials = AZSStorageCredentials(accountName: "icapastorage",
                                                        accountKey: "OypqXXmQZVCDfO340/VJQ4jvHf7yinX1QTIUnBwcx4CLWhgI59CvckjkOSnhEyPxvymAY0dMrAX9rVDs8VRSKg==")
                
                let account = try! AZSCloudStorageAccount(credentials: credentials, useHttps: true)
                
                blobClient = account.getBlobClient()
                
                
                
                let blobContainer = blobClient?.containerReference(fromName: "posts")
                
                let blob = AZSCloudBlockBlob(container: blobContainer!, name: foto!)
                
                blob.downloadToData(completionHandler: { (error, data) in
                    if let _ = error {
                        print(error)
                        return
                    }
                    if let _ = data {
                        
                        let img = UIImage(data: data!)
                        
                        let imgRes = img?.resizeWith(width: 100)
                        
                        let link = [post["photo"] as! String : imgRes!]
                        self.photoWithModelLink?.append(link)
                        
                        
                        
                        print("Imagen leida OK")
                        DispatchQueue.main.async {
                            // 
                            print("Descargo la imagen \(img?.description)")
                            self.tableView.reloadData()
                        }
                        

                    }
                })
                
            }
        }
    }

}
