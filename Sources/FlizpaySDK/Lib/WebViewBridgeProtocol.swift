import WebKit

/// Protocol for injecting JavaScript interface into a web view
protocol WebViewBridgeProtocol {
    var webView: WKWebView? { get }
    func injectJavaScriptInterface()
    func register(in controller: WKUserContentController)
}
