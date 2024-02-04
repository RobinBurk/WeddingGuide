import SwiftUI
import Firebase
import Foundation
import Photos
import SDWebImageSwiftUI
import Firebase

class DataManager: ObservableObject {
    private let db = Firestore.firestore()
    
    @Published var imageUrlsAnzug = [String]()
    @Published var imageUrlsBrautstrauss = [String]()
    @Published var imageUrlsHochzeitskleid = [String]()
    @Published var imageUrlsDekoration = [String]()
    @Published var imageUrlsFrisuren = [String]()
    
    func loadImages(name: String, appendAction: @escaping (String) -> Void, completion: @escaping (Bool, String) -> Void) {
        db.collection(name).getDocuments { (snapshot, error) in
            if let error = error {
                completion(false, "Error getting documents: \(error)")
            } else {
                for document in snapshot!.documents {
                    if let url = document.data()["url"] as? String {
                        appendAction(url)
                    }
                }
                completion(true, "")
            }
        }
    }
    
    func downloadAndSaveImage(url: String) {
        guard let imageURL = URL(string: url) else {return}
        PHPhotoLibrary.shared().performChanges {
            URLSession.shared.dataTask(with: imageURL) {(data, response, error) in
                guard let data = data, error == nil else {return}
                PHPhotoLibrary.shared().performChanges({
                    let creationRequest = PHAssetCreationRequest.forAsset()
                    let options = PHAssetResourceCreationOptions()
                    options.shouldMoveFile = true
                    creationRequest.addResource(with: .photo, data: data, options: options)
                },completionHandler: {(success, error) in
                    if success {
                        print("Image saved to Photos")
                    } else if let error = error {
                        print("Error saving image to Photos: \(error)")
                    }
                }
                )
            }.resume()
        }
    }
}


