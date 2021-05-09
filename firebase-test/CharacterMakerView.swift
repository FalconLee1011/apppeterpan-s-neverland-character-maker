//
//  CharacterMakerView.swift
//  firebase-test
//
//  Created by falcon on 2021/6/14.
//

import SwiftUI


let parts: [String: [String]] = [
  "accessoriesParts": ["None-ACC", "Glasses 5", "Glasses 4", "Eyepatch", "Sunglasses", "Glasses 2", "Glasses 3", "Sunglasses 2", "Glasses"],
  
  "bodyParts": ["Gaming", "Button Shirt 1", "Tee 1", "Polka Dot Jacket", "Thunder T-Shirt", "Blazer Black Tee", "Polo and Sweater", "Gym Shirt", "Dress", "Hoodie", "Striped Pocket Tee", "Paper", "Whatever", "Sweater", "Tee Selena", "Explaining-body", "Tee Arms Crossed", "Sweater Dots", "Shirt and Coat", "Fur Jacket", "Macbook", "Coffee", "Button Shirt 2", "Tee 2", "Killer", "Striped Tee", "Device", "Pointing Up", "Sporty Tee", "Turtleneck"],
  
  "faceParts": ["Calm", "Loving Grin 2", "Cyclops", "Eyes Closed", "Concerned", "Concerned Fear", "Solemn", "Suspicious", "Eating Happy", "Smile Big", "Monster", "Cheeky", "Very Angry", "Rage", "Explaining", "Smile Teeth Gap", "Blank", "Fear", "Serious", "Smile LOL", "Loving Grin 1", "Old", "Cute", "Driven", "Angry with Fang", "Tired", "Smile", "Awe", "Contempt", "Hectic"],
  
  "facialHairParts": ["None-FH", "Moustache 8", "Moustache 9", "Moustache 2", "Moustache 3", "Full 4", "Full", "Moustache 5", "Moustache 4", "Full 3", "Full 2", "Goatee 1", "Moustache 1", "Goatee 2", "Chin", "Moustache 6", "Moustache 7"],
  
  "headParts": ["Gray Short", "Bear", "Short 2", "Short 3", "Pomp", "Medium Straight", "hat-beanie", "Cornrows 2", "Afro", "Medium 2", "Long", "Medium 3", "Hijab", "Shaved 1", "Long Curly", "No Hair 1", "hat-hip", "Twists 2", "Turban", "Gray Medium", "Short 5", "Short 4", "Mohawk 2", "Buns", "Flat Top Long", "Bun", "Bun 2", "Medium 1", "Medium Bangs 3", "Medium Bangs 2", "Bantu Knots", "Bangs", "Cornrows", "Short 1", "Long Afro", "Flat Top", "Twists", "Long Bangs", "Gray Bun", "Mohawk", "Bangs 2", "Medium Bangs", "Shaved 2", "Shaved 3", "No Hair 2", "No Hair 3"],
]

let keys = [
  "accessoriesParts",
  "bodyParts",
  "faceParts",
  "facialHairParts",
  "headParts"
]

enum SheetType {
  case charInfo, parts
}

var timer: xTimer? = nil

struct CharacterMakerView: View {
  
  @State var headSelection: Int = 0
  @State var faceSelection: Int = 0
  @State var facialHairSelection: Int = 2
  @State var accessoriesSelection: Int = 1
  @State var bodySelection: Int = 0
  @State var name: String = ""
  @State var age: String = ""
  
  @State var isReady: Bool = false
  @Binding var hasLogin: Bool
  
  @State var isRandomEnabled: Bool = true
  
  @State var showSheet: Bool = false
  @State var sheet: SheetType = SheetType.parts
  
  @State var selectedItem: String = "accessoriesParts"
  
  @State var user = FirebaseStuff.FirebaseAuth.getUser()
  
  var body: some View {
    VStack{
      HStack{
        Text("Hi, \(user?.email ?? "---")")
        Button("Logout"){
          FirebaseStuff.FirebaseAuth.logout()
          hasLogin = false
        }.zIndex(1000)
      }
      Spacer()
      if(isReady){
        ZStack{
          Image("background")
            .resizable()
            .frame(width: 225, height: 425)
            .offset(y: -50)
          VStack{
            ZStack{
              Image("\(parts["headParts"]![headSelection])")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .offset(x: 10)
                .zIndex(1)
              Image("\(parts["faceParts"]![faceSelection])")
                .resizable()
                .scaledToFit()
                .frame(width: 130, height: 130)
                .offset(x: 20, y: 10)
                .zIndex(2)
              //          Image("\(facialHairParts[facialHairSelection])")
              //            .resizable()
              //            .scaledToFit()
              //            .frame(width: 50, height: 50)
              //            .offset(x: 20, y: 45)
              //            .zIndex(3)
              Image("\(parts["accessoriesParts"]![accessoriesSelection])")
                .resizable()
                .scaledToFit()
                .frame(width: 130, height: 130)
                //          .offset(x: 0)
                .zIndex(4)
            }
            Image("\(parts["bodyParts"]![bodySelection])")
              .resizable()
              .scaledToFit()
              .frame(width: 200, height: 200)
              .offset(x:-10, y: -50)
          }
        }
      }
      else{
        ProgressView()
          .progressViewStyle(CircularProgressViewStyle())
          .padding(.bottom, 20)
        Text("Loading...")
        Spacer()
      }
    }
    .onAppear(){
      timer = xTimer(time: 1, interval: 0.1, callback: rnd, callbackOnTimerDone: { () -> Any in
        isRandomEnabled = true
      })
      self.fetchAccountCharacter()
    }
    
    if(isReady){
      ForEach(keys, id: \.self){ key in
        Button("Select \(key.replacingOccurrences(of: "Parts", with: "", options: .literal, range: nil))"){
          sheet = SheetType.parts
          print(key)
          selectedItem = key
          showSheet = true
        }
        .padding(.bottom, 5)
      }
      
      Button("Edit character info & upload"){
        sheet = SheetType.charInfo
        showSheet = true
      }
      .padding(.bottom, 5)
      
      Button("Random"){
        timer?.start()
      }
      .sheet(isPresented: $showSheet, content: {
        switch sheet{
          case .charInfo:
            CharacterInfoView(name: $name, age: $age, callback: self.getCurrentAppearance)
          case .parts:
            ItemPickerView(items: parts[selectedItem]!, part: selectedItem, callback: self.setPart, showSheet: $showSheet)
        }
      })
      .disabled(!isRandomEnabled)
    }
    
  }
  func rnd() {
    isRandomEnabled = false
    headSelection = Int.random(in: 0..<parts["headParts"]!.count)
    faceSelection = Int.random(in: 0..<parts["faceParts"]!.count)
    facialHairSelection = Int.random(in: 0..<parts["facialHairParts"]!.count)
    accessoriesSelection = Int.random(in: 0..<parts["accessoriesParts"]!.count)
    bodySelection = Int.random(in: 0..<parts["bodyParts"]!.count)
  }
  func setPart(part: String, item: String){
    switch part {
      case "accessoriesParts":
        accessoriesSelection = parts[part]!.firstIndex(of: item)!
        break
      case "bodyParts":
        bodySelection = parts[part]!.firstIndex(of: item)!
        break
      case "faceParts":
        faceSelection = parts[part]!.firstIndex(of: item)!
        break
      case "facialHairParts":
        facialHairSelection = parts[part]!.firstIndex(of: item)!
        break
      case "headParts":
        headSelection = parts[part]!.firstIndex(of: item)!
        break
      default:
        break
    }
  }
  
  func getCurrentAppearance() -> [String: Int]{
    return [
      "accessories": accessoriesSelection,
      "body": bodySelection,
      "face": faceSelection,
      "facialHair": facialHairSelection,
      "head": headSelection,
    ]
  }
  
  func fetchAccountCharacter(){
    FirebaseStuff.FirebaseData().fetch { (data) in
      if(data != nil){
        name = data?.name ?? ""
        age = data?.age ?? ""
        accessoriesSelection = data?.character["accessories"] ?? 0
        bodySelection = data?.character["body"] ?? 0
        faceSelection = data?.character["face"] ?? 0
        facialHairSelection = data?.character["facialHair"] ?? 0
        headSelection = data?.character["head"] ?? 0
      }
      isReady = true
    }
  }
}

//struct CharacterMakerView_Previews: PreviewProvider {
//  static var previews: some View {
//    CharacterMakerView()
//  }
//}
