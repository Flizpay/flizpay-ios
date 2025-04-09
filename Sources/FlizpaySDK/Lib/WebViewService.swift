import UIKit
import SafariServices

public class FlizpayWebView: UIViewController {
    
    public var redirectUrl: URL?
    public var urlScheme: String?

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard let url = redirectUrl else { return }
        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .fullScreen
        present(safariVC, animated: true, completion: nil)
    }

    public func present(from presentingVC: UIViewController, redirectUrl: String, urlScheme: String, jwt: String) {
        let flizpayWebView = FlizpayWebView()
        let redirectUrlWithJwtToken = "\(redirectUrl)&jwt=\(jwt)&redirect-url=\(urlScheme)"
        
        flizpayWebView.redirectUrl = URL(string: redirectUrlWithJwtToken)
        flizpayWebView.urlScheme = urlScheme
        presentingVC.present(flizpayWebView, animated: true, completion: nil)
    }
}
