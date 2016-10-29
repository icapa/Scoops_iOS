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
    
    var blobClient : AZSCloudBlobClient?
    
    @IBOutlet weak var ratePostText: UILabel!
    
    @IBOutlet weak var imagePosts: UIImageView!
    
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

    @IBAction func addPhoto(_ sender: AnyObject) {
        /* La foto */
        
        let picker = UIImagePickerController()
        if UIImagePickerController.isCameraDeviceAvailable(.rear){
            picker.sourceType = .camera
        }else{
            picker.sourceType = .photoLibrary
        }
        picker.delegate = self
        self.present(picker, animated: true) {
            print("No hago nada")
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
        
        // Voy a probar
       
        getPhotoPost()
        
        
        
    }
    
    // MARK: - Sync
    func syncViewWithModel(){
        self.viewPostTitle.text = model?["title"] as! String?
        self.viewPostAuthor.text = model?["author"] as! String?
        self.viewPostText.text = model?["text"] as! String!
        
        let rateS = String.init(format: "Rate: %d/5", model?["rate"] as! Int)
        
        
        self.ratePostText.text = rateS
        
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
        
        var photo : String=""
        
        if model?["photo"] != nil{
            photo = model?["photo"] as! String
        }

        
        let json: Dictionary<String,String> =
            ["author":self.viewPostAuthor.text!,
             "title":self.viewPostTitle.text!,
             "text":self.viewPostText.text,
             "photo": photo
        ]
        
        
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
        
        // Puede que tenga imagen o no
        var photo : String=""
        
        if model?["photo"] != nil{
            photo = model?["photo"] as! String
        }
        
        params = ["id" : model?["id"] as! String,
                  "title": self.viewPostTitle.text!,
                  "author" : self.viewPostAuthor.text!,
                  "text" : self.viewPostText.text,
                  "photo": photo
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

//MARK: - Image Picker
extension AuthorViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true){}
        let auxFoto = info[UIImagePickerControllerOriginalImage] as!  UIImage?
        if (auxFoto != nil){
            storageUploadImage(auxFoto!)
        }
    }
}

//MARK: - Storage
extension AuthorViewController{
    
    func storageUploadImage(_ imagen: UIImage){
        do{
            let credentials = AZSStorageCredentials(accountName: "icapastorage",
            accountKey: "OypqXXmQZVCDfO340/VJQ4jvHf7yinX1QTIUnBwcx4CLWhgI59CvckjkOSnhEyPxvymAY0dMrAX9rVDs8VRSKg==")
            let account = try AZSCloudStorageAccount(credentials: credentials, useHttps: true)
    
            blobClient = account.getBlobClient()
        
            let blobContainer = blobClient?.containerReference(fromName: "posts")
            
            let newIDFile = UUID().uuidString
            
            
            
            let myBlob = blobContainer?.blockBlobReference(fromName: newIDFile)
            myBlob?.upload(from: UIImageJPEGRepresentation(imagen, 0.5)!, completionHandler: { (error) in
                if error != nil{
                    print(error)
                    return
                }
                // Ha subido la imagen bien, actualizo el modelo
                self.model?["photo"] = newIDFile as AnyObject?
                
                DispatchQueue.main.async {
                    //-- Aqui deberia de escalarla, lo hice en la otra practica
                    let  imgRes = imagen.resizeWith(width: self.imagePosts.bounds.height)
                    self.imagePosts.image = imgRes
                    
                }
            })
            
        }
        catch let error{
            print(error)
        }
        
    }
    
    func getPhotoPost()  {
        // Esta descarga la photo y la pone en el cuadro, si existe
        let foto = self.model?["photo"] as? String
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
                        print("Imagen leida OK")
                        DispatchQueue.main.async {
                            let resIm = img?.resizeWith(width: self.imagePosts.bounds.height)
                            self.imagePosts.image = resIm
                            
                            
                        }
                    }
                })
                
            }
        }
    }
}

