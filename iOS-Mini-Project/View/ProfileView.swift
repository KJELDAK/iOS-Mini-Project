
import SwiftUI

struct ProfileView: View {

        @State private var isOn: Bool = false
    @EnvironmentObject var articalViewModel : ArticalViewModel
    
    @Binding var language: String
    var body: some View {
        VStack{
            Image("cover").resizable().scaledToFit()
                .overlay(
                    Image("profile").resizable().frame(width: 85,height: 85).clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        .background(
                            Circle().stroke(LinearGradient(colors: [.purple,.purple, .red, .orange, .yellow,.purple,.purple], startPoint: .bottomTrailing, endPoint: .topLeading), lineWidth: 7)
                        )

                        .offset(y:110)
                                        )
                
            Text(LocalizedStringKey(articalViewModel.userNme)).padding(.top,42).font(.title2).bold()
            VStack(alignment:.leading){
                Text("Little About me").font(.title2.bold())
                Text("It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is ").padding(.top)
                Spacer()
                Text("Language Setting").font(.title2.bold())
                HStack{
                    Text("KH")
                    Toggle(isOn: $isOn){
                     
                    }.frame(width: 50)
                    Text("EN").padding()
                        .onChange(of: isOn) { value in
                            language = value ? "en" : "km"
                        }
                   
                }
            }.frame(maxWidth: .infinity,alignment: .leading).padding()
            Button{
                
            }label: {
                Text("Log out").font(.title2).frame(maxWidth: .infinity,maxHeight: 40).background(.red).cornerRadius(5).foregroundColor(.white).padding(.horizontal)
            }
            Text("")
            Text("")
            
            Spacer()
        }.edgesIgnoringSafeArea(.top)
    }
}

#Preview {
    ProfileView(language: .constant("km")).environmentObject(ArticalViewModel())
}
