import UIKit

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
    ///   - transactionService: Inject the transaction service, for mockup purposes
    ///   - onFailure: Optional completion closure if you want to handle errors (e.g., show alerts).
    public static func initiatePayment(
        from presentingVC: UIViewController,
        token: String,
        amount: String,
        transactionService: TransactionService? = nil,
        onFailure: ((Error) -> Void)? = nil
    ) {
        let transactionService = transactionService ?? TransactionService()
        transactionService.fetchTransactionInfo(token: token, amount: amount) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let transactionResponse):
                    // Unwrap the redirectUrl or use default
                    let redirectUrl = transactionResponse.redirectUrl ?? Constants.baseURL
                    
                    // Present the web view
                    FlizpayWebView().present(
                        from: presentingVC,
                        redirectUrl: redirectUrl,
                        jwt: token
                    )
                case .failure(let error):
                    onFailure?(error)
                }
            }
        }
    }
}
