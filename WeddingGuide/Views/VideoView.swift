import SwiftUI
import AVKit

struct VideoView: View {
    @State private var isVideoFinished: Bool = false
    @EnvironmentObject var userModel: UserViewModel
        
    var body: some View {
        NavigationView {
            VStack {
                if (!isVideoFinished) {
                    AutoPlayVideoView(isVideoFinished: $isVideoFinished, navigationController: navigationController)
                        .ignoresSafeArea(.all)
                        .onTapGesture {
                            isVideoFinished = true
                        }
                        .onAppear {
                            // After 1 seconds, fade out the video
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                withAnimation(.easeInOut(duration: 3.0)) {
                                    isVideoFinished = true
                                }
                            }
                        }
                } else {
                    if userModel.userIsAuthenticatedAndSynced {
                        WelcomeView().preferredColorScheme(.light)
                    } else {
                        AuthenticationView()
                            .preferredColorScheme(.light)
                    }
                }
            }
        }
        .onAppear {
            userModel.autoLogin()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
    
    private var navigationController: UINavigationController {
        let controller = UINavigationController()
        return controller
    }
}

struct AutoPlayVideoView: UIViewControllerRepresentable {
    class Coordinator: NSObject {
        var parent: AutoPlayVideoView
        @Binding var isVideoFinished: Bool
        
        init(parent: AutoPlayVideoView, isVideoFinished: Binding<Bool>) {
            self.parent = parent
            self._isVideoFinished = isVideoFinished
        }
        
        @objc func playerItemDidReachEnd(_ notification: Notification) {
            // Handle video finish.
            isVideoFinished = true
        }
    }
    
    @State private var player: AVPlayer?
    @Binding var isVideoFinished: Bool
    var navigationController: UINavigationController
    
    init(isVideoFinished: Binding<Bool>, navigationController: UINavigationController) {
        self._isVideoFinished = isVideoFinished
        self.navigationController = navigationController
    }
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let playerViewController = AVPlayerViewController()
        playVideo(playerViewController: playerViewController, context: context)
        
        return playerViewController
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // No need to update
    }
    
    private func playVideo(playerViewController: AVPlayerViewController, context: Context) {
        guard let path = Bundle.main.path(forResource: "intro", ofType: "mp4") else {
            return
        }
        
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        player.actionAtItemEnd = .none
        
        NotificationCenter.default.addObserver(
            context.coordinator,
            selector: #selector(Coordinator.playerItemDidReachEnd(_:)),
            name: .AVPlayerItemDidPlayToEndTime,
            object: nil
        )
        
        playerViewController.player = player
        playerViewController.showsPlaybackControls = false
        playerViewController.videoGravity = .resizeAspectFill
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Error setting up AVAudioSession: \(error)")
        }
        
        player.play()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self, isVideoFinished: $isVideoFinished)
    }
}

#if DEBUG
struct AutoPlayVideoView_Previews: PreviewProvider {
    static var previews: some View {
        AutoPlayVideoView(isVideoFinished: .constant(false), navigationController: UINavigationController())
    }
}
#endif
