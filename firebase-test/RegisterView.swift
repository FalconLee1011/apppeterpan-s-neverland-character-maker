//
//  RegisterView.swift
//  firebase-test
//
//  Created by falcon on 2021/6/14.
//

import SwiftUI

struct RegisterView: View {
  @State var email: String = ""
  @State var password: String = ""
  @Binding var hasLogin: Bool
  @Binding var showRegisterSheet: Bool
  @State var showAlert: Bool = false
  @State var alertMessage: String = ""
  
  var body: some View {
    VStack{
      Text("Register | 註冊")
      TextField("Email", text: $email)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .frame(width: 200)
        .autocapitalization(.none)
      SecureField("Password", text: $password)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .frame(width: 200)
        .autocapitalization(.none)
        .alert(isPresented: $showAlert) { () -> Alert in
          Alert(title: Text("Welcome!"))
        }
      Button("Register"){
        FirebaseStuff.FirebaseAuth.createUser(mail: email, password: password){ user in
          print("attmpt")
          if( user != nil ){
            alertMessage = "Welcome, \(user?.email) !"
            hasLogin = true
            showAlert = true
          }
          else{
            print("err")
            alertMessage = "Error registering."
            showAlert = true
          }
        }
      }
      .padding(.bottom, 10)
      Button("Cancel"){
        showRegisterSheet = false
      }
    }
  }
}
