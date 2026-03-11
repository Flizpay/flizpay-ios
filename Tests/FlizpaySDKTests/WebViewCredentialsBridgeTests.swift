import XCTest
import WebKit
@testable import FlizpaySDK

class WebViewCredentialsBridgeTests: XCTestCase {

    var webView: WKWebView!
    var webViewBridge: WebViewBridgeProtocol!

    override func setUp() {
        super.setUp()
        let flizWebView = FlizpayWebView()
        flizWebView.setupWebView()
        webView = flizWebView.webView
        webViewBridge = flizWebView.webViewBridge
    }

    func testInjectJavaScriptInterface() {
        let script = webView.configuration.userContentController.userScripts.first
        XCTAssertNotNil(script, "JavaScript interface should be injected")
    }

    func testRegisterMessageHandlers() {
        let injectedScript = webView.configuration.userContentController.userScripts.first?.source

        XCTAssertNotNil(injectedScript, "Expected bridge JavaScript to be injected")
        XCTAssertTrue(injectedScript?.contains("saveCredentials") == true)
        XCTAssertTrue(injectedScript?.contains("getCredentials") == true)
        XCTAssertTrue(injectedScript?.contains("clearCredentials") == true)
        XCTAssertTrue(injectedScript?.contains("closeWebView") == true)
    }
}
