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
        FirstView().tabItem {
            Text("Command")
            Image(systemName: "command")
        }
        SecondView().tabItem {
            Text("Shift")
            Image(systemName: "shift")
        }
        ThirdView().tabItem {
            Text("Option")
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
