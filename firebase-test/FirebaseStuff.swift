//
//  FirebaseStuff.swift
//  firebase-test
//
//  Created by falcon on 2021/6/14.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorageSwift

class FirebaseStuff{

  class FirebaseAuth{
    static func createUser(mail: String, password: String, complete: @escaping (_ user: User?) -> Void) {
      Auth.auth().createUser(withEmail: mail, password: password){
        res, rej in
        guard let user = res?.user,
              rej == nil else{
          print(rej?.localizedDescription ?? "")
          complete(nil)
          return
        }
        print(user)
        complete(user)
      }
    }
    
    static func login(mail: String, password: String, complete: @escaping (_ user: User?) -> Void) {
      Auth.auth().signIn(withEmail: mail, password: password){
        res, rej in
        guard let user = res?.user,
              rej == nil else{
          print(rej?.localizedDescription ?? "")
          complete(nil)
          return
        }
        print(user)
        complete(user)
      }
    }
    
    static func logout(){
      do{
        try Auth.auth().signOut()
      }
      catch{
        print(error)
      }
    }

    static func getUser() -> User?{
      return Auth.auth().currentUser ?? nil
    }
  }
    
  class FirebaseData{
    let database = Firestore.firestore()
    let COLLECTION = "characters"
    
    func upload(data: [String : Any]){
      do{
        let document = try self.database.collection(self.COLLECTION).addDocument(data: data)
        print(document.documentID)
      }
      catch{
        print(error)
      }
    }
    
    func uploadUserCharacter(id: String , data: UserCharacter){
      do{
        let document = try self.database.collection(self.COLLECTION).document(id).setData(from: data)
        print(document)
      }
      catch{
        print(error)
      }
    }
    
    func fetch(completion: @escaping (_ data: UserCharacter?) -> Void) {
//      let c: UserCharacter = nil
      self.database
        .collection(self.COLLECTION)
        .document((FirebaseAuth.getUser()?.email!)!)
        .getDocument { document, error in
          guard let document = document, document.exists,
            let c = try? document.data(as: UserCharacter.self) else {
              completion(nil)
              return
            }
          completion(c)
        }
    }
  }
  
}
