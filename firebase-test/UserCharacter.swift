//
//  FirebaseData.swift
//  firebase-test
//
//  Created by falcon on 2021/6/14.
//

import Foundation
import FirebaseFirestoreSwift

struct UserCharacter: Codable, Identifiable {
  @DocumentID var id: String?
  var name: String
  var age: String
  var character: [String: Int]
}
