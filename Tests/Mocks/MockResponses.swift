import Foundation

enum MockResponses {
    static let successfulTransaction = """
    {
        "data": {"redirectUrl": "https://example.com/checkout"}
    }
    """.data(using: .utf8)!
    
    static let failedTransaction = """
    {
        "data": { "message": "Invalid token" }
    }
    """.data(using: .utf8)!
}
