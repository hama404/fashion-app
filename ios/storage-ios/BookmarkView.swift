//
//  BookmarkView.swift
//  storage-ios
//
//  Created by 浜崎優一 on 2023/04/14.
//

import SwiftUI

struct BookmarkView: View {
  @ObservedObject var itemData = BookmarksDownloader()
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
  @ObservedObject var itemData = BookmarksDownloader()
  @ObservedObject var tagData = TagsDownloader()
  @State private var input = BookmarkInput(
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
        Picker("tag", selection: Binding($input.tag_id)!) {
          ForEach(self.tagData.tags, id: \.self) { tag in
            Text(tag.name ?? "").tag(String(tag.id ?? 0))
          }
        }
        Button("Create") { createData() }
        Text("message: \(message)")
      }.navigationBarTitle("CreateView")
    }
    .onAppear(perform: loadData)
  }
  
  func loadData() {
    self.tagData.fetchTag()
    print(self.tagData.tags)
  }
  
  func createData() {
    let newdata: Bookmark = .init(
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
  @ObservedObject var itemData = BookmarksDownloader()
  @State var isShowAlert = false
  @State var isShowConfirm = false
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
          Button { isShowConfirm = true } label: {
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
    .alert(isPresented: $isShowConfirm) {
        Alert(title: Text("Warning!!"),
              message: Text("Delete this Data??"),
              primaryButton: .cancel(Text("Cansel")),
              secondaryButton: .destructive(
                Text("Delete"),
                action: {
                  deleteData()
                }
              )
        )
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
