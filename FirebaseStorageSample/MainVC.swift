//
//  ViewController.swift
//  FirebaseStorageSample
//
//  Created by Douglas Spencer on 6/23/17.
//  Copyright © 2017 Douglas Spencer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class MainVC: UIViewController {

    //MARK: IBOutlets
    @IBOutlet weak var imgViewSelectedImage: UIImageView!
    @IBOutlet weak var btnIsUserOnline: UIButton!
    @IBOutlet weak var btnUploadImageToFirebase: UIButton!
    @IBOutlet var prgFileUploadProgress: UIProgressView!
    @IBOutlet weak var lblProgress: UILabel!
    
    //MARK: Module Level Variables and Constants
    var ImagePicker: UIImagePickerController!
    var handle: AuthStateDidChangeListenerHandle? = nil
    let selectedImage: UIImage? = nil
    var isUserSigned: Bool = false
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                print("Logged In")
            } else {
                print ("Not Logged In")
            }
        }
        
        if isUserSigned == false {
            btnIsUserOnline.backgroundColor = UIColor.red
        } else {
            btnIsUserOnline.backgroundColor = UIColor.green
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle!)
    }

    //MARK: User Functions
    func SignInUser()
    {
       Auth.auth().signIn(withEmail: "douglasc.spencer@gmail.com", password: "qqqqqq") { (user, error) in
        if error != nil {
            print(error!)
        } else {
            self.btnIsUserOnline.backgroundColor = UIColor.green
        }
      }
    }
    
    //MARK: IBActions
    @IBAction func GoOnline(_ sender: Any) {
        SignInUser()
    }
    
    @IBAction func SelectImage() {
        ImagePicker = UIImagePickerController()
        ImagePicker.allowsEditing = true
        ImagePicker.delegate = self
        present(ImagePicker, animated: true, completion: nil)
    }
    
    @IBAction func UploadToFireBase() {
        guard let _ = imgViewSelectedImage.image else {
            return
        }
        
        if let data = UIImageJPEGRepresentation(imgViewSelectedImage.image!, 0.2) {
            let imgUniqueID = NSUUID().uuidString
            
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let profileRef = storageRef.child("images/\(imgUniqueID).jpg")
            
            let PhotoMetaData: StorageMetadata = StorageMetadata();
            PhotoMetaData.contentType = "image/jpeg"
            
            let uploadtask = profileRef.putData(data, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    return
                }
                let downloadURL = metadata.downloadURL
            }
            
            uploadtask.observe(.progress) { snapshot in
                let percentComplete = 100 * Double(snapshot.progress!.completedUnitCount)
                    / Double(snapshot.progress!.totalUnitCount)
                
                self.lblProgress.text = String(percentComplete)
                self.prgFileUploadProgress.progress = Float(percentComplete)
            }
        }
    }
}

