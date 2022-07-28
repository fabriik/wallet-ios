//
//  SwapDetailsPresenter.swift
//  breadwallet
//
//  Created by Rok on 06/07/2022.
//
//

import UIKit

final class SwapDetailsPresenter: NSObject, Presenter, SwapDetailsActionResponses {
    typealias Models = SwapDetailsModels

    weak var viewController: SwapDetailsViewController?

    // MARK: - SwapDetailsActionResponses
    func presentData(actionResponse: FetchModels.Get.ActionResponse) {
        guard let item = actionResponse.item as? Models.Item else { return }
        
        let sections = [
            Models.Section.header,
            Models.Section.order,
            Models.Section.fromCurrency,
            Models.Section.image,
            Models.Section.toCurrency,
            Models.Section.timestamp,
            Models.Section.transactionFrom,
            Models.Section.transactionTo
        ]
        
        var header = AssetViewModel()
        
        switch item.status {
        case .pending:
            header = Presets.StatusView.pending
        case .complete :
            header = Presets.StatusView.complete
        case .failed :
            header = Presets.StatusView.failed
        default:
            break
        }
        
        let fromImage = getBaseCurrencyImage(currencyCode: item.source.currency)
        let toImage = getBaseCurrencyImage(currencyCode: item.destination.currency)
        
        let currencyCode = Store.state.defaultCurrencyCode
        let format = "%.*f"
        let decimal = 5
        
        let formattedUsdAmountString = String(format: format, decimal, item.source.usdAmount)
        let formattedCurrencyAmountString = String(format: format, decimal, item.source.currencyAmount)
        
        let formattedUsdAmountDestination = String(format: format, decimal, item.destination.usdAmount)
        let formattedCurrencyAmountDestination = String(format: format, decimal, item.destination.currencyAmount)
        
        let timestamp = TimeInterval(item.timestamp) / 1000
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM YYYY, hh:mm a"
        let dateString = formatter.string(from: date)
        
        // TODO: Localize
        let sectionRows = [
            Models.Section.header: [ header ],
            Models.Section.order: [
                OrderViewModel(title: "Fabriik Order ID",
                               value: "\(item.orderId)",
                               imageName: "copy")
            ],
            Models.Section.fromCurrency: [
                AssetViewModel(icon: fromImage,
                               title: "From \(item.source.currency)",
                               topRightText: "\(formattedCurrencyAmountString) / $\(formattedUsdAmountString) \(currencyCode)")
            ],
            Models.Section.image: [
                ImageViewModel.imageName("arrowDown")
            ],
            Models.Section.toCurrency: [
                AssetViewModel(icon: toImage,
                               title: "To \(item.destination.currency)",
                               topRightText: "\(formattedCurrencyAmountDestination) / $\(formattedUsdAmountDestination) \(currencyCode)")
            ],
            Models.Section.timestamp: [
                TransactionViewModel(title: "Timestamp",
                                     description: "\(dateString)")
            ],
            Models.Section.transactionFrom: [
                OrderViewModel(title: "\(item.source.currency) Transaction ID",
                               value: "\(String(describing: item.source.transactionId))",
                               imageName: "copy")
            ],
            Models.Section.transactionTo: [
                TransactionViewModel(title: "\(item.destination.currency) Transaction ID",
                                     description: "\(item.status.rawValue.localizedCapitalized)")
            ]
        ]
        
        viewController?.displayData(responseDisplay: .init(sections: sections, sectionRows: sectionRows))
    }

    // MARK: - Additional Helpers

    private func getBaseCurrencyImage(currencyCode: String) -> UIImage? {
        guard let currency = Store.state.currencies.first(where: { $0.code == currencyCode }) else { return nil }
        
        return currency.imageSquareBackground
    }
}
