import SwiftUI
import Alamofire

struct HomeView: View {
    @EnvironmentObject var articalViewModel: ArticalViewModel
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .padding(.leading, 32)
                        Text("search")
                        Spacer()
                    }.listRowBackground(Color(hue: 1.0, saturation: 0.0, brightness: 0.887))
                    
                    Section {
                        ForEach(articalViewModel.posts) { post in
                            ZStack {
                                ArticalCard(image: post.imageUrl,
                                            title: post.title,
                                            description: post.content,
                                            authhor: post.author,
                                            date: post.publishedDate)
                                NavigationLink(destination: ArticalDetailsView(post: post)) {
                                    EmptyView()
                                }
                                .opacity(0)
                            }
                        }.onDelete(perform: articalViewModel.deletePost)
                    }
                }
            }
            .navigationTitle("Artical")
        }
        .onAppear{
            articalViewModel.startPolling()
        }
        .onDisappear{
            articalViewModel.stopPolling()
        }
    }
}

#Preview {
    HomeView().environmentObject(ArticalViewModel())
}
