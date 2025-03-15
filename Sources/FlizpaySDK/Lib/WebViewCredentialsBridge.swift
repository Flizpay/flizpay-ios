import WebKit
import Security

/// Implementation of the WebViewBridgeProtocol
/// that injects a JavaScript interface into a `WKWebView`
/// and handles incoming messages from JavaScript such as `window.close()`
/// and allows FLIZPay to save, fetch and delete the Bank credentials in the `Keychain`.
class WebViewBridge: NSObject, WKScriptMessageHandler, WebViewBridgeProtocol {
    internal weak var webView: WKWebView?
    internal weak var presentingVC: UIViewController?
    
    init(webView: WKWebView, presentingVC: UIViewController) {
        self.webView = webView
        self.presentingVC = presentingVC
    }
    
    /// Injects the JavaScript bridge into the WebView
    func injectJavaScriptInterface() {
        let js = """
        window.KeychainBridge = {
            saveCredentials: function(key, value) {
                window.webkit.messageHandlers.saveCredentials.postMessage({ key: key, value: value });
            },
            getCredentials: function(key) {
                window.webkit.messageHandlers.getCredentials.postMessage({ key: key });
            },
            clearCredentials: function(key) {
                window.webkit.messageHandlers.clearCredentials.postMessage({ key: key });
            }
        };
        Object.defineProperty(window, 'close', {
            configurable: true,
            writable: true,
            value: function() {
                window.webkit.messageHandlers.closeWebView.postMessage({ close: true });
            }
        });

        """
        
        let script = WKUserScript(source: js, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        webView?.configuration.userContentController.addUserScript(script)
    }
    
    /// Registers message handlers
    func register(in userContentController: WKUserContentController) {
        userContentController.add(self, name: "saveCredentials")
        userContentController.add(self, name: "getCredentials")
        userContentController.add(self, name: "clearCredentials")
        userContentController.add(self, name: "closeWebView")
    }
    
    /// Handles incoming messages from JavaScript
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let body = message.body as? [String: Any] else { return }
        
        switch message.name {
        case "saveCredentials":
            if let key = body["key"] as? String, let value = body["value"] as? String {
                KeychainService.storeCredentials(key: key, value: value)
            }
        case "getCredentials":
            if let key = body["key"] as? String {
                if let credentials = KeychainService.fetchCredentials(key: key) {
                    let js = "window.onReceiveCredentials('\(credentials)');"
                    DispatchQueue.main.async {
                        self.webView?.evaluateJavaScript(js, completionHandler: nil)
                    }
                }
            }
        case "clearCredentials":
            if let key = body["key"] as? String {
                KeychainService.clearCredentials(key: key)
            }
        case "closeWebView":
            DispatchQueue.main.async {
                self.presentingVC?.dismiss(animated: true, completion: nil)
                        }
        default:
            break
        }
    }
}
