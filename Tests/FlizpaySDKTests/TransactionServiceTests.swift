import XCTest
@testable import FlizpaySDK

class TransactionServiceTests: XCTestCase {
    var sut: TransactionService!
    var mockURLSession: MockURLSession!
    
    override func setUp() {
        super.setUp()
        mockURLSession = MockURLSession()
        sut = TransactionService(urlSession: mockURLSession)
    }
    
    override func tearDown() {
        sut = nil
        mockURLSession = nil
        super.tearDown()
    }
    
    func testFetchTransactionInfoSuccess() {
        // Given
        let expectation = expectation(description: "Fetch transaction info")
        mockURLSession.mockData = MockResponses.successfulTransaction
        mockURLSession.mockResponse = HTTPURLResponse(url: URL(string: "https://api.flizpay.com/transactions")!,
                                                    statusCode: 200,
                                                    httpVersion: nil, 
                                                    headerFields: nil)
        
        // When
        sut.fetchTransactionInfo(token: "mock-token", amount: "100.00") { result in
            // Then
            switch result {
            case .success(let response):
                XCTAssertEqual(response.redirectUrl, "https://example.com/checkout")
            case .failure:
                XCTFail("Should not fail")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchTransactionInfoFailure() {
        // Given
        let expectation = expectation(description: "Fetch transaction info fails")
        mockURLSession.mockData = MockResponses.failedTransaction
        mockURLSession.mockResponse = HTTPURLResponse(url: URL(string: "https://api.flizpay.com")!, 
                                                    statusCode: 400, 
                                                    httpVersion: nil, 
                                                    headerFields: nil)
        
        // When
        sut.fetchTransactionInfo(token: "invalid-token", amount: "100.00") { result in
            // Then
            switch result {
            case .success:
                XCTFail("Should fail")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testInitiatePaymentDeepMetadataFailure() {
        // Given
        let expectation = expectation(description: "Fetch transaction info fails")
        mockURLSession.mockData = MockResponses.wrongDataFormat
        mockURLSession.mockResponse = HTTPURLResponse(url: URL(string: "https://api.flizpay.com")!,
                                                    statusCode: 400,
                                                    httpVersion: nil,
                                                    headerFields: nil)
            
            // Construct a 6‑level deep metadata JSONValue structure.
            let deepMetadata: [String: JSONValue] = [
                "level1": .object([
                    "level2": .object([
                        "level3": .object([
                            "level4": .object([
                                "level5": .object([
                                    "level6": .string("bottom")
                                ])
                            ])
                        ])
                    ])
                ])
            ]
        
        // When
        sut.fetchTransactionInfo(token: "invalid-token", amount: "100.00", metadata: deepMetadata) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Should fail")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
            wait(for: [expectation], timeout: 1.0)
        }
}
