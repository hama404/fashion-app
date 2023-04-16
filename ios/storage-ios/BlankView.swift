//
//  BlankView.swift
//  storage-ios
//
//  Created by 浜崎優一 on 2023/04/16.
//

import SwiftUI

struct BlankView: View {
  var name = "Hello, World!!"
  var body: some View {
    VStack {
      Text(name)
        .font(.title)
        .padding()
      Text("coming soon ...")
    }
  }
}

struct BlankView_Previews: PreviewProvider {
  static var previews: some View {
    BlankView()
  }
}
