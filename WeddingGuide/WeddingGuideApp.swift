import SwiftUI
import Firebase
import UIKit

@main
struct WeddingGuideApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject var networkMonitor = NetworkMonitor()
    @StateObject private var userModel = UserViewModel()
    @StateObject private var dataManager = DataManager()
    
    var body: some Scene {
        WindowGroup {
            VideoView()
                .preferredColorScheme(.light)
                .environmentObject(userModel)
                .environmentObject(dataManager)
                .environmentObject(networkMonitor)
        }
    }
}

class AppDelegate : NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions:
                     [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
       
        return true
    }
}
