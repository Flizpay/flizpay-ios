import UIKit

/// Configuration for FlizPay SDK URL overrides.
///
/// - Parameters:
///   - apiUrl: Optional override for the API URL (defaults to production if nil or empty)
///   - baseUrl: Optional override for the base URL (defaults to production if nil or empty)
public struct FlizpayConfig {
    public let apiUrl: String?
    public let baseUrl: String?
    
    public init(apiUrl: String? = nil, baseUrl: String? = nil) {
        self.apiUrl = apiUrl
        self.baseUrl = baseUrl
    }
}

/// The Flizpay SDK class.
/// This class is the entry point for the SDK.
/// It provides a method to initiate the payment flow.
/// The method fetches the transaction info from FLIZpay and presents the payment web view. 
public class FlizpaySDK {
    
    /// Initiates the payment flow within your SDK.
    ///
    /// - Parameters:
    ///   - presentingVC: The `UIViewController` from which to present the payment web view.
    ///   - token: The JWT token fetched by the host app.
    ///   - amount: The transaction amount.
    ///   - metadata: The metadata object
    ///   - urlScheme: The application url scheme.
    ///   - config: Optional configuration for URL overrides.
    ///   - transactionService: Inject the transaction service, for mockup purposes
    ///   - onFailure: Optional completion closure if you want to handle errors (e.g., show alerts).
    public static func initiatePayment(
        from presentingVC: UIViewController,
        token: String,
        amount: String,
        metadata: [String: JSONValue]? = nil,
        urlScheme: String,
        config: FlizpayConfig? = nil,
        transactionService: TransactionService? = nil,
        onFailure: ((Error) -> Void)? = nil
    ) {
        let transactionService = transactionService ?? TransactionService(
            apiUrl: config?.apiUrl,
            baseUrl: config?.baseUrl
        )
        
        // Use configured base URL or fall back to production default
        let effectiveBaseUrl = config?.baseUrl?.isEmpty == false ? config!.baseUrl! : Constants.baseURL
        
        transactionService.fetchTransactionInfo(token: token, amount: amount, metadata: metadata) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let transactionResponse):
                    // Unwrap the redirectUrl or use configured base URL
                    let redirectUrl = transactionResponse.redirectUrl ?? effectiveBaseUrl
                    
                    // Present the web view
                    FlizpayWebView().present(
                        from: presentingVC,
                        redirectUrl: redirectUrl,
                        urlScheme: urlScheme,
                        jwt: token
                    )
                case .failure(let error):
                    onFailure?(error)
                }
            }
        }
    }
}
