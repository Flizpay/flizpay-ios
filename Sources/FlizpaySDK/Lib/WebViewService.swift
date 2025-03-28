import UIKit
import WebKit

/// The FlizpayWebView class.
/// This class is responsible for presenting the payment web view.
/// It fetches the transaction info from FLIZpay and presents the payment web view.
public class FlizpayWebView: UIViewController {
    
    public var redirectUrl: URL?
    public var urlScheme: String?
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
    ///
    /// - Parameters:
    ///   - presentingVC: The `UIViewController` from which to present the payment web view.
    ///   - redirectUrl: The redirect URL for the payment web view.
    ///   - urlScheme: The URL scheme of current application
    ///   - jwt: The JWT token fetched by the host app.
    public func present(from presentingVC: UIViewController, redirectUrl: String, urlScheme: String, jwt: String) {
        let flizpayWebView = FlizpayWebView()
        let redirectUrlWithJwtToken = "\(redirectUrl)&jwt=\(jwt)&redirect-url=\(urlScheme)"
        
        flizpayWebView.redirectUrl = URL(string: redirectUrlWithJwtToken)
        flizpayWebView.urlScheme = urlScheme
        presentingVC.present(flizpayWebView, animated: true, completion: nil)
    }

    internal func setupWebView() {
        let config = WKWebViewConfiguration()
        let contentController = WKUserContentController()
        config.userContentController = contentController
        config.preferences.javaScriptEnabled = true

        let wv = WKWebView(frame: .zero, configuration: config)
        wv.translatesAutoresizingMaskIntoConstraints = false

        // Set the navigation delegate to self to intercept deep links
        wv.navigationDelegate = self

        view.addSubview(wv)

        NSLayoutConstraint.activate([
            wv.topAnchor.constraint(equalTo: view.topAnchor),
            wv.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            wv.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            wv.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        self.webView = wv
        self.webViewBridge = WebViewBridge(webView: wv, presentingVC: self)
        self.webViewBridge?.register(in: contentController)
        self.webViewBridge?.injectJavaScriptInterface()
    }
    
    internal func decidePolicy(for url: URL) -> WKNavigationActionPolicy {
        guard url.scheme == "https",
              let host = url.host,
              noCredentialsBankHosts.contains(where: { host.contains($0) }),
              UIApplication.shared.canOpenURL(url) else {
            return .allow
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        return .cancel
    }
}


extension FlizpayWebView: WKNavigationDelegate {

    private var noCredentialsBankHosts: [String] {
        return [
            "ing-diba.de",   // ING-DiBa
            "revolut.com",   // Revolut
            "consorsbank.de",// Consorsbank
            "n26.com",       // N26
            "tomorrow.one",  // Tomorrow (example host)
            "kontist.com",   // Kontist
            "finom.com"      // Finom
        ]
    }
    
    // Delegate method now defers to the helper:
    public func webView(_ webView: WKWebView,
                        decidePolicyFor navigationAction: WKNavigationAction,
                        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            decisionHandler(decidePolicy(for: url))
        } else {
            decisionHandler(.allow)
        }
    }
}
