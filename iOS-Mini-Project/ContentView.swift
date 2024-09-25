//
//  ContentView.swift
//  iOS-Mini-Project
//
//  Created by MacBook Pro on 17/9/24.
//

import SwiftUI

struct ContentView: View {
    @State var language: String = "km"
    @StateObject var articalViewModel = ArticalViewModel()
    @State var isSlected = false
    var body: some View {
        TabView {
            HomeView() .tabItem {
                Label("Home", systemImage: "house")
            }
            PostView(language : $language)
                .tabItem {
                    Label("Post", systemImage: "plus.app.fill")
                }.environment(\.locale, .init(identifier: language))
            ProfileView(language: $language).environment(\.locale, .init(identifier: language))
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
        .environmentObject(articalViewModel)
        
    }
}


#Preview {
    ContentView()
}
