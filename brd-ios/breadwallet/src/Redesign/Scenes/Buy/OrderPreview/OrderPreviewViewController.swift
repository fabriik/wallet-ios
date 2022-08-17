//
//  OrderPreviewViewController.swift
//  breadwallet
//
//  Created by Dijana Angelovska on 12.8.22.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

class OrderPreviewViewController: BaseTableViewController<BuyCoordinator,
                                  OrderPreviewInteractor,
                                  OrderPreviewPresenter,
                                  OrderPreviewStore>,
                                  OrderPreviewResponseDisplays {
    typealias Models = OrderPreviewModels
    
    override var sceneTitle: String? {
        // TODO: Localize
        return "Order preview"
    }

    // MARK: - Overrides
    
    override func setupSubviews() {
        super.setupSubviews()
        
        tableView.register(WrapperTableViewCell<BuyOrderView>.self)
        tableView.register(WrapperTableViewCell<PaymentMethodView>.self)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        switch sections[indexPath.section] as? Models.Sections {
        case .orderInfoCard:
            cell = self.tableView(tableView, orderCellForRowAt: indexPath)
            
        case .payment:
            cell = self.tableView(tableView, paymentMethodCellForRowAt: indexPath)
            
        case .termsAndConditions:
            cell = self.tableView(tableView, labelCellForRowAt: indexPath)
            
        case .submit:
            cell = self.tableView(tableView, buttonCellForRowAt: indexPath)
            
        default:
            cell = UITableViewCell()
        }
        
        cell.setupCustomMargins(all: .large)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, paymentMethodCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        guard let cell: WrapperTableViewCell<PaymentMethodView> = tableView.dequeueReusableCell(for: indexPath),
              let model = sectionRows[section]?[indexPath.row] as? PaymentMethodViewModel
        else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
        
        cell.setup { view in
            view.configure(with: .init())
            view.setup(with: model)
            view.didTypeCVV = { [weak self] cvv in
                self?.interactor?.updateCvv(viewAction: .init(cvv: cvv))
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, orderCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        guard let cell: WrapperTableViewCell<BuyOrderView> = tableView.dequeueReusableCell(for: indexPath),
              let model = sectionRows[section]?[indexPath.row] as? BuyOrderViewModel
        else {
            return UITableViewCell()
        }
        
        cell.setup { view in
            view.configure(with: .init())
            view.setup(with: model)
            view.cardFeeInfoTapped = { [weak self] in
                self?.interactor?.showInfoPopup(viewAction: .init(isCardFee: true))
            }
            view.networkFeeInfoTapped = { [weak self] in
                self?.interactor?.showInfoPopup(viewAction: .init(isCardFee: false))
            }
        }
        
        return cell
    }

    // MARK: - User Interaction
    
    @objc override func buttonTapped() {
        super.buttonTapped()
        
        coordinator?.showPinInput { [weak self] _ in
            self?.interactor?.submit(viewAction: .init())
        }
    }

    // MARK: - OrderPreviewResponseDisplay
    
    func displayInfoPopup(responseDisplay: OrderPreviewModels.InfoPopup.ResponseDisplay) {
        coordinator?.showPopup(with: responseDisplay.model)
    }
    
    func displaySubmit(responseDisplay: OrderPreviewModels.Submit.ResponseDisplay) {
        LoadingView.hide()
        
        coordinator?.showSuccess(paymentReference: responseDisplay.paymentReference)
    }
    
    func displayThreeDSecure(responseDisplay: BillingAddressModels.ThreeDSecure.ResponseDisplay) {
        coordinator?.showThreeDSecure(url: responseDisplay.url)
    }
    
    override func displayMessage(responseDisplay: MessageModels.ResponseDisplays) {
        LoadingView.hide()
        
        // TODO: other payment methods / back home need to be linked
        coordinator?.showFailure()
    }
    
    func displayCvv(responseDisplay: OrderPreviewModels.CvvValidation.ResponseDisplay) {
        guard let section = sections.firstIndex(of: Models.Sections.submit),
              let cell = tableView.cellForRow(at: .init(row: 0, section: section)) as? WrapperTableViewCell<FEButton> else { return }
        
        cell.wrappedView.isEnabled = responseDisplay.continueEnabled
    }
    
    // MARK: - Additional Helpers
}
