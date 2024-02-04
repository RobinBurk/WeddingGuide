import SwiftUI
import Firebase
import Foundation
import Photos
import SDWebImageSwiftUI

enum FirestoreCollection: String {
    case loggedInUser
    case startcodes
}

class DataManager: ObservableObject {
    let db : Firestore
    @Published var circleProgress: CGFloat = 0.0
    @Published var animateCircle: Bool = false
    @Published var selectedImage: String? = nil
    
    @Published var imageUrlsAnzug = [String]()
    @Published var imageUrlsBrautstrauss = [String]()
    @Published var imageUrlsHochzeitskleid = [String]()
    @Published var imageUrlsDekoration = [String]()
    @Published var imageUrlsFrisuren = [String]()
    
    @Published var user : User
    
    init() {
        db = Firestore.firestore()
        user = User(db: db)  // Initialize user in the init method
        user.email = UserDefaults.standard.string(forKey: "email") ?? ""
        user.startCode = UserDefaults.standard.string(forKey: "startCode") ?? ""
        user.lastName = UserDefaults.standard.string(forKey: "lastName") ?? ""
        user.firstName = UserDefaults.standard.string(forKey: "firstName") ?? ""
    }
    
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
    
    func checkIfUserAlreadyExists(completion: @escaping (Bool, String) -> Void) {
        db.collection(FirestoreCollection.loggedInUser.rawValue)
            .whereField("email", isEqualTo: user.email.lowercased().trimmingCharacters(in: .whitespacesAndNewlines))
            .whereField("startCode", isEqualTo: user.startCode.lowercased().trimmingCharacters(in: .whitespacesAndNewlines))
            .getDocuments { (snapshot, error) in
                if let error = error {
                    completion(false, "Fehler beim Abrufen der Dokumente: \(error)")
                } else {
                    if let documents = snapshot?.documents, !documents.isEmpty {
                        completion(true, "")
                    } else {
                        completion(false, "") // Attention: Do not add error message
                    }
                }
            }
    }
    
    func loadUser(completion: @escaping (Bool, String) -> Void) {
        db.collection(FirestoreCollection.loggedInUser.rawValue)
            .whereField("email", isEqualTo: user.email.lowercased().trimmingCharacters(in: .whitespacesAndNewlines))
            .whereField("startCode", isEqualTo: user.startCode.lowercased().trimmingCharacters(in: .whitespacesAndNewlines))
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                    completion(false, "Fehler beim Abrufen der Dokumente: \(error)")
                } else {
                    var userLoadedSuccessfully = false
                    var loggedInUserID = ""
                    
                    guard let documents = snapshot?.documents, !documents.isEmpty else {
                        print("User not found in DB.")
                        completion(false, "")
                        return
                    }
                    
                    do {
                        for document in snapshot!.documents {
                            if let hasFinishedWelcome = document.data()["hasFinishedWelcome"] as? Bool {
                                self.user.hasFinishedWelcome = hasFinishedWelcome
                                print("hasFinishedWelcome: \(hasFinishedWelcome)")
                            }
                            if let firstName = document.data()["firstName"] as? String {
                                self.user.firstName = firstName
                                print("firstName: \(firstName)")
                            }
                            if let lastName = document.data()["lastName"] as? String {
                                self.user.lastName = lastName
                                print("lastName: \(lastName)")
                            }
                            if let weddingDayTimestamp = document.data()["weddingDay"] as? Timestamp {
                                self.user.weddingDay = weddingDayTimestamp.dateValue()
                                print("weddingDay: \(self.user.weddingDay)")
                            }
                            if let startBudget = document.data()["startBudget"] as? Double {
                                self.user.startBudget = startBudget
                                print("startBudget: \(startBudget)")
                            }
                            if let budgetItems = document.data()["budgetItems"] as? String {
                                self.user.budgetItems = try BudgetItem.fromJSONArrayString(budgetItems)
                                print("weddingDay: \(self.user.weddingDay)")
                            }
                            if let checkboxStatesBeforeWedding = document.data()["checkboxStatesBeforeWedding"] as? [Bool] {
                                self.user.checkboxStatesBeforeWedding = checkboxStatesBeforeWedding
                                print("checkboxStatesBeforeWedding: \(self.user.checkboxStatesBeforeWedding)")
                            }
                            if let checkboxStatesOnWeddingDay = document.data()["checkboxStatesOnWeddingDay"] as? [Bool] {
                                self.user.checkboxStatesOnWeddingDay = checkboxStatesOnWeddingDay
                                print("checkboxStatesOnWeddingDay: \(self.user.checkboxStatesOnWeddingDay)")
                            }
                            if let checkboxStatesPreparationBride = document.data()["checkboxStatesPreparationBride"] as? [Bool] {
                                self.user.checkboxStatesPreparationBride = checkboxStatesPreparationBride
                                print("checkboxStatesPreparationBride: \(self.user.checkboxStatesPreparationBride)")
                            }
                            if let checkboxStatesPreparationGroom = document.data()["checkboxStatesPreparationGroom"] as? [Bool] {
                                self.user.checkboxStatesPreparationGroom = checkboxStatesPreparationGroom
                                print("checkboxStatesPreparationGroom: \(self.user.checkboxStatesPreparationGroom)")
                            }
                            if let timelineItems = document.data()["timeLineItems"] as? String {
                                self.user.timeLineItems = try TimeLineItem.fromJSONArrayString(timelineItems)
                                print("timelineItems: \(self.user.timeLineItems)")
                            }
                            if let weddingMotto = document.data()["weddingMotto"] as? String {
                                self.user.weddingMotto = weddingMotto
                                print("weddingMotto: \(weddingMotto)")
                            }
                            if let dressCode = document.data()["dressCode"] as? String {
                                self.user.dressCode = dressCode
                                print("dressCode: \(dressCode)")
                            }
                            if let importantDetails = document.data()["importantDetails"] as? String {
                                self.user.importantDetails = importantDetails
                                print("importantDetails: \(importantDetails)")
                            }
                            if let addressWedding = document.data()["addressWedding"] as? String {
                                self.user.addressWedding = addressWedding
                                print("addressWedding: \(addressWedding)")
                            }
                            if let addressParty = document.data()["addressParty"] as? String {
                                self.user.addressParty = addressParty
                                print("addressParty: \(addressParty)")
                            }
                            if let namePrideAndGrum = document.data()["namePrideAndGrum"] as? String {
                                self.user.namePrideAndGrum = namePrideAndGrum
                                print("namePrideAndGrum: \(namePrideAndGrum)")
                            }
                            if let nameWitnesses = document.data()["nameWitnesses"] as? String {
                                self.user.nameWitnesses = nameWitnesses
                                print("nameWitnesses: \(nameWitnesses)")
                            }
                            if let nameChilds = document.data()["nameChilds"] as? String {
                                self.user.nameChilds = nameChilds
                                print("nameChilds: \(nameChilds)")
                            }
                            if let nameFamiliy = document.data()["nameFamiliy"] as? String {
                                self.user.nameFamiliy = nameFamiliy
                                print("nameFamiliy: \(nameFamiliy)")
                            }
                            if let groupPicturesList = document.data()["groupPicturesList"] as? String {
                                self.user.groupPicturesList = groupPicturesList
                                print("groupPicturesList: \(groupPicturesList)")
                            }
                            if let plannedActions = document.data()["plannedActions"] as? String {
                                self.user.plannedActions = plannedActions
                                print("plannedActions: \(plannedActions)")
                            }
                            if let additionalInfo = document.data()["additionalInfo"] as? String {
                                self.user.additionalInfo = additionalInfo
                                print("additionalInfo: \(additionalInfo)")
                            }
                            
                            loggedInUserID = document.documentID
                            print("*********USER ID \(loggedInUserID)")
                            userLoadedSuccessfully = true
                        }
                    } catch {
                        print("Error decoding user data: \(error)")
                        completion(false, "Fehler beim Decodieren der Benutzerdaten.")
                    }
                    
                    if userLoadedSuccessfully {
                        // Check array length to avoid index out of range.
                        self.user.checkboxStatesBeforeWedding = self.padArray(self.user.checkboxStatesBeforeWedding, to: 11)
                        self.user.checkboxStatesOnWeddingDay = self.padArray(self.user.checkboxStatesOnWeddingDay, to: 16)
                        self.user.checkboxStatesPreparationBride = self.padArray(self.user.checkboxStatesPreparationBride, to: 6)
                        self.user.checkboxStatesPreparationGroom = self.padArray(self.user.checkboxStatesPreparationGroom, to: 4)
                        
                        self.user.loggedInUserID = loggedInUserID
                        self.user.isLoggedIn = true
                        print("User loaded successfully with id \(self.user.loggedInUserID)")
                        completion(true, "")
                    }
                }
            }
    }
    
    // Function to pad array with false values if needed
    func padArray(_ array: [Bool], to count: Int) -> [Bool] {
        var paddedArray = array
        let paddingCount = max(0, count - array.count)
        paddedArray += Array(repeating: false, count: paddingCount)
        return paddedArray
    }
    
    func checkStartCode(startCode: String, completion: @escaping (Bool, String) -> Void) {
        if startCode.lowercased() == "test" {
            completion(true, "") // Test does always work.
            return
        }
        
        db.collection(FirestoreCollection.startcodes.rawValue).getDocuments { (snapshot, error) in
            if let error = error {
                print("Fehler beim Abrufen der Dokumente: \(error)")
                completion(false, "Fehler beim Abrufen der Dokumente: \(error)")
            } else {
                for document in snapshot!.documents {
                    if let code = document.data()["code"] as? String {
                        if code == startCode {
                            completion(true, "")
                            return
                        }
                    }
                }
                completion(false, "Startcode wurde nicht gefunden.")
            }
        }
    }
    
    func checkEmailAddressInUnique(email: String, completion: @escaping (Bool, String) -> Void) {
        if email.lowercased() == "test@test.de" {
            completion(true, "") // "test@test.de" does always work.
            return
        }
        
        db.collection(FirestoreCollection.loggedInUser.rawValue).getDocuments { (snapshot, error) in
            if let error = error {
                print("Fehler beim Abrufen der Dokumente: \(error)")
                completion(false, "Fehler: \(error)")
            } else {
                for document in snapshot!.documents {
                    if let emailDb = document.data()["email"] as? String {
                        if email.lowercased() == emailDb.lowercased() {
                            completion(false, "E-Mail ist bereits vergeben")
                            return
                        }
                    }
                }
                completion(true, "") // Email address not taken.
            }
        }
    }
    
    func createUserOnDb(completion: @escaping (Bool, String) -> Void) {
        self.deleteStartCode(startCode: user.startCode) { (success, error) in
            if success {
                print("Start code deletion successful")
                
                let db = Firestore.firestore()
                
                // Assuming you have a collection named "loggedInUser"
                let loggedInUserCollection = db.collection(FirestoreCollection.loggedInUser.rawValue)
                
                // Create a document with a unique identifier
                var newUserRef: DocumentReference? = nil
                newUserRef = loggedInUserCollection.addDocument(data: [
                    "hasFinishedWelcome" : self.user.hasFinishedWelcome,
                    "firstName": self.user.firstName,
                    "lastName": self.user.lastName,
                    "email": self.user.email,
                    "startCode": self.user.startCode,
                    "weddingDay": self.user.weddingDay,
                    "startBudget": self.user.startBudget,
                    "budgetItems": self.user.budgetItems,
                    "checkboxStatesBeforeWedding": self.user.checkboxStatesBeforeWedding,
                    "checkboxStatesOnWeddingDay": self.user.checkboxStatesOnWeddingDay,
                    "checkboxStatesPreparationBride": self.user.checkboxStatesPreparationBride,
                    "checkboxStatesPreparationGroom": self.user.checkboxStatesPreparationGroom,
                    "timeLineItems": self.user.timeLineItems,
                    "weddingMotto": self.user.weddingMotto,
                    "dressCode": self.user.dressCode,
                    "importantDetails": self.user.importantDetails,
                    "addressWedding": self.user.addressWedding,
                    "addressParty": self.user.addressParty,
                    "namePrideAndGrum": self.user.namePrideAndGrum,
                    "nameWitnesses": self.user.nameWitnesses,
                    "nameChilds": self.user.nameChilds,
                    "nameFamiliy": self.user.nameFamiliy,
                    "groupPicturesList": self.user.groupPicturesList,
                    "plannedActions": self.user.plannedActions,
                    "additionalInfo": self.user.additionalInfo
                ]) { error in
                    if error != nil {
                        print("Fehler ist passiert. Versuche start code erneut zu erzeugen.")
                        self.createStartCode() // Create start code again, because user cannot be created.
                        completion(false, "Startcode kann nicht erneut erzeugt werden.")
                    } else {
                        print("User document created with ID: \(newUserRef?.documentID ?? "unknown")")
                        self.user.loggedInUserID = newUserRef?.documentID ?? "unknown"
                        completion(true, "")
                    }
                }
            } else {
                print("Das Löschen vom Startcode ist fehlgeschlagen")
                completion(false, "Fehler beim Löschen des Startcodes")
            }
        }
    }
    
    func deleteStartCode(startCode: String, completion: @escaping (Bool, String) -> Void) {
        if startCode.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == "test" {
            completion(true, "") // Test does always work.
            return
        }
        
        let startCodesCollection = db.collection(FirestoreCollection.startcodes.rawValue)
        let query = startCodesCollection.whereField("code", isEqualTo: startCode)
        query.getDocuments { (snapshot, error) in
            if let error = error {
                print("Fehler beim Abrufen der Dokumente: \(error)")
                completion(false, "Fehler beim Abrufen der Dokumente: \(error)")
            } else {
                // Check if any documents are found.
                guard let documents = snapshot?.documents, !documents.isEmpty else {
                    print("Start code not found")
                    completion(false, "Startcode wurde nicht gefunden")
                    return
                }
                
                // Assuming there's only one document with the specified start code.
                let document = documents[0]
                
                // Delete the document.
                document.reference.delete { error in
                    if let error = error {
                        print("Error deleting document: \(error)")
                        completion(false, "Fehler beim Löschen des Dokuments: \(error)")
                    } else {
                        print("Startcode erfolgreich gelöscht.")
                        completion(true, "")
                    }
                }
            }
        }
    }
    
    func createStartCode() {
        if user.startCode.lowercased() == "test" {
            return // Test must not be created.
        }
        
        // Assuming you have a collection named "startcodes".
        let startCodesCollection = db.collection(FirestoreCollection.startcodes.rawValue)
        
        // Add the new start code to the Firestore collection.
        startCodesCollection.addDocument(data: ["code": user.startCode]) { error in
            if let error = error {
                print("Fehler beim Erstellen des Startcodes: \(error)")
            } else {
                print("Startcode erfolgreich erstellt: \(self.user.startCode)")
            }
        }
    }
}

class User : ObservableObject {
    var db: Firestore
    
    init(db: Firestore) {
        self.db = db
    }
    
    var lastLoggedInUserId = ""
    @Published var loggedInUserID = "" {
        didSet {
            if (loggedInUserID != lastLoggedInUserId) {
                objectDidChange(propertyName: "loggedInUserID")
                lastLoggedInUserId = loggedInUserID
            }
        }
    }
    
    private var lastIsLoggedIn = false
    @Published var isLoggedIn = false {
        didSet {
            if isLoggedIn != lastIsLoggedIn {
                objectDidChange(propertyName: "isLoggedIn")
                lastIsLoggedIn = isLoggedIn
            }
        }
    }
    
    
    private var lastHasFinishedWelcome = false
    @Published var hasFinishedWelcome = false {
        didSet {
            if (hasFinishedWelcome != lastHasFinishedWelcome) {
                objectDidChange(propertyName: "hasFinishedWelcome")
                lastHasFinishedWelcome = hasFinishedWelcome
            }
        }
    }
    
    private var lastFirstName = ""
    @Published var firstName = "" {
        didSet {
            if firstName != lastFirstName {
                objectDidChange(propertyName: "firstName")
                lastFirstName = firstName
            }
        }
    }
    
    private var lastLastName = ""
    @Published var lastName = "" {
        didSet {
            if lastName != lastLastName {
                objectDidChange(propertyName: "lastName")
                lastLastName = lastName
            }
        }
    }
    
    private var lastEmail = ""
    @Published var email = "" {
        didSet {
            if email != lastEmail {
                objectDidChange(propertyName: "email")
                lastEmail = email
            }
        }
    }
    
    private var lastStartCode = ""
    @Published var startCode = "" {
        didSet {
            if startCode != lastStartCode {
                objectDidChange(propertyName: "startCode")
                lastStartCode = startCode
            }
        }
    }
    
    private var lastWeddingDay = Date()
    @Published var weddingDay = Date() {
        didSet {
            if weddingDay != lastWeddingDay {
                objectDidChange(propertyName: "weddingDay")
                lastWeddingDay = weddingDay
            }
        }
    }
    
    private var lastStartBudget = 0.0
    @Published var startBudget = 0.0 {
        didSet {
            if startBudget != lastStartBudget {
                objectDidChange(propertyName: "startBudget")
                lastStartBudget = startBudget
            }
        }
    }
    
    
    private var lastBudgetItems: [BudgetItem] = []
    @Published var budgetItems: [BudgetItem] = [] {
        didSet {
            if budgetItems.count != lastBudgetItems.count || !budgetItems.elementsEqual(lastBudgetItems, by: { $0.id == $1.id }) {
                objectDidChange(propertyName: "budgetItems")
                lastBudgetItems = budgetItems
            }
        }
    }
    
    private var lastCheckboxStatesBeforeWedding: [Bool] = []
    @Published var checkboxStatesBeforeWedding: [Bool] = [] {
        didSet {
            if checkboxStatesBeforeWedding != lastCheckboxStatesBeforeWedding {
                objectDidChange(propertyName: "checkboxStatesBeforeWedding")
                lastCheckboxStatesBeforeWedding = checkboxStatesBeforeWedding
            }
        }
    }
    
    private var lastCheckboxStatesOnWeddingDay: [Bool] = []
    @Published var checkboxStatesOnWeddingDay: [Bool] = [] {
        didSet {
            if checkboxStatesOnWeddingDay != lastCheckboxStatesOnWeddingDay {
                objectDidChange(propertyName: "checkboxStatesOnWeddingDay")
                lastCheckboxStatesOnWeddingDay = checkboxStatesOnWeddingDay
            }
        }
    }
    
    private var lastCheckboxStatesPreparationBride: [Bool] = []
    @Published var checkboxStatesPreparationBride: [Bool] = [] {
        didSet {
            if checkboxStatesPreparationBride != lastCheckboxStatesPreparationBride {
                objectDidChange(propertyName: "checkboxStatesPreparationBride")
                lastCheckboxStatesPreparationBride = checkboxStatesPreparationBride
            }
        }
    }
    
    private var lastCheckboxStatesPreparationGroom: [Bool] = []
    @Published var checkboxStatesPreparationGroom: [Bool] = [] {
        didSet {
            if checkboxStatesPreparationGroom != lastCheckboxStatesPreparationGroom {
                objectDidChange(propertyName: "checkboxStatesPreparationGroom")
                lastCheckboxStatesPreparationGroom = checkboxStatesPreparationGroom
            }
        }
    }
    
    private var lastTimeLineItems: [TimeLineItem] = []
    @Published var timeLineItems: [TimeLineItem] = [] {
        didSet {
            if timeLineItems.count != lastTimeLineItems.count || !timeLineItems.elementsEqual(lastTimeLineItems, by: { $0.id == $1.id }) {
                objectDidChange(propertyName: "timeLineItems")
                lastTimeLineItems = timeLineItems
            }
        }
    }
    
    private var lastWeddingMotto = ""
    @Published var weddingMotto = "" {
        didSet {
            if weddingMotto != lastWeddingMotto {
                objectDidChange(propertyName: "weddingMotto")
                lastWeddingMotto = weddingMotto
            }
        }
    }
    
    private var lastDressCode = ""
    @Published var dressCode = "" {
        didSet {
            if dressCode != lastDressCode {
                objectDidChange(propertyName: "dressCode")
                lastDressCode = dressCode
            }
        }
    }
    
    private var lastImportantDetails = ""
    @Published var importantDetails = "" {
        didSet {
            if importantDetails != lastImportantDetails {
                objectDidChange(propertyName: "importantDetails")
                lastImportantDetails = importantDetails
            }
        }
    }
    
    private var lastAddressWedding = ""
    @Published var addressWedding = "" {
        didSet {
            if addressWedding != lastAddressWedding {
                objectDidChange(propertyName: "addressWedding")
                lastAddressWedding = addressWedding
            }
        }
    }
    
    private var lastAddressParty = ""
    @Published var addressParty = "" {
        didSet {
            if addressParty != lastAddressParty {
                objectDidChange(propertyName: "addressParty")
                lastAddressParty = addressParty
            }
        }
    }
    
    private var lastNamePrideAndGrum = ""
    @Published var namePrideAndGrum = "" {
        didSet {
            if namePrideAndGrum != lastNamePrideAndGrum {
                objectDidChange(propertyName: "namePrideAndGrum")
                lastNamePrideAndGrum = namePrideAndGrum
            }
        }
    }
    
    private var lastNameWitnesses = ""
    @Published var nameWitnesses = "" {
        didSet {
            if nameWitnesses != lastNameWitnesses {
                objectDidChange(propertyName: "nameWitnesses")
                lastNameWitnesses = nameWitnesses
            }
        }
    }
    
    private var lastNameChilds = ""
    @Published var nameChilds = "" {
        didSet {
            if nameChilds != lastNameChilds {
                objectDidChange(propertyName: "nameChilds")
                lastNameChilds = nameChilds
            }
        }
    }
    
    private var lastNameFamiliy = ""
    @Published var nameFamiliy = "" {
        didSet {
            if nameFamiliy != lastNameFamiliy {
                objectDidChange(propertyName: "nameFamiliy")
                lastNameFamiliy = nameFamiliy
            }
        }
    }
    
    private var lastGroupPicturesList = ""
    @Published var groupPicturesList = "" {
        didSet {
            if groupPicturesList != lastGroupPicturesList {
                objectDidChange(propertyName: "groupPicturesList")
                lastGroupPicturesList = groupPicturesList
            }
        }
    }
    
    private var lastPlannedActions = ""
    @Published var plannedActions = "" {
        didSet {
            if plannedActions != lastPlannedActions {
                objectDidChange(propertyName: "plannedActions")
                lastPlannedActions = plannedActions
            }
        }
    }
    
    private var lastAdditionalInfo = ""
    @Published var additionalInfo = "" {
        didSet {
            if additionalInfo != lastAdditionalInfo {
                objectDidChange(propertyName: "additionalInfo")
                lastAdditionalInfo = additionalInfo
            }
        }
    }
    
    func objectDidChange(propertyName: String) {
        print("User object changed in property: \(propertyName)")
        if isLoggedIn {
            updateUserDataInDatabase()
        }
    }
    
    func updateUserDataInDatabase() {
        guard !loggedInUserID.isEmpty else {
            print("Error: loggedInUserID is nil or empty")
            // Handle the error or return early
            return
        }
        
        print("Updating user data in the database.")

        let userRef = db.collection(FirestoreCollection.loggedInUser.rawValue).document(loggedInUserID)

        // Erstelle ein leeres Dictionary, um die geänderten Felder zu speichern
        var updatedFields: [String: Any] = [:]

        // Funktion zum Hinzufügen geänderter Felder zum Dictionary
        func addUpdatedField(_ key: String, _ value: Any) {
            updatedFields[key] = value
            print("Updated field '\(key)': \(value)")
        }

        // Überprüfe und füge die geänderten Felder hinzu
        if hasFinishedWelcome != lastHasFinishedWelcome {
            addUpdatedField("hasFinishedWelcome", hasFinishedWelcome)
        }

        if firstName != lastFirstName {
            addUpdatedField("firstName", firstName)
        }

        if lastName != lastLastName {
            addUpdatedField("lastName", lastName)
        }

        if email != lastEmail {
            addUpdatedField("email", email)
        }

        if startCode != lastStartCode {
            addUpdatedField("startCode", startCode)
        }

        if weddingDay != lastWeddingDay {
            addUpdatedField("weddingDay", weddingDay)
        }

        if startBudget != lastStartBudget {
            addUpdatedField("startBudget", startBudget)
        }

        if !budgetItems.elementsEqual(lastBudgetItems, by: { $0.id == $1.id }) {
            do {
                let budgetItemsData = try budgetItems.toJSONString()
                addUpdatedField("budgetItems", budgetItemsData)
            } catch {
                print("Error converting budgetItems to JSON string: \(error)")
            }
        }

        if checkboxStatesBeforeWedding != lastCheckboxStatesBeforeWedding {
            addUpdatedField("checkboxStatesBeforeWedding", checkboxStatesBeforeWedding)
        }

        if checkboxStatesOnWeddingDay != lastCheckboxStatesOnWeddingDay {
            addUpdatedField("checkboxStatesOnWeddingDay", checkboxStatesOnWeddingDay)
        }

        if checkboxStatesPreparationBride != lastCheckboxStatesPreparationBride {
            addUpdatedField("checkboxStatesPreparationBride", checkboxStatesPreparationBride)
        }

        if checkboxStatesPreparationGroom != lastCheckboxStatesPreparationGroom {
            addUpdatedField("checkboxStatesPreparationGroom", checkboxStatesPreparationGroom)
        }

        if !timeLineItems.elementsEqual(lastTimeLineItems, by: { $0.id == $1.id }) {
            // Convert time line items to json string.
            do {
                let timeLineItemsData = try timeLineItems.toJSONString()
                addUpdatedField("timeLineItems", timeLineItemsData)
            } catch {
                print("Error converting timeLineItems to JSON string: \(error)")
            }
        }

        if weddingMotto != lastWeddingMotto {
            addUpdatedField("weddingMotto", weddingMotto)
        }

        if dressCode != lastDressCode {
            addUpdatedField("dressCode", dressCode)
        }

        if importantDetails != lastImportantDetails {
            addUpdatedField("importantDetails", importantDetails)
        }

        if addressWedding != lastAddressWedding {
            addUpdatedField("addressWedding", addressWedding)
        }

        if addressParty != lastAddressParty {
            addUpdatedField("addressParty", addressParty)
        }

        if namePrideAndGrum != lastNamePrideAndGrum {
            addUpdatedField("namePrideAndGrum", namePrideAndGrum)
        }

        if nameWitnesses != lastNameWitnesses {
            addUpdatedField("nameWitnesses", nameWitnesses)
        }

        if nameChilds != lastNameChilds {
            addUpdatedField("nameChilds", nameChilds)
        }

        if nameFamiliy != lastNameFamiliy {
            addUpdatedField("nameFamiliy", nameFamiliy)
        }

        if groupPicturesList != lastGroupPicturesList {
            addUpdatedField("groupPicturesList", groupPicturesList)
        }

        if plannedActions != lastPlannedActions {
            addUpdatedField("plannedActions", plannedActions)
        }

        if additionalInfo != lastAdditionalInfo {
            addUpdatedField("additionalInfo", additionalInfo)
        }

        // Führe das Update nur durch, wenn es geänderte Felder gibt
        guard !updatedFields.isEmpty else {
            print("No changes to update.")
            return
        }

        // Führe das Update mit den geänderten Feldern durch
        userRef.updateData(updatedFields) { error in
            if let error = error {
                print("Error updating user data: \(error)")
            } else {
                print("User data updated successfully")
            }
        }
    }

    
    func setFirstName(_ firstName: String) {
        self.firstName = firstName
    }
    
    func setLastName(_ lastName: String) {
        self.lastName = lastName
    }
    
    func setEmail(_ email: String) {
        self.email = email
    }
    
    func setStartCode(_ startCode: String) {
        self.startCode = startCode
    }
    
    func setWeddingDay(_ weddingDay: Date) {
        self.weddingDay = weddingDay
    }
    
    func setStarBudget(_ startBudget: Double) {
        self.startBudget = startBudget
    }
    
    func setBudgetItems(_ budgetItems: [BudgetItem]) {
        self.budgetItems = budgetItems
    }
    
    func addBudgetItem(_ item: BudgetItem)
    {
        // Trim whitespaces of item description.
        var mutableItem = item
        mutableItem.description = mutableItem.description.trimmingCharacters(in: .whitespaces)
        
        self.budgetItems.append(mutableItem)
    }
    
    func removeBudgetItem(atOffsets indexSet: IndexSet)
    {
        self.budgetItems.remove(atOffsets: indexSet)
    }
    
    func setTimeLineItems(_ timeLineItems: [TimeLineItem]) {
        self.timeLineItems = timeLineItems
    }
    
    func addTimeLineItem(_ item: TimeLineItem) {
        // Trim whitespaces of item title.
        var mutableItem = item
        mutableItem.title = mutableItem.title.trimmingCharacters(in: .whitespaces)
        
        // Trim whitespaces of item extra.
        mutableItem.extra = mutableItem.extra.trimmingCharacters(in: .whitespaces)
        
        self.timeLineItems.append(mutableItem)
        self.timeLineItems = self.timeLineItems.sorted(by: { $0.startTime < $1.startTime })
    }
    
    func removeTimeLineItem(atOffsets indexSet: IndexSet)
    {
        self.timeLineItems.remove(atOffsets: indexSet)
    }
    
    func setWeddingMotto(_ weddingMotto: String) {
        self.weddingMotto = weddingMotto
    }
    
    func setDressCode(_ dressCode: String) {
        self.dressCode = dressCode
    }
    
    func setImportantDetails(_ importantDetails: String) {
        self.importantDetails = importantDetails
    }
    
    func setAddressWedding(_ addressWedding: String) {
        self.addressWedding = addressWedding
    }
    
    func setAddressParty(_ addressParty: String) {
        self.addressParty = addressParty
    }
    
    func setNamePrideAndGrum(_ namePrideAndGrum: String) {
        self.namePrideAndGrum = namePrideAndGrum
    }
    
    func setNameWitnesses(_ nameWitnesses: String) {
        self.nameWitnesses = nameWitnesses
    }
    
    func setNameChilds(_ nameChilds: String) {
        self.nameChilds = nameChilds
    }
    
    func setNameFamiliy(_ nameFamiliy: String) {
        self.nameFamiliy = nameFamiliy
    }
    
    func setGroupPicturesList(_ groupPicturesList: String) {
        self.groupPicturesList = groupPicturesList
    }
    
    func setPlannedActions(_ plannedActions: String) {
        self.plannedActions = plannedActions
    }
    
    func setAdditionalInfo(_ additionalInfo: String) {
        self.additionalInfo = additionalInfo
    }
}

extension Array where Element == BudgetItem {
    func toJSONString() throws -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(self)
        guard let jsonString = String(data: data, encoding: .utf8) else {
            throw EncodingError.invalidValue(self, EncodingError.Context(codingPath: [], debugDescription: "Failed to convert data to string"))
        }
        return jsonString
    }
}

extension Array where Element == TimeLineItem {
    func toJSONString() throws -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(self)
        guard let jsonString = String(data: data, encoding: .utf8) else {
            throw EncodingError.invalidValue(self, EncodingError.Context(codingPath: [], debugDescription: "Failed to convert data to string"))
        }
        return jsonString
    }
}
