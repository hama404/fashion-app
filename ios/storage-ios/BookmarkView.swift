//
//  BookmarkView.swift
//  storage-ios
//
//  Created by 浜崎優一 on 2023/04/14.
//

import SwiftUI

struct Item: Codable, Identifiable {
  var id: Int?
  var url: String?
  var title: String?
  var description: String?
  var name: String?
  var tag_id: Int?
}

struct ItemInput: Codable {
  var url: String?
  var title: String?
  var description: String?
  var tag_id: String?
}

typealias Items = [Item]

let itemsEndpoint = "https://fashion-app-z2zcp4g4ca-uw.a.run.app/api/v1/items/"
//let itemsEndpoint = "https://localhost:8080/api/v1/items/"

class ItemDownloader: ObservableObject {
  @Published var items: Items = [Item]()
  @Published var item: Item = Item()

  init() {
    print("call observable init!")
  }
  
  func fetchItem() {
    print("call fetch event!")
    guard let url = URL(string: itemsEndpoint) else {return}
    let task = URLSession.shared.dataTask(with: url){(data,response,error) in
      do{
        guard let data = data else{return}
        let items = try JSONDecoder().decode(Items.self,from: data)
        DispatchQueue.main.async {
          self.items = items
        }
      }catch{
        print("error")
      }
    }
    task.resume()
  }
  
  func createItem(newdata: Item) {
    print("call create event!!")
    guard let url = URL(string: itemsEndpoint) else {return}
    guard let httpBody = try? JSONEncoder().encode(newdata) else {return}
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
//    request.setValue("Basic \(authBase64)", forHTTPHeaderField: "Authorization")
    request.httpBody = httpBody

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      if let data = data {
        let decoder = JSONDecoder()
        guard let decodedResponse = try? decoder.decode(Item.self, from: data) else {
          print("decoder error")
          return
        }
        self.item = decodedResponse
      } else {
        print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
      }
    }
    task.resume()
  }
  
  func fetchDetailItem(itemid: Int) {
    let itemdetailEndpoint = itemsEndpoint + String(itemid)
    guard let url = URL(string: itemdetailEndpoint) else {return}
    let request = URLRequest(url: url)

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      if let data = data {
        let decoder = JSONDecoder()
        guard let decodedResponse = try? decoder.decode(Item.self, from: data) else {
          print("decode error in detail !")
          return
        }
        DispatchQueue.main.async {
          self.item = decodedResponse
        }
      } else {
        print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        return
      }
    }
    task.resume()
  }
  
  func deleteItem(itemid: Int) {
    let itemdetailEndpoint = itemsEndpoint + String(itemid)
    guard let url = URL(string: itemdetailEndpoint) else {return}
    var request = URLRequest(url: url)
    request.httpMethod = "DELETE"

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      if let data = data {
        let decoder = JSONDecoder()
        guard let decodedResponse = try? decoder.decode(Item.self, from: data) else {
          print("decode error in detail !")
          return
        }
        DispatchQueue.main.async {
          self.item = decodedResponse
        }
      } else {
        print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        return
      }
    }
    task.resume()
  }
}

struct BookmarkView: View {
  @ObservedObject var itemData = ItemDownloader()
  @State private var name = ""
  @State var isloading = false
  @State var isShowCreate = false
  @State var isShowAlert = false
  
  var body: some View {
    ZStack {
      NavigationStack {
        List(self.itemData.items) { item in
          NavigationLink(destination: BookmarkDetailView(itemid: item.id ?? 0)) {
            VStack(alignment: .leading) {
              HStack {
                Text(String(item.id ?? 0))
                Text(item.title ?? "")
                  .font(.headline)
              }
              HStack {
                Text(item.url ?? "")
              }
              HStack {
                Text(item.description ?? "")
                Text(item.name ?? "nil")
              }
            }
          }
        }
        .navigationTitle("Bookmarks (\(itemData.items.count))")
        .toolbar {
          ToolbarItem(placement: .navigationBarLeading) {
            Button { self.itemData.fetchItem() } label: {
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
    isloading = true
    self.itemData.fetchItem()
    isloading = false
  }
}

struct CreateView: View {
  @ObservedObject var itemData = ItemDownloader()
  @State private var input = ItemInput(
    url: "hoge",
    title: "huga",
    description: "foooo",
    tag_id: "3"
  )
  @State private var message = "none"
  
  var body: some View {
    NavigationStack {
      Form {
        TextField("url...", text: Binding($input.url)!)
          .textFieldStyle(RoundedBorderTextFieldStyle())
        TextField("title...", text: Binding($input.title)!)
          .textFieldStyle(RoundedBorderTextFieldStyle())
        TextField("description...", text: Binding($input.description)!)
          .textFieldStyle(RoundedBorderTextFieldStyle())
        TextField("tagid...", text: Binding($input.tag_id)!)
          .textFieldStyle(RoundedBorderTextFieldStyle())
        Button("Create") { createData() }
        Text("message: \(message)")
      }.navigationBarTitle("CreateView")
    }
  }
  
  func createData() {
    let newdata: Item = .init(
      url: input.url,
      title: input.title,
      description: input.description,
      tag_id: Int(input.tag_id ?? "0")
    )
    
    self.itemData.createItem(newdata: newdata)

    message = "success!!"
    input.url = ""
    input.title = ""
    input.description = ""
    input.tag_id = ""
  }
}

struct BookmarkDetailView: View {
  @Environment(\.presentationMode) var presentation
  @ObservedObject var itemData = ItemDownloader()
  @State var isShowAlert = false
  var itemid: Int

  var body: some View {
    NavigationStack {
      VStack(alignment: .leading) {
        HStack {
          Text("id : ")
          Text(String(self.itemData.item.id ?? 0))
        }
        HStack {
          Text("url : ")
          Text(self.itemData.item.url ?? "")
        }
        VStack {
          HStack {
            Text("title : ")
            Text(self.itemData.item.title ?? "")
          }
          HStack {
            Text("description : ")
            Text(self.itemData.item.description ?? "")
          }
        }.padding()
        HStack {
          Text("tag : ")
          Text(self.itemData.item.name ?? "")
        }
        HStack {
          Text("tag id : ")
          Text(String(self.itemData.item.tag_id ?? 0))
        }
      }
      .navigationTitle(self.itemData.item.title ?? "")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button { deleteData() } label: {
            Image(systemName: "trash")
          }
        }
        ToolbarItem(placement: .navigationBarTrailing) {
          Button { isShowAlert = true } label: {
            Image(systemName: "arrow.triangle.2.circlepath")
          }
        }
      }
    }
    .onAppear(perform: getDetailData)
    .alert(isPresented: $isShowAlert) {
      Alert(title: Text("comming soon ..."))
    }
  }
  
  func getDetailData() {
    print("call detail item !!")
    self.itemData.fetchDetailItem(itemid: itemid)
  }

  func deleteData() {
    print("call delete item !!")
    self.itemData.deleteItem(itemid: itemid)
    self.presentation.wrappedValue.dismiss()
  }
}

struct BookmarkView_Previews: PreviewProvider {
  static var previews: some View {
    BookmarkView()
  }
}
