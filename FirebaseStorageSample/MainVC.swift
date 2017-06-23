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

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var SelectedImageView: UIImageView!
    
    
    
    var ImagePicker: UIImagePickerController!
    var handle: AuthStateDidChangeListenerHandle? = nil
    let pickedImage: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            
        }
        
        SignInUser()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        Auth.auth().removeStateDidChangeListener(handle!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("Picked Image")
        
        if let img = info[UIImagePickerControllerEditedImage] as? UIImage {
            SelectedImageView.image = img
            
        }
        
        ImagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Canceled Without Picking Image")
    }

    func SignInUser()
    {
       Auth.auth().signIn(withEmail: "douglasc.spencer@gmail.com", password: "qqqqqq") { (user, error) in
        if error != nil {
            print(error!)
        } else {

        }
        
        }
    }
    
    @IBAction func SelectImage() {
        ImagePicker = UIImagePickerController()
        ImagePicker.allowsEditing = true
        ImagePicker.delegate = self
        present(ImagePicker, animated: true, completion: nil)
    }
    
    @IBAction func UploadToFireBase() {
        guard let img = SelectedImageView.image else {
            return
        }
        
        if let data = UIImageJPEGRepresentation(SelectedImageView.image!, 0.2) {
            let imgUniqueID = NSUUID().uuidString
            
            
            let storage = Storage.storage()
            let storageRef = storage.reference()
            

            // Create a reference to the file you want to upload
            let profileRef = storageRef.child("images/\(imgUniqueID).jpg")
            
            // Upload the file to the path "images/rivers.jpg"
            let _ = profileRef.putData(data, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    return
                }
                // Metadata contains file metadata such as size, content-type, and download URL.
                let downloadURL = metadata.downloadURL
                print(downloadURL()?.absoluteString)
            }
            
        }
    }
    
    

}

