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
    
    @Published var serviceProviderGroups: [ServiceProviderGroup] = []
    @Published var imagesUrlsServiceProviders = [[String]]()
    
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
    
    func loadServiceProviders(completion: @escaping (Bool, String) -> Void) {
        let collectionRef = db.collection("service_providers")
        
        collectionRef.getDocuments { snapshot, error in
            if let error = error {
                completion(false, "Error fetching documents: \(error.localizedDescription)")
            } else {
                guard let documents = snapshot?.documents else {
                    completion(false, "No documents found")
                    return
                }
                
                var serviceProviderGroups: [ServiceProviderGroup] = []
                for document in documents {
                    let data = document.data()
                    let title = String(document.documentID.uppercased().dropFirst(2))
                    var providerGroup = ServiceProviderGroup(title: title)
                    
                    // For each document in data.
                    for map in data.values {
                        if let mapData = map as? [String: Any] {
                            var title: String = ""
                            var imageName: String = ""
                            var address: String = ""
                            var description: String = ""
                            var email: String = ""
                            var telephone: String = ""
                            
                            for (key, value) in mapData {
                                switch key {
                                case "title":
                                    if let titleTemp = value as? String {
                                        title = titleTemp
                                    }
                                case "imageName":
                                    if let imageNameTemp = value as? String {
                                        imageName = imageNameTemp
                                    }
                                case "address":
                                    if let addressTemp = value as? String {
                                        address = addressTemp
                                    }
                                case "description":
                                    if let descriptionTemp = value as? String {
                                        description = descriptionTemp
                                    }
                                case "email":
                                    if let emailTemp = value as? String {
                                        email = emailTemp
                                    }
                                case "telephone":
                                    if let telephoneTemp = value as? String {
                                        telephone = telephoneTemp
                                    }
                                default:
                                    break
                                }
                            }
                            
                            let provider = ServiceProvider(address: address, description: description, email: email, imageName: imageName, telephone: telephone, title: title)
                            providerGroup.serviceProviders.append(provider)
                        }
                    }
                    serviceProviderGroups.append(providerGroup)
                }
                self.serviceProviderGroups = serviceProviderGroups
                completion(true, "Service providers loaded successfully")
            }
        }
    }
    
    func loadImagesServiceProvider(name: String, completion: @escaping (Bool, String) -> Void) {
        db.collection(name).getDocuments { (snapshot, error) in
            if let error = error {
                completion(false, "Error getting documents: \(error)")
            } else {
                for document in snapshot!.documents {
                    if let url = document.data()["url"] as? String {
                        // Add document.id and url to list.
                        let documentID = document.documentID
                        self.imagesUrlsServiceProviders.append([documentID, url])
                    }
                }
                completion(true, "")
            }
        }
    }
}


