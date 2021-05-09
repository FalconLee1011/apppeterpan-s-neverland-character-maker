//
//  CharacterInfoView.swift
//  firebase-test
//
//  Created by falcon on 2021/6/14.
//

import SwiftUI

struct CharacterInfoView: View {
  @Binding var name: String
  @Binding var age: String
  var callback: () -> [String: Int]
  var body: some View {
    Text("Edit character info & upload")
    TextField("Name", text: $name)
      .textFieldStyle(RoundedBorderTextFieldStyle())
      .frame(width: 300)
      .autocapitalization(.none)
    
    TextField("Age", text: $age)
      .textFieldStyle(RoundedBorderTextFieldStyle())
      .frame(width: 300)
      .autocapitalization(.none)
      .keyboardType(.numberPad)
    
    Button("Upload"){
//      var data: [String: Any] = [:]
//      data["name"] = name
//      data["age"] = age
//      data["user"] = FirebaseStuff.FirebaseAuth.getUser()?.email ?? ""
//      data["character"] = callback()
//      data["id"] = data["user"]
//      FirebaseStuff.FirebaseData().upload(data: data)
      let data = UserCharacter(name: name, age: age, character: callback())
      
      FirebaseStuff.FirebaseData().uploadUserCharacter(id: FirebaseStuff.FirebaseAuth.getUser()?.email ?? "", data: data)
    }
  }
}
