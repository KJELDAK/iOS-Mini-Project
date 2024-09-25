//
//  ArticalCard.swift
//  iOS-Mini-Project
//
//  Created by MacBook Pro on 17/9/24.
//

import SwiftUI
import Kingfisher
struct ArticalCard: View {
    var image: String
    var title: String
    var description: String
    var authhor: String
    var date: String
    var body: some View {
        let imageURL = "http://110.74.194.123:8080/api/v1/images?fileName=" + image
        HStack{
            VStack{
                KFImage(URL(string: imageURL))
                    .resizable()
                    .placeholder {
                        Image("Image").resizable().frame(width: 110, height: 110)
                    }
            }
                .frame(width: 110, height: 110)
            
            VStack (alignment: .leading , spacing: 16){
                Text(title)
                    .font(.title2.bold())
                   
                Text(description)
                    .font(.title3)
                    .foregroundColor(.gray)
                    
                
                HStack{
                    Text(authhor)
                        
                    Text(date)
                }.font(.subheadline)
                    .foregroundColor(.gray)
                    
            }.padding(.leading)
        }.frame(maxWidth: .infinity, maxHeight: 140 , alignment: .leading)
            .lineLimit(1)
    }
}
#Preview {
    ArticalCard(image: "83306f18-4a79-4784-88bf-b44c27680dd6.jpeg", title: "hello ", description: "nnjkennjkerj" , authhor:"askbsujkd kjfbjkkjs" , date: "ajkngk")
}
   

