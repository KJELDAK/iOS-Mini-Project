//
//  ArticalDetailsView.swift
//  iOS-Mini-Project
//
//  Created by MacBook Pro on 18/9/24.
//

import SwiftUI
import Kingfisher

struct ArticalDetailsView: View {
    let post: Payload

    var body: some View {
        let imageURL = "http://110.74.194.123:8080/api/v1/images?fileName=" + post.imageUrl
        ScrollView{
            VStack(alignment: .leading){
                KFImage(URL(string: imageURL))
                    .resizable()
                    .placeholder {
                        Text("Loading...")
                    }
                    .scaledToFit()
                    
                Text(post.title)
                    .font(.system(size: 25))
                    .bold()
                    .padding(.top)
                HStack {
                    Text("Written by: ")
                    Text(post.author)
                    Spacer()
                    Text(post.publishedDate)
                }
                .font(.subheadline)
                .foregroundColor(.gray)
                    Text(post.content)
                Spacer()
            } .padding()
        }
        .scrollIndicators(.hidden)
    }
}

//#Preview {
//    ArticalDetailsView()
//}
