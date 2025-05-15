import XCTest
@testable import FlizpaySDK

extension String: Error {}

class FlizpaySDKTests: XCTestCase {
    var mockViewController: UIViewController!
    var mockTransactionService: MockTransactionService!
    var sdk: FlizpaySDK!
    
    override func setUp() {
        super.setUp()
        mockViewController = UIViewController()
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
        
        let mockResponse = try! JSONDecoder().decode(TransactionResponse.self, from: String("{\"data\":{\"redirectUrl\": \"https://example.com\"}}").data(using: String.Encoding.utf8) ?? Data())
        mockTransactionService.mockResult = .success(mockResponse)
        
        // When
        FlizpaySDK.initiatePayment(from: mockViewController, token: "mock-token", amount: "100.00", urlScheme: "iosdemo://test?foo=bar", transactionService: mockTransactionService) { error in
            // Then
            XCTAssertNil(error)
        }
        expectation.fulfill()
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testInitiatePaymentFailure() {
        // Given
        let expectation = expectation(description: "Payment initiation fails")
        mockTransactionService.mockResult = .failure("Invalid Token")
        
        // When
        FlizpaySDK.initiatePayment(from: mockViewController, token: "invalid-token", amount: "100.00", urlScheme: "iosdemo://test?foo=bar", transactionService: mockTransactionService) { error in
            // Then
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
}
