import XCTest
import WebKit
@testable import FlizpaySDK

class FlizpayWebViewTests: XCTestCase {
    var sut: FlizpayWebView!
    var mockWebViewBridge: MockWebViewBridge!
    var mockWebView: WKWebView!
    
    override func setUp() {
        super.setUp()
        mockWebView = WKWebView()
        mockWebViewBridge = MockWebViewBridge(webView: mockWebView)
        sut = FlizpayWebView()
        sut.webViewBridge = mockWebViewBridge
    }
    
    override func tearDown() {
        sut = nil
        mockWebViewBridge = nil
        mockWebView = nil
        super.tearDown()
    }
    
    func testWebViewLoad() {
        // Given
        let url = URL(string: "https://example.com/")!
        sut.redirectUrl = url
        
        // When
        sut.viewDidLoad()
        // Then
        XCTAssertEqual(sut.webView!.url, url, "Assert webview URL")
    }
    
    func testWebViewBridgeSetup() {
        // When
        sut.setupWebView()
        
        // Then
        XCTAssertNotNil(mockWebViewBridge.webView, "Webview is instantiated")
        XCTAssertNotNil(sut.webViewBridge)
    }
}
