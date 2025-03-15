import UIKit

public class FlizpaySDK {
    
    /// Initiates the payment flow within your SDK.
    ///
    /// - Parameters:
    ///   - presentingVC: The UIViewController from which to present the payment web view.
    ///   - token: The JWT token fetched by the host app.
    ///   - amount: The transaction amount.
    ///   - transactionService: Inject the transaction service, for mockup purposes
    ///   - onFailure: Optional closure if you want to handle errors (e.g., show alerts).
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
                    print("Payment Initiated")
                case .failure(let error):
                    onFailure?(error)
                }
            }
        }
    }
}
