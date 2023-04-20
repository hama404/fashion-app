//
//  File.swift
//  storage-ios
//
//  Created by 浜崎優一 on 2023/04/21.
//

import Foundation

func createShareData(url: URL) {
  let newdata: BookmarkShare = .init(
    url: url.absoluteString,
    title: "from share",
    description: "i am from share extension",
    tag_id: 1
  )
  
  createShareItem(newdata: newdata)
}


struct BookmarkShare: Codable, Identifiable {
  var id: Int?
  var url: String?
  var title: String?
  var description: String?
  var name: String?
  var tag_id: Int?
}

let BookmarkSharesEndpoint = "https://fashion-app-z2zcp4g4ca-uw.a.run.app/api/v1/items/"

func createShareItem(newdata: BookmarkShare) {
  print("call create event!!")
  guard let url = URL(string: BookmarkSharesEndpoint) else {return}
  guard let httpBody = try? JSONEncoder().encode(newdata) else {return}
  var request = URLRequest(url: url)
  request.httpMethod = "POST"
  request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
//    request.setValue("Basic \(authBase64)", forHTTPHeaderField: "Authorization")
  request.httpBody = httpBody

  let task = URLSession.shared.dataTask(with: request) { data, response, error in
    if let data = data {
      let decoder = JSONDecoder()
      guard let decodedResponse = try? decoder.decode(BookmarkShare.self, from: data) else {
        print("decoder error")
        return
      }
//      self.item = decodedResponse
    } else {
      print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
    }
  }
  task.resume()
}
