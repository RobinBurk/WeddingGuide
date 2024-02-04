import Foundation
import MessageUI

class EmailService: NSObject, MFMailComposeViewControllerDelegate {
    public static let shared = EmailService()
    
    func sendEmail(subject:String, body:String, to:String, completion: @escaping (Bool) -> Void) {
        if MFMailComposeViewController.canSendMail(){
            let picker = MFMailComposeViewController()
            picker.setSubject(subject)
            picker.setMessageBody(body, isHTML: true)
            picker.setToRecipients([to])
            picker.mailComposeDelegate = self
            
            UIApplication.shared.windows.first?.rootViewController?.present(picker,  animated: true, completion: nil)
        }
        completion(MFMailComposeViewController.canSendMail())
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
