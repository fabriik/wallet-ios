//
//  PaymentsViewController.swift
//  breadwallet
//
//  Created by Dijana Angelovska on 6.10.22.
//
//

import UIKit

class PaymentsViewController: BaseTableViewController<PaymentsCoordinator,
                              PaymentsInteractor,
                              PaymentsPresenter,
                              PaymentsStore>,
                              PaymentsResponseDisplays {
    
    typealias Models = PaymentsModels
    
    override var sceneTitle: String? { return L10n.Buy.paymentMethod }
    var isSearchEnabled: Bool { return false }
    var itemSelected: ((Any?) -> Void)?
    
    override func setupSubviews() {
        super.setupSubviews()
        
        tableView.separatorStyle = .none
        tableView.register(WrapperTableViewCell<CardSelectionView>.self)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        switch sections[indexPath.section] as? Models.Sections {
        case .addItem:
            cell = self.tableView(tableView, addItemCellForRowAt: indexPath)
            
        case .items:
            cell = self.tableView(tableView, itemCellForRowAt: indexPath)
            
        default:
            cell = UITableViewCell()
        }
        
        cell.contentView.setupCustomMargins(vertical: .small, horizontal: .zero)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, itemCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        guard let cell: WrapperTableViewCell<CardSelectionView> = tableView.dequeueReusableCell(for: indexPath),
              let model = sectionRows[section]?[indexPath.row] as? PaymentCard
        else {
            return UITableViewCell()
        }
        
        cell.setup { view in
            view.configure(with: .init())
            view.setup(with: .init(title: nil,
                                   subtitle: nil,
                                   logo: model.displayImage,
                                   cardNumber: .text(model.displayName),
                                   expiration: .text(CardDetailsFormatter.formatExpirationDate(month: model.expiryMonth, year: model.expiryYear))))
            
            view.moreButtonCallback = { [weak self] in
                self?.interactor?.showActionSheetRemovePayment(viewAction: .init(instrumentId: model.id))
            }
            
            view.setupCustomMargins(top: .zero, leading: .large, bottom: .zero, trailing: .large)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, addItemCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: WrapperTableViewCell<CardSelectionView> = tableView.dequeueReusableCell(for: indexPath) else {
            return UITableViewCell()
        }
        
        cell.setup { view in
            view.configure(with: .init())
            view.setup(with: .init(title: .text(L10n.Buy.card),
                                   subtitle: nil,
                                   logo: .imageName("credit_card_icon"),
                                   cardNumber: .text(L10n.Buy.addDebitCreditCard),
                                   expiration: nil))
            
            view.setupCustomMargins(top: .zero, leading: .large, bottom: .zero, trailing: .large)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = sections[indexPath.section] as? Models.Sections,
              section == Models.Sections.items else {
            coordinator?.open(scene: Scenes.AddCard)
            return
        }
        
        guard let model = sectionRows[section]?[indexPath.row], dataStore?.isSelectingEnabled == true else { return }
        
        itemSelected?(model)
        
        coordinator?.dismissFlow()
    }
    
    // MARK: - ItemSelectionResponseDisplay
    
    func displayActionSheetRemovePayment(responseDisplay: PaymentsModels.ActionSheet.ResponseDisplay) {
        coordinator?.showPaymentsActionSheet(okButtonTitle: responseDisplay.actionSheetOkButton,
                                             cancelButtonTitle: responseDisplay.actionSheetCancelButton,
                                             handler: { [weak self] in
            self?.interactor?.removePaymenetPopup(viewAction: .init(instrumentID: responseDisplay.instrumentId))
        })
    }
    
    func displayRemovePaymentPopup(responseDisplay: PaymentsModels.RemovePaymenetPopup.ResponseDisplay) {
        guard let navigationController = coordinator?.navigationController else { return }
        
        coordinator?.showPopup(on: navigationController,
                               blurred: false,
                               with: responseDisplay.popupViewModel,
                               config: responseDisplay.popupConfig,
                               closeButtonCallback: { [weak self] in
            self?.coordinator?.hidePopup()
        }, callbacks: [ {[weak self] in
                self?.coordinator?.hidePopup()
                self?.interactor?.removePayment(viewAction: .init())
            }, {[weak self] in
                self?.coordinator?.hidePopup()}
        ])
    }
    
    func displayRemovePaymentSuccess(responseDisplay: PaymentsModels.RemovePayment.ResponseDisplay) {
        interactor?.getPaymentCards(viewAction: .init())
    }
    
    // MARK: - Additional Helpers
}
