//
//  LoginView.swift
//  firebase-test
//
//  Created by falcon on 2021/6/14.
//

import SwiftUI

struct LoginView: View {
  @State var email: String = ""
  @State var password: String = ""
  @Binding var hasLogin: Bool
  @State var showAlert: Bool = false
  @State var showRegisterSheet: Bool = false
  var body: some View {
    VStack{
      Text("Login | 登入")
      TextField("Email", text: $email)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .frame(width: 200)
        .autocapitalization(.none)
      TextField("Password", text: $password)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .frame(width: 200)
        .autocapitalization(.none)
        .alert(isPresented: $showAlert) { () -> Alert in
          Alert(title: Text("Invalid email or password"))
        }
      Button("Login"){
        FirebaseStuff.FirebaseAuth.login(mail: email, password: password){ user in
          print("attmpt")
          if( user != nil){
            print("Login")
            hasLogin = true
          }
          else{
            print("err")
            showAlert = true
          }
        }
      }
      .padding(.bottom, 10)
      .sheet(isPresented: $showRegisterSheet, content: {
        RegisterView(hasLogin: $hasLogin, showRegisterSheet: $showRegisterSheet)
      })
      .onAppear {
        if(FirebaseStuff.FirebaseAuth.getUser()?.email != nil){
          hasLogin = true
        }
      }
      Button("No account? Click register"){
        showRegisterSheet = true
      }
    }
  }
}
