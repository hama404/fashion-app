//
//  ContentView.swift
//  storage-ios
//
//  Created by 浜崎優一 on 2023/04/13.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    TabView {
      HomeView().tabItem {
        Text("Bookmark")
        Image(systemName: "house")
      }
      BookmarkView().tabItem {
        Text("Bookmark")
        Image(systemName: "bookmark")
      }
      BlankView(name: "Music Translate").tabItem {
        Text("Music Translate")
        Image(systemName: "command")
      }
      BlankView(name: "Guitar Code").tabItem {
        Text("Guitar Code")
        Image(systemName: "shift")
      }
      BlankView(name: "Musical Score").tabItem {
        Text("Musical Score")
        Image(systemName: "option")
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
