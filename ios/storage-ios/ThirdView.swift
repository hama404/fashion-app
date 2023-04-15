//
//  ThirdView.swift
//  storage-ios
//
//  Created by 浜崎優一 on 2023/04/15.
//

import SwiftUI

struct ThirdView: View {
  @State private var items = [Item]()
  @State private var message = "none"
  @State private var id = "7"
  @State private var title = "hoge"
  @State private var artist = "huuuu"
  @State private var price = "9928"
  
  var body: some View {
    NavigationStack {
      Form {
        TextField("id...", text: $id)
          .textFieldStyle(RoundedBorderTextFieldStyle())
        TextField("title...", text: $title)
          .textFieldStyle(RoundedBorderTextFieldStyle())
        TextField("artist...", text: $artist)
          .textFieldStyle(RoundedBorderTextFieldStyle())
        TextField("price...", text: $price)
          .textFieldStyle(RoundedBorderTextFieldStyle())
        Button("Create") { createData() }
        Text("message: \(message)")
      }.navigationBarTitle("ThirdView")
    }
  }
  
  func createData() {
    let newdata: Item = .init(
      id: id,
      title: title,
      artist: artist,
      Price: Int(price)
    )
    
    guard let url = URL(string: "https://fashion-app-z2zcp4g4ca-uw.a.run.app/api/v1/items") else {
      return
    }
    guard let httpBody = try? JSONEncoder().encode(newdata) else {
      return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
    //    request.setValue("Basic \(authBase64)", forHTTPHeaderField: "Authorization")
    request.httpBody = httpBody
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      if let data = data {
        let decoder = JSONDecoder()
        guard let decodedResponse = try? decoder.decode([Item].self, from: data) else {
          return
        }
      } else {
        message = "error!!"
        print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
      }
    }
    task.resume()
    
    message = "success!!"
    id = String(Int(id) ?? 0 + 1)
    title = ""
    artist = ""
    price = ""
  }
}

struct ThirdView_Previews: PreviewProvider {
  static var previews: some View {
    ThirdView()
  }
}
