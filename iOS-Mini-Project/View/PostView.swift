import SwiftUI
import PhotosUI
import Alamofire
import UIKit

@MainActor
final class PhotoPicker: ObservableObject {
    @Published var selectImage: UIImage? = nil {
        didSet {
            if let image = selectImage {
                // Notify the view when an image is selected
                onImageSelected?(image)
            }
        }
    }
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            setImage(from: imageSelection)
        }
    }
    
    // Add a callback function to notify when an image is selected
    var onImageSelected: ((UIImage) -> Void)?
    
    private func setImage(from selection: PhotosPickerItem?) {
        guard let selection else { return }
        
        Task {
            if let data = try? await selection.loadTransferable(type: Data.self) {
                if let uiImage = UIImage(data: data) {
                    selectImage = uiImage
                }
            }
        }
    }
}

struct PostView: View {
    @EnvironmentObject var articalViewModel : ArticalViewModel
    @StateObject private var viewModel = PhotoPicker()
    @State var profileImage: Data?
    @State var data: apiresponse?
    @State var title: String = ""
    @State var content: String = ""
    @Binding var language: String
    @State var isSuccess: Bool = false
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading , spacing: 2) {
                ZStack {
                    if let image = viewModel.selectImage {
                        Image(uiImage: image)
                            .resizable()
                            .frame(maxWidth: .infinity, maxHeight: 220)
                            .padding()
                    }
                    PhotosPicker(selection: $viewModel.imageSelection, matching: .images) {
                        ZStack {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.gray)
                                .opacity(viewModel.selectImage == nil ? 1 : 0)
                            VStack { }
                            .frame(maxWidth: .infinity, maxHeight: 220)
                            .background(.gray.opacity(viewModel.selectImage == nil ?  0.3 : 0))
                        }
                    }
                    .padding([.top])
                }
                
                Text("Title")
                    .font(.title2)
                    
                TextField("Enter Title", text: $title)
                    .padding(6)
                    .border(Color.gray.opacity(0.3), width: 1)
                
                Text("Description")
                    .font(.title2)
                TextEditor(text: $content)
                    .border(Color.gray.opacity(0.3), width: 1)
                    .frame(height: 180)
                Button {
                    if viewModel.selectImage == nil {
                        alertMessage = "Please select an image."
                        showAlert = true
                        isSuccess = false
                    }
                    else if title.isEmpty {
                        alertMessage = "Title cannot be empty."
                        showAlert = true
                        isSuccess = false
                    }
                    else if content.isEmpty {
                        alertMessage = "Content cannot be empty."
                        showAlert = true
                        isSuccess = false
                    }
                    else if let imageUrl = data?.imageName {
                        postNewArticle(title: title, content: content, imageUrl: imageUrl, author: language == "en" ? "Kim Minji" : "គីម មីនជី", publishedDate: getCurrentDate())
                        alertMessage = "Post successfully created"
                        isSuccess = true
                        showAlert = true
                        
                    }
                   
                }label: {
                    Text("Post")
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: 60)
                        .background(.blue)
                        .cornerRadius(5)
                        
                }.padding([.top, .horizontal])
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text(isSuccess ? "Success" : "Erorr"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                                   }
                Spacer()
            }
            .padding(.horizontal)
            .navigationTitle("Post Article")
        }
        .onAppear {
            // Set the callback to handle image upload after selection
            viewModel.onImageSelected = { image in
                if let imageData = image.jpegData(compressionQuality: 0.2) {
                    uploadFile(image: imageData)
                }
            }
        }
    }
    
    func uploadFile(image: Data) {
        let baseUrl = "http://110.74.194.123:8080/api/v1/images/upload"
        let headers: HTTPHeaders = ["Content-Type": "multipart/form-data"]
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(image, withName: "file", fileName: "image.png", mimeType: "image/png")
        }, to: baseUrl, headers: headers).responseJSON { response in
            switch response.result {
            case .success(_):
                print(response.result)
                if let responseData = response.data {
                    let res = try? JSONDecoder().decode(apiresponse.self, from: responseData)
                    self.data = res
                    
                }
            case .failure(let error):
                print("Upload failed with error: \(error)")
            }
        }
    }
    
    func postNewArticle(title: String, content: String, imageUrl: String, author: String, publishedDate: String) {
        let parameters: [String: Any] = [
            "title": title,
            "content": content,
            "imageUrl": imageUrl,
            "author": author,
            "publishedDate": publishedDate,
            "views": 1,
            "isPublished": true
        ]
        
        AF.request("http://110.74.194.123:8080/api/v1/articles", method: .post, parameters: parameters,
                   encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                
                clearForm()
                print(value)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func clearForm() {
        title = ""
        content = ""
        viewModel.selectImage = nil
        data = nil  
    }
    
    func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: Date())
    }
}

struct apiresponse: Codable {
    let imageName: String
    let type: String
    let size: Int
}

