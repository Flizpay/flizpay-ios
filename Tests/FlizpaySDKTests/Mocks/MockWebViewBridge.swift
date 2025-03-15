import WebKit
@testable import FlizpaySDK

class MockWebViewBridge: WebViewBridgeProtocol {
    var didSetupCalled = false
    var webView: WKWebView?
    
    init(webView: WKWebView? = nil) {
        self.webView = webView
    }
    
    func injectJavaScriptInterface() {
        // Mock implementation
    }
    
    func register(in controller: WKUserContentController) {
        // Mock implementation
    }
}
