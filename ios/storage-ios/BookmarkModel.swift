//
//  File.swift
//  storage-ios
//
//  Created by 浜崎優一 on 2023/04/21.
//

import Foundation

struct Bookmark: Codable, Identifiable {
  var id: Int?
  var url: String?
  var title: String?
  var description: String?
  var name: String?
  var tag_id: Int?
}

struct BookmarkInput: Codable {
  var url: String?
  var title: String?
  var description: String?
  var tag_id: String?
}

typealias Bookmarks = [Bookmark]

let bookmarksEndpoint = "https://fashion-app-z2zcp4g4ca-uw.a.run.app/api/v1/items/"
//let bookmarksEndpoint = "http://localhost:8080/api/v1/items/"

class BookmarksDownloader: ObservableObject {
  @Published var items: Bookmarks = [Bookmark]()
  @Published var item: Bookmark = Bookmark()

  init() {
    print("call observable init!")
  }
  
  func fetchItem() {
    print("call fetch event!")
    guard let url = URL(string: bookmarksEndpoint) else {return}
    let task = URLSession.shared.dataTask(with: url){(data,response,error) in
      do{
        guard let data = data else{return}
        let items = try JSONDecoder().decode(Bookmarks.self,from: data)
        DispatchQueue.main.async {
          self.items = items
        }
      }catch{
        print("error")
      }
    }
    task.resume()
  }
  
  func createItem(newdata: Bookmark) {
    print("call create event!!")
    guard let url = URL(string: bookmarksEndpoint) else {return}
    guard let httpBody = try? JSONEncoder().encode(newdata) else {return}
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
//    request.setValue("Basic \(authBase64)", forHTTPHeaderField: "Authorization")
    request.httpBody = httpBody

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      if let data = data {
        let decoder = JSONDecoder()
        guard let decodedResponse = try? decoder.decode(Bookmark.self, from: data) else {
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
    let itemdetailEndpoint = bookmarksEndpoint + String(itemid)
    guard let url = URL(string: itemdetailEndpoint) else {return}
    let request = URLRequest(url: url)

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      if let data = data {
        let decoder = JSONDecoder()
        guard let decodedResponse = try? decoder.decode(Bookmark.self, from: data) else {
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
    let itemdetailEndpoint = bookmarksEndpoint + String(itemid)
    guard let url = URL(string: itemdetailEndpoint) else {return}
    var request = URLRequest(url: url)
    request.httpMethod = "DELETE"

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      if let data = data {
        let decoder = JSONDecoder()
        guard let decodedResponse = try? decoder.decode(Bookmark.self, from: data) else {
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

