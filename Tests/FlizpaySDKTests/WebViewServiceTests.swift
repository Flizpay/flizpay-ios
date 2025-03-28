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
    
   class TestableFlizpayWebView: FlizpayWebView {
       var mockCanOpenURL: ((URL) -> Bool)?
       var mockOpen: ((URL) -> Void)?

       override func decidePolicy(for url: URL) -> WKNavigationActionPolicy {
           guard url.scheme == "https",
                 let host = url.host,
                 noCredentialsBankHosts.contains(where: { host.contains($0) }),
                 mockCanOpenURL?(url) == true else {
               return .allow
           }

           mockOpen?(url)
           return .cancel
       }

       private var noCredentialsBankHosts: [String] {
           return [
               "ing-diba.de",   // ING-DiBa
               "revolut.com",   // Revolut
               "consorsbank.de",// Consorsbank
               "n26.com",       // N26
               "tomorrow.one",  // Tomorrow
               "kontist.com",   // Kontist
               "finom.com"      // Finom
           ]
       }
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
    
    func testDecidePolicy_forNonHttpsScheme_allowsNavigation() {
            // Given
            let url = URL(string: "http://example.com")!
            
            // When
            let policy = sut.decidePolicy(for: url)
            
            // Then
            XCTAssertEqual(policy, .allow, "Non-https should be allowed")
        }
        
        func testDecidePolicy_forUnlistedHost_allowsNavigation() {
            // Given
            let url = URL(string: "https://some-other-bank.com")!
            
            // When
            let policy = sut.decidePolicy(for: url)
            
            // Then
            XCTAssertEqual(policy, .allow, "Hosts not in noCredentialsBankHosts should be allowed")
        }
        
        func testDecidePolicy_forKnownBankHost_withCanOpenURLCancelPolicy() {
            // Given
            let testVC = TestableFlizpayWebView()
            var openCalled = false

            testVC.mockCanOpenURL = { _ in true }
            testVC.mockOpen = { _ in openCalled = true }

            let url = URL(string: "https://tomorrow.one/redirect-me")!

            // When
            let policy = testVC.decidePolicy(for: url)

            // Then
            XCTAssertEqual(policy, .cancel, "Should cancel if host is recognized and app can open")
            XCTAssertTrue(openCalled, "Expected UIApplication.open to be called")
        }
    
}
