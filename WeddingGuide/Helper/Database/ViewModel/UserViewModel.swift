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
    
    func autoLogin() {
        if userIsAuthenticated {
            sync()
        }
    }
}
