//
//  RegistrationViewModel.swift
//  Spartans
//
//  Created by Gabriel Del VIllar De Santiago on 12/6/19.
//  Copyright © 2019 Gabriel Del VIllar De Santiago. All rights reserved.
//

import UIKit
import Firebase

class RegistrationViewModel {
    
    var bindableRegistering = Bindable<Bool>()
    var bindableImage = Bindable<UIImage>()
    var bindableIsFormValid = Bindable<Bool>()
    
    var fullName: String? {
        didSet {
            checkFormValidity()
        }
    }
    var email: String? {didSet{checkFormValidity()}}
    var password: String?{didSet{checkFormValidity()}}
    var repassword: String?{didSet{checkFormValidity()}}
    
    func performRegistration(completion: @escaping (Error?) -> ()){
        
        guard let email = email, let password = password else {return}
        bindableRegistering.value = true
       Auth.auth().createUser(withEmail: email, password: password) { [unowned self](res, err) in
           if let err = err {
               print(err)
               completion(err)
               return
           }
           
        
        self.saveImageToFireabse(completion: completion)
        
        }
    }
    
    
    
    //MARK: Fileprivate
    
    fileprivate func saveImageToFireabse(completion: @escaping (Error?) -> ()){
        let filename = UUID().uuidString
                 let ref = Storage.storage().reference(withPath: "/images/\(filename)")
              let imageData = self.bindableImage.value?.jpegData(compressionQuality: 0.75) ?? Data()
                 ref.putData(imageData, metadata: nil) { (_, err) in
                     if let err = err{
                          completion(err)
                         return
                     }
                     
                     print("Finished uploading imaeg to storage")
                     ref.downloadURL { (url, err) in
                         if let err = err{
                              completion(err)
                             return
                         }
                         
                      self.bindableRegistering.value = false
                      print("Download url of our image is: ", url?.absoluteString ?? "")
                        
                        let imageUrl = url?.absoluteString ?? ""
                        self.saveInfoToFirestore(imageUrl: imageUrl, completion: completion)
                      
                     }
                 }
             
    }
    
    fileprivate func saveInfoToFirestore(imageUrl: String, completion: @escaping (Error?) ->()){
        let uid = Auth.auth().currentUser?.uid ?? ""
        let docData = ["fullName": fullName ?? "", "uid": uid, "imageUrl1":imageUrl]
        Firestore.firestore().collection("users").document(uid).setData(docData) { (err) in
            if let err = err{
                completion(err)
                return
            }
            
            completion(nil)
        }
    }
    
    func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false && repassword?.isEmpty == false && password == repassword && bindableImage.value != nil
        
        bindableIsFormValid.value = isFormValid
    }
    
   
    
}
