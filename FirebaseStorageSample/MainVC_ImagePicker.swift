//
//  MainVC_ImagePicker.swift
//  FirebaseStorageSample
//
//  Created by Douglas Spencer on 8/26/17.
//  Copyright © 2017 Douglas Spencer. All rights reserved.
//

import UIKit

extension MainVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("Picked Image")
        
        if let img = info[UIImagePickerControllerEditedImage] as? UIImage {
            imgViewSelectedImage.image = img
            btnUploadImageToFirebase.isHidden = false
            prgFileUploadProgress.isHidden = false
            lblProgress.isHidden = false
            
        }
        
        ImagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Canceled Without Picking Image")
        ImagePicker.dismiss(animated: true, completion: nil)
    }
}
