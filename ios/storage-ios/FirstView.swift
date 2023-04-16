//
//  FirstUIView.swift
//  storage-ios
//
//  Created by 浜崎優一 on 2023/04/14.
//

import SwiftUI

struct FirstView: View {
  @State private var isPresented: Bool = false
  var body: some View {
    NavigationStack {

      NavigationLink {
        NextView()
      } label: {
        Text("Go Page")
          .navigationTitle("Home")
          .padding()
      }

      Button("NextViewへ") {
        isPresented = true
      }
      .sheet(isPresented: $isPresented) { //フルスクリーンの画面遷移
        NextView()
      }
    }
  }
}

struct NextView: View {
  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundColor(.accentColor)
      Text("Connect My IphoneXs!")
      Text("SecondView").font(.title)
      
      NavigationStack {
        NavigationLink {
          NextView()
        } label: {
          Text("Go Page")
        }
      }
      NavigationStack {
        NavigationLink {
          NextView()
        } label: {
          Text("Go Page")
        }
      }
    }.padding()
  }
}

struct FirstUIView_Previews: PreviewProvider {
  static var previews: some View {
    FirstView()
  }
}
