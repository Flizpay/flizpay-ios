import UIKit
import WebKit

/// The FlizpayWebView class.
/// This class is responsible for presenting the payment web view.
/// It fetches the transaction info from FLIZpay and presents the payment web view.
public class FlizpayWebView: UIViewController {
    
    public var redirectUrl: URL?
    internal var webView: WKWebView?
    internal var webViewBridge: WebViewBridgeProtocol?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        
        if let url = redirectUrl {
            let request = URLRequest(url: url)
            webView?.load(request)
        }
    }

    /// Presents the payment web view.
    /// - Parameters:
    ///  - presentingVC: The UIViewController from which to present the payment web view.
    ///  - redirectUrl: The redirect URL for the payment web view.
    ///  - jwt: The JWT token fetched by the host app.
    public func present(from presentingVC: UIViewController, redirectUrl: String, jwt: String) {
        let flizpayWebView = FlizpayWebView()
        let redirectUrlWithJwtToken = "\(redirectUrl)&jwt=\(jwt)"
        
        flizpayWebView.redirectUrl = URL(string: redirectUrlWithJwtToken)
        presentingVC.present(flizpayWebView, animated: true, completion: nil)
    }

    internal func setupWebView() {
        let config = WKWebViewConfiguration()
        let contentController = WKUserContentController()
        config.userContentController = contentController
        config.preferences.javaScriptEnabled = true

        let wv = WKWebView(frame: .zero, configuration: config)
        wv.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(wv)

        NSLayoutConstraint.activate([
            wv.topAnchor.constraint(equalTo: view.topAnchor),
            wv.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            wv.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            wv.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        self.webView = wv
        self.webViewBridge = WebViewBridge(webView: wv)
        self.webViewBridge?.register(in: contentController)
        self.webViewBridge?.injectJavaScriptInterface()
    }
}
