import SwiftUI
import SafariServices

struct scrollPreKey: PreferenceKey {
    static var defaultValue:CGFloat = 0
    static func reduce (value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

func openURL(url: String) {
    guard let url = URL(string: url) else { return }
    
    if #available(iOS 15.0, *) {
        UIApplication.shared.open(url)
    } else {
        let safariViewController = SFSafariViewController(url: url)
        UIApplication.shared.windows.first?.rootViewController?.present(safariViewController, animated: true, completion: nil)
    }
}

func createEmailURL(recipient: String, subject: String, body: String) -> URL? {
    let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    
    let gmailUrl = URL(string: "googlegmail://co?to=\(recipient)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
    let outlookUrl = URL(string: "ms-outlook://compose?to=\(recipient)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
    let yahooMail = URL(string: "ymail://mail/compose?to=\(recipient)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
    let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(recipient)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
    let gmxUrl = URL(string: "gomobilemail://mail?to=\(recipient)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
    let webdeUrl = URL(string: "webdeMail://compose?to=\(recipient)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
    let aolMailUrl = URL(string: "aolmail://mail/compose?to=\(recipient)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
    let mailruUrl = URL(string: "mailru://compose?to=\(recipient)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
    let defaultUrl = URL(string: "mailto:\(recipient)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
    
    if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
        return gmailUrl
    } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
        return outlookUrl
    } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
        return yahooMail
    } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
        return sparkUrl
    } else if let gmxUrl = gmxUrl, UIApplication.shared.canOpenURL(gmxUrl) {
        return gmxUrl
    } else if let webdeUrl = webdeUrl, UIApplication.shared.canOpenURL(webdeUrl) {
        return webdeUrl
    } else if let aolMailUrl = aolMailUrl, UIApplication.shared.canOpenURL(aolMailUrl) {
        return aolMailUrl
    } else if let mailruUrl = mailruUrl, UIApplication.shared.canOpenURL(mailruUrl) {
        return mailruUrl
    }
    
    return defaultUrl
}

extension Color {
    init(hex: UInt) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double(hex & 0xFF) / 255.0
        )
    }
}

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
