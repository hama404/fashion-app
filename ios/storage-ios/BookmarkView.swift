//
//  BookmarkView.swift
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

struct BookmarkView: View {
  @State private var items = [Item]()
  @State private var name = ""
  @State var isloading = false
  @State var isShowCreate = false
  @State var isShowAlert = false

  var body: some View {
    ZStack {
      NavigationStack {
        List(items, id: \.id) { item in
          NavigationLink(destination: BlankView()) {
            VStack(alignment: .leading) {
              Text(item.title ?? "")
                .font(.headline)
              HStack {
                Text(item.id ?? "")
                Text(item.artist ?? "")
              }
            }
          }
        }
        .navigationTitle("Items (\(items.count))")
        .toolbar{
          ToolbarItem(placement: .navigationBarLeading) {
            Button { loadData() } label: {
              Image(systemName: "arrow.clockwise")
            }

          }
          ToolbarItem(placement: .navigationBarTrailing) {
            Menu {
              Button("Create") {
                isShowCreate = true
              }
              Button("Delete") {
                isShowAlert  = true
              }
              Button("Search") {
                isShowAlert = true
              }
            } label: {
              Image(systemName: "ellipsis.circle")            }
          }
        }
      }
      .onAppear(perform: loadData)
      .sheet(isPresented: $isShowCreate) {
        CreateView()
      }
      .alert(isPresented: $isShowAlert) {
        Alert(title: Text("comming soon ..."))
      }
      
      if isloading {
        Color.gray.opacity(0.5)
        ProgressView()
      }
    }
  }
  
  func loadData() {
    print("call loadData !")
    isloading = true
    
    guard let url = URL(string: "https://fashion-app-z2zcp4g4ca-uw.a.run.app/api/v1/items") else {
      return
    }
    let request = URLRequest(url: url)
    
    URLSession.shared.dataTask(with: request) { data, response, error in
      if let data = data {
        let decoder = JSONDecoder()
        guard let decodedResponse = try? decoder.decode([Item].self, from: data) else {
          print("decode error !")
          return
        }
        DispatchQueue.main.async {
          items = decodedResponse
        }
      } else {
        print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        return
      }
    }.resume()
    
    isloading = false
  }
}

struct CreateView: View {
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
      }.navigationBarTitle("CreateView")
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
        items = decodedResponse
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

struct BookmarkView_Previews: PreviewProvider {
  static var previews: some View {
    BookmarkView()
  }
}
