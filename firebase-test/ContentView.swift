//
//  ContentView.swift
//  firebase-test
//
//  Created by falcon on 2021/5/10.
//

import SwiftUI

struct ContentView: View {
  @State var hasLogin: Bool = false
  var body: some View {
    if(!hasLogin){
      LoginView(hasLogin: $hasLogin)
    }
    else{
      CharacterMakerView(hasLogin: $hasLogin)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
