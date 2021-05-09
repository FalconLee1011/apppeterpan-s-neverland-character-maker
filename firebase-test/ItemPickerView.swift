//
//  ItemPickerView.swift
//  firebase-test
//
//  Created by falcon on 2021/6/14.
//

import SwiftUI

struct ItemPickerView: View {
  var items: [String]
  var part: String
  var callback: (_ part: String, _ item: String) -> Void
  
  @Binding var showSheet: Bool
  
//  let data = (1...100).map { "Item \($0)" }
  
  let columns = [
    GridItem(.adaptive(minimum: 80))
  ]
  var body: some View {
    ScrollView {
      LazyVGrid(columns: columns, spacing: 20) {
        ForEach(items, id: \.self) { item in
          Button(action: {
            print(item)
            callback(part, item)
            showSheet = false
          }) {
            Image("\(item)")
              .resizable()
              .scaledToFit()
              .frame(width: 75, height: 75)
          }
        }
      }
      .padding(.horizontal)
    }
  }
}
