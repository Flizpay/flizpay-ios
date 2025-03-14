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
        let js = """
            (() => {
                return (typeof window.webkit !== 'undefined' &&
                        typeof window.webkit.messageHandlers !== 'undefined' &&
                        typeof window.webkit.messageHandlers.saveCredentials !== 'undefined' &&
                        typeof window.webkit.messageHandlers.getCredentials !== 'undefined' &&
                        typeof window.webkit.messageHandlers.clearCredentials !== 'undefined');
            })();
            """

            let expectation = XCTestExpectation(description: "Check if handlers are registered")

            webView.evaluateJavaScript(js) { result, error in
                if let result = result as? Bool {
                    XCTAssertTrue(result, "Expected message handlers to be registered")
                } else {
                    XCTFail("Failed to evaluate JavaScript or handlers are missing")
                }
                expectation.fulfill()
            }

            wait(for: [expectation], timeout: 2.0)
    }
}
