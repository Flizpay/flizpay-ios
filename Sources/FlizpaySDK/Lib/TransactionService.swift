import Foundation

/// TransactionResponse is the response model for the `/transactions` endpoint.
/// 
/// - redirectUrl: The URL to the FLIZPay gateway.
public struct TransactionResponse: Codable {
    let redirectUrl: String?

    enum OuterKeys: String, CodingKey {
        case data
    }

    enum DataKeys: String, CodingKey {
        case redirectUrl
    }

    // Decoding from nested JSON
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: OuterKeys.self)
        let dataContainer = try container.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
        self.redirectUrl = try dataContainer.decode(String.self, forKey: .redirectUrl)
    }

    // Encoding into nested JSON (if needed)
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: OuterKeys.self)
        var dataContainer = container.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
        try dataContainer.encode(redirectUrl, forKey: .redirectUrl)
    }
}

/// TransactionRequest is the request model for the `/transactions` endpoint.
/// 
///  - amount: The transaction amount.
///  - currency: The currency of the transaction - Default to: `EUR`.
///  - source: The source of the transaction - Default: `sdk_integration`.
struct TransactionRequest: Codable {
    let amount: String
    let currency: String
    let source: String
    let metadata: [String: Any]?
    
    init(amount: String, metadata: [String: Any]? = nil, currency: String = "EUR", source: String = "sdk_integration") {
        self.amount = amount
        self.currency = currency
        self.source = source
        self.metadata = metadata
    }
}

/// TransactionService makes the API call to fetch the transaction info.
/// It uses the `URLSession` to make the network request.
/// The `fetchTransactionInfo` method receives a token and amount as input and returns a `TransactionResponse`.
/// The completion handler returns a `Result` type with either the `TransactionResponse` or an `Error`.
public class TransactionService {
    private let urlSession: URLSession

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    /// Fetches the transaction info from the FLIZPay backend.
    ///
    /// - Parameters:
    ///   - token: The JWT token fetched by the host app.
    ///   - amount: The transaction amount.
    ///   - completion: The completion handler with the `TransactionResponse` or an `Error`.
    public func fetchTransactionInfo(
        token: String,
        amount: String,
        metadata: [String: Any]? = nil,
        completion: @escaping (Result<TransactionResponse, Error>) -> Void
    ) {
        guard let url = URL(string: "\(Constants.apiURL)/transactions") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authentication")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = TransactionRequest(amount: amount, metadata: metadata)

        do {
            let jsonData = try JSONEncoder().encode(body)
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }
        
        self.urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let transactionResponse = try JSONDecoder().decode(TransactionResponse.self, from: data)
                completion(.success(transactionResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
