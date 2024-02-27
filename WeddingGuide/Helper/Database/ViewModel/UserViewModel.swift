import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class UserViewModel: ObservableObject {
    // MARK: State
    @Published var user: User?
    
    // MARK: Properties
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    var uuid: String? {
        auth.currentUser?.uid
    }
    
    var userIsAuthenticated: Bool {
        auth.currentUser != nil
    }
    
    var userIsAuthenticatedAndSynced: Bool {
        user != nil && self.userIsAuthenticated
    }
    
    enum FirestoreError: Error {
        case noSnapshot
        case notAuthenticated
    }
    
    // MARK: Firebase Auth Functions
    func signIn(email: String, password: String, completion: @escaping (NSError?) -> Void) {
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                let authError = error as NSError
                print(authError.code)
                
                guard result != nil else {
                    print("Sign-in error: \(authError.localizedDescription)")
                    completion(authError)
                    return
                }
            }
            
            // Successfully authenticated the user, now attempting to sync with Firestore
            DispatchQueue.main.async {
                self?.sync()
                completion(nil)  // Pass the NSError to the completion block
            }
        }
    }
    
    func signUp(email: String, firstName: String, lastName: String, password: String, completion: @escaping (NSError?) -> Void) {
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                let authError = error as NSError
                print(authError.code)
                guard result != nil else {
                    print("Sign-up error: \(authError.localizedDescription)")
                    completion(authError)
                    return
                }
            }
            
            DispatchQueue.main.async {
                self?.add(User(firstName: firstName, lastName: lastName, email: email))
                self?.sync()
                completion(nil)  // Sign-up success, no error
            }
        }
    }
    
    func signOut() {
        do {
            try auth.signOut()
            self.user = nil
        } catch {
            print("Error signing out the user: \(error)")
        }
    }
    
    // Firestore functions for User Data
    private func sync() {
        guard userIsAuthenticated else {
            return
        }
        
        db.collection("users").document(self.uuid!).getDocument { (document, error) in
            guard document != nil, error == nil else {
                return
            }
            
            do {
                try self.user = document!.data(as: User.self)
            } catch {
                print("Sync error: \(error)")
            }
        }
    }
    
    private func add(_ user: User) {
        guard userIsAuthenticated else {
            return
        }
        
        do {
            let _ = try db.collection("users").document(self.uuid!).setData(from: user)
        } catch {
            print("Error adding: \(error)")
        }
    }
    
    func update() {
        guard userIsAuthenticatedAndSynced else {
            return
        }
        
        do {
            let _ = try db.collection("users").document(self.uuid!).setData(from: self.user)
        } catch {
            print("Error updating: \(error)")
        }
    }
    
    func resetPassword(email: String, completion: @escaping (Error?) -> Void) {
        auth.sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print("Password reset error: \(error.localizedDescription)")
                completion(error)
            } else {
                print("Password reset email sent successfully.")
                completion(nil)
            }
        }
    }
    
    func updatePassword(currentPassword: String, newPassword: String, completion: @escaping (Error?) -> Void) {
        guard userIsAuthenticated else {
            completion(FirestoreError.notAuthenticated)
            return
        }
        
        guard let currentUser = Auth.auth().currentUser else {
            completion(FirestoreError.notAuthenticated)
            return
        }
        
        reauthenticate(password: currentPassword) { error in
            if let nsError = error {
                print("Password change - reauthentificate error: \(nsError.localizedDescription)")
                completion(nsError)
            } else {
                currentUser.updatePassword(to: newPassword) { error in
                    if let nsError = error {
                        print("Password change error: \(nsError.localizedDescription)")
                        completion(nsError)
                    } else {
                        print("Password change successfully.")
                        completion(nil)
                    }
                }
            }
        }
    }
    
    func updateEmail(currentPassword: String, newEmail: String, completion: @escaping (Error?) -> Void) {
        guard userIsAuthenticated else {
            completion(FirestoreError.notAuthenticated)
            return
        }
        
        guard let currentUser = Auth.auth().currentUser else {
            completion(FirestoreError.notAuthenticated)
            return
        }
        
        print(currentPassword)
        print(newEmail)
        
        if let currentUser = Auth.auth().currentUser {
            let newEmail = newEmail
            let credential = EmailAuthProvider.credential(withEmail: user?.email ?? "", password: currentPassword)
            
            // Reauthenticate the user with their current email and password
            currentUser.reauthenticate(with: credential) { authResult, error in
                if let nsError = error {
                    print("Email change - reauthenticate error: \(nsError.localizedDescription)")
                    completion(nsError)
                } else {
                    // User successfully reauthenticated, update the email
                    currentUser.updateEmail(to: newEmail) { error in
                        if let nsError = error {
                            print("Email change error: \(nsError.localizedDescription)")
                            completion(nsError)
                        } else {
                            print("Email change successfully.")
                            self.user?.email = newEmail
                            self.update()
                            completion(nil)
                        }
                    }
                }
            }
        } else {
            // No user signed in
            print("No user signed in.")
        }
    }
    
    func reauthenticate(password: String, completion: @escaping (Error?) -> Void) {
        guard userIsAuthenticated else {
            completion(FirestoreError.notAuthenticated)
            return
        }
        
        guard let currentUser = Auth.auth().currentUser else {
            completion(FirestoreError.notAuthenticated)
            return
        }
        
        let credential: AuthCredential = EmailAuthProvider.credential(withEmail: user?.email ?? "", password: password)
        currentUser.reauthenticate(with: credential) { authResult, error in
            if let error = error {
                print("Reauthentication error: \(error.localizedDescription)")
                completion(error)
            } else {
                print("User re-authenticated successfully.")
                completion(nil)
            }
        }
    }
    
    func autoLogin() {
        if userIsAuthenticated {
            sync()
        }
    }
    
    func tryToAccessVIP(startcode: String, completion: @escaping (Error?) -> Void) {
        // Überprüfen, ob der Benutzer authentifiziert ist
        guard userIsAuthenticated else {
            completion(FirestoreError.notAuthenticated)
            return
        }
        
        // Referenz auf die Firestore-Sammlung "startcodes"
        let startcodesRef = db.collection("startcodes")
        
        // Abrufen aller Dokumente in der Sammlung "startcodes"
        startcodesRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(error)
                return
            }
            
            guard let querySnapshot = querySnapshot else {
                completion(FirestoreError.noSnapshot)
                return
            }
            
            // Iterieren durch jedes Dokument in der Sammlung
            for document in querySnapshot.documents {
                // Überprüfen, ob das Feld "code" im Dokument vorhanden ist und mit dem übergebenen Startcode übereinstimmt
                if let code = document.data()["code"] as? String, code == startcode {
                    // Den VIP-Status des Benutzers setzen
                    self.user?.isVIP = true
                    self.update()
                    
                    // Löschen des Startcodes aus der Firestore-Sammlung "startcodes"
                    startcodesRef.document(document.documentID).delete { error in
                        if let error = error {
                            completion(error)
                        } else {
                            completion(nil)
                        }
                    }
                }
            }
        }
    }
}
