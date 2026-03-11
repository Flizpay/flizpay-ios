import XCTest
@testable import FlizpaySDK

extension String: Error {}

private final class PresentingViewControllerSpy: UIViewController {
    var presentExpectation: XCTestExpectation?
    var capturedPresentedViewController: UIViewController?

    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        capturedPresentedViewController = viewControllerToPresent
        presentExpectation?.fulfill()
        completion?()
    }
}

class FlizpaySDKTests: XCTestCase {
    var mockViewController: PresentingViewControllerSpy!
    var mockTransactionService: MockTransactionService!
    var sdk: FlizpaySDK!
    
    override func setUp() {
        super.setUp()
        mockViewController = PresentingViewControllerSpy()
        mockTransactionService = MockTransactionService()
    }
    
    override func tearDown() {
        mockViewController = nil
        mockTransactionService = nil
        sdk = nil
        super.tearDown()
    }
    
    func testInitiatePaymentSuccess() {
        // Given
        let expectation = expectation(description: "Payment Initiated")
        mockViewController.presentExpectation = expectation
        
        let mockResponse = try! JSONDecoder().decode(TransactionResponse.self, from: String("{\"data\":{\"redirectUrl\": \"https://example.com\"}}").data(using: String.Encoding.utf8) ?? Data())
        mockTransactionService.mockResult = .success(mockResponse)
        
        // When
        FlizpaySDK.initiatePayment(from: mockViewController, token: "mock-token", amount: "100.00", urlScheme: "flizdemo://test?foo=bar", transactionService: mockTransactionService) { error in
            // Then
            XCTAssertNil(error)
        }

        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(mockViewController.capturedPresentedViewController is FlizpayWebView)
    }
    
    func testInitiatePaymentFailure() {
        // Given
        let expectation = expectation(description: "Payment initiation fails")
        mockTransactionService.mockResult = .failure("Invalid Token")
        
        // When
        FlizpaySDK.initiatePayment(from: mockViewController, token: "invalid-token", amount: "100.00", urlScheme: "flizdemo://test?foo=bar", transactionService: mockTransactionService) { error in
            // Then
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
}
