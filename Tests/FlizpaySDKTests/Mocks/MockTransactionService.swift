import Foundation
@testable import FlizpaySDK

class MockTransactionService: TransactionService {
    var mockResult: Result<TransactionResponse, Error>?
    
    override func fetchTransactionInfo(token: String, amount: String,  metadata: [String: JSONValue]? = nil, completion: @escaping (Result<TransactionResponse, Error>) -> Void) {
        if let result = mockResult {
            completion(result)
        }
    }
}
