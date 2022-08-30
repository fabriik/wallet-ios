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
        let detail = item.detail
        let type = item.type
        
        var sections = [AnyHashable]()
        
        switch type {
        case .swapTransaction:
            sections = [
                Models.Section.header,
                Models.Section.order,
                Models.Section.fromCurrency,
                Models.Section.image,
                Models.Section.toCurrency,
                Models.Section.timestamp,
                Models.Section.transactionFrom,
                Models.Section.transactionTo
            ]
            
        case .buyTransaction:
            sections = [
                Models.Section.header,
                Models.Section.toCurrency,
                Models.Section.buyOrder,
                Models.Section.order,
                Models.Section.timestamp,
                Models.Section.transactionTo
            ]
            
        default:
            break
        }
        
        var header = AssetViewModel()
        
        switch detail.status {
        case .pending:
            header = Presets.StatusView.pending
            
        case .complete:
            header = Presets.StatusView.complete
            
        case .failed:
            header = Presets.StatusView.failed
            
        default:
            break
        }
        
        let fromImage = getBaseCurrencyImage(currencyCode: detail.source.currency)
        let toImage = getBaseCurrencyImage(currencyCode: detail.destination.currency)
        
        let currencyCode = Store.state.defaultCurrencyCode.uppercased()
        
        let formattedUsdAmountString = ExchangeFormatter.fiat.string(for: detail.source.usdAmount) ?? ""
        let formattedCurrencyAmountString = ExchangeFormatter.crypto.string(for: detail.source.currencyAmount) ?? ""
        
        let formattedUsdAmountDestination = ExchangeFormatter.fiat.string(for: detail.destination.usdAmount) ?? ""
        let formattedCurrencyAmountDestination = ExchangeFormatter.crypto.string(for: detail.destination.currencyAmount) ?? ""
        
        let timestamp = TimeInterval(detail.timestamp) / 1000
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM YYYY, H:mm a"
        let dateString = formatter.string(from: date)
        
        let currencyFormat = "%@ %@"
        let rate = String(format: "1 %@ = %@ %@", detail.destination.currency, ExchangeFormatter.fiat.string(for: 1 / (detail.rate)) ?? "",
                          currencyCode)
        let totalText = String(format: currencyFormat, ExchangeFormatter.fiat.string(for: detail.source.currencyAmount) ?? "",
                               currencyCode)
        let amountValue = detail.source.currencyAmount - detail.source.usdFee - detail.destination.usdFee
        let amountText = String(format: currencyFormat, ExchangeFormatter.fiat.string(for: amountValue) ?? "",
                                currencyCode)
        let cardFeeText = String(format: currencyFormat, ExchangeFormatter.fiat.string(for: detail.source.usdFee) ?? "",
                                 currencyCode)
        let networkFeeText = String(format: currencyFormat, ExchangeFormatter.fiat.string(for: detail.destination.usdFee) ?? "",
                                    currencyCode)
        
        let orderValue = "\(detail.orderId)"
        let transactionFromValue = "\(String(describing: detail.source.transactionId))"
        
        var toCurrencyAssetViewModel = AssetViewModel()
        
        switch type {
        case .swapTransaction:
            toCurrencyAssetViewModel = AssetViewModel(icon: toImage,
                                                      title: "To \(detail.destination.currency)",
                                                      topRightText: "\(formattedCurrencyAmountDestination) / $\(formattedUsdAmountDestination) \(currencyCode)")
            
        case .buyTransaction:
            toCurrencyAssetViewModel = AssetViewModel(icon: toImage,
                                                      title: "\(formattedCurrencyAmountDestination) \(detail.destination.currency)",
                                                      topRightText: nil)
            
        default:
            break
        }
        
        // TODO: Localize
        let sectionRows = [
            Models.Section.header: [header],
            Models.Section.order: [
                OrderViewModel(title: "Fabriik Transaction ID",
                               value: SwapDetailsPresenter.generateAttributedOrderValue(with: orderValue),
                               showsFullValue: false)
            ],
            Models.Section.buyOrder: [
                BuyOrderViewModel(rateValue: .init(title: .text("Rate:"), value: .text(rate), infoImage: nil),
                                  amount: .init(title: .text("Amount purchased:"), value: .text(amountText), infoImage: nil),
                                  cardFee: .init(title: .text("Card fee:"),
                                                 value: .text(cardFeeText),
                                                 infoImage: nil),
                                  networkFee: .init(title: .text("Mining network fee:"), value: .text(networkFeeText), infoImage: nil),
                                  totalCost: .init(title: .text("Total:"), value: .text(totalText)),
                                  paymentMethod: .init(methodTitle: .text("Paid with"),
                                                       logo: detail.source.paymentInstrument.displayImage,
                                                       cardNumber: .text(detail.source.paymentInstrument.displayName),
                                                       expiration: .text(CardDetailsFormatter.formatExpirationDate(month: detail.source.paymentInstrument.expiryMonth,
                                                                                                                   year: detail.source.paymentInstrument.expiryYear)),
                                                       cvvTitle: nil, cvv: nil))
            ],
            Models.Section.fromCurrency: [
                AssetViewModel(icon: fromImage,
                               title: "From \(detail.source.currency)",
                               topRightText: "\(formattedCurrencyAmountString) / $\(formattedUsdAmountString) \(currencyCode)")
            ],
            Models.Section.image: [
                ImageViewModel.imageName("arrowDown")
            ],
            Models.Section.toCurrency: [
                toCurrencyAssetViewModel
            ],
            Models.Section.timestamp: [
                TransactionViewModel(title: "Timestamp",
                                     description: "\(dateString)")
            ],
            Models.Section.transactionFrom: [
                OrderViewModel(title: "\(detail.source.currency) Transaction ID",
                               value: SwapDetailsPresenter.generateAttributedOrderValue(with: transactionFromValue),
                               showsFullValue: true)
            ],
            Models.Section.transactionTo: [
                TransactionViewModel(title: "\(detail.destination.currency) Transaction ID",
                                     description: "\(detail.status.rawValue.localizedCapitalized)")
            ]
        ]
        
        viewController?.displayData(responseDisplay: .init(sections: sections, sectionRows: sectionRows))
    }

    // MARK: - Additional Helpers
    
    private static func generateAttributedOrderValue(with value: String) -> NSAttributedString {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named: "copy")?.withTintColor(LightColors.Text.one, renderingMode: .alwaysTemplate)
        imageAttachment.bounds = CGRect(x: 0,
                                        y: -Margins.extraSmall.rawValue,
                                        width: ViewSizes.extraSmall.rawValue,
                                        height: ViewSizes.extraSmall.rawValue)
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        let completeText = NSMutableAttributedString(string: "")
        completeText.append(NSAttributedString(string: value))
        completeText.append(NSAttributedString(string: " "))
        completeText.append(attachmentString)
        
        return completeText
    }
    
    private func getBaseCurrencyImage(currencyCode: String) -> UIImage? {
        guard let currency = Store.state.currencies.first(where: { $0.code == currencyCode }) else { return nil }
        
        return currency.imageSquareBackground
    }
}
