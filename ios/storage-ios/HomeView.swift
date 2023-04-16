//
//  HomeView.swift
//  storage-ios
//
//  Created by 浜崎優一 on 2023/04/17.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
      NavigationStack {
        VStack {
          Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .font(.title)
            .padding()
          Text("Go to page !!")
        }
        .navigationTitle("Home")
      }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
