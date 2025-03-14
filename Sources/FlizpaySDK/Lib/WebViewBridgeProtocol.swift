import WebKit

protocol WebViewBridgeProtocol {
    var webView: WKWebView? { get }
    func injectJavaScriptInterface()
    func register(in controller: WKUserContentController)
}
