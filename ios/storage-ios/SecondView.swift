//
//  SecondView.swift
//  storage-ios
//
//  Created by 浜崎優一 on 2023/04/14.
//

import SwiftUI

struct Item: Codable {
  var id: String?
  var title: String?
  var artist: String?
  var Price: Int?
}

struct SecondView: View {
  @State private var items = [Item]()
  @State private var name = ""
  @State var isloading = true

  
  var body: some View {
    ZStack {
      NavigationStack {
        List(items, id: \.id) { item in
          VStack(alignment: .leading) {
            Text(item.title ?? "")
              .font(.headline)
            HStack {
              Text(item.id ?? "")
              Text(item.artist ?? "")
            }
          }
        }
        .navigationTitle("Items")
        .toolbar{
          ToolbarItem(placement: .navigationBarLeading) {
            Button("Reload") { loadData() }
          }
          ToolbarItem(placement: .navigationBarTrailing) {
            Menu {
              Button(String(items.count)) {return}
              Button("title1") {return}
              Button("title2") {return}
            } label: {
              Text("Create")
            }
          }
        }
      }.onAppear(perform: loadData)
      
      if isloading {
        Color.gray.opacity(0.5)
        ProgressView()
      }
    }
  }
  
  func loadData() {
    isloading = true
    
    guard let url = URL(string: "https://fashion-app-z2zcp4g4ca-uw.a.run.app/api/v1/items") else {
      return
    }
    let request = URLRequest(url: url)
    
    URLSession.shared.dataTask(with: request) { data, response, error in
      if let data = data {
        let decoder = JSONDecoder()
        guard let decodedResponse = try? decoder.decode([Item].self, from: data) else {
          return
        }
        DispatchQueue.main.async {
          items = decodedResponse
        }
      } else {
        print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
      }
    }.resume()
    
    isloading = false
  }
}

struct SecondView_Previews: PreviewProvider {
  static var previews: some View {
    SecondView()
  }
}
