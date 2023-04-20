//
//  File.swift
//  storage-ios
//
//  Created by 浜崎優一 on 2023/04/21.
//

import Foundation

struct Tag: Codable, Identifiable, Hashable {
  var id: Int?
  var name: String?
}

typealias Tags = [Tag]

let tagsEndpoint = "https://fashion-app-z2zcp4g4ca-uw.a.run.app/api/v1/tags/"
//let tagsEndpoint = "http://localhost:8080/api/v1/tags/"

class TagsDownloader: ObservableObject {
  @Published var tags: Tags = [Tag]()

  init() {
    print("call observable init!")
  }
  
  func fetchTag() {
    print("call fetch event!")
    guard let url = URL(string: tagsEndpoint) else {return}
    let task = URLSession.shared.dataTask(with: url){(data,response,error) in
      do{
        guard let data = data else{return}
        let tags = try JSONDecoder().decode(Tags.self,from: data)
        DispatchQueue.main.async {
          self.tags = tags
        }
      }catch{
        print("error")
      }
    }
    task.resume()
  }
}

