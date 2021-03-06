//
//  SwapViewController.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 05/07/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

class SwapViewController: BaseTableViewController<SwapCoordinator,
                          SwapInteractor,
                          SwapPresenter,
                          SwapStore>,
                          SwapResponseDisplays {
    
    typealias Models = SwapModels
    
    override var sceneLeftAlignedTitle: String? {
         // TODO: localize
        return "Swap"
    }
    
    lazy var confirmButton: WrapperView<FEButton> = {
        let button = WrapperView<FEButton>()
        return button
    }()
    
    // MARK: - Overrides
    
    override func setupSubviews() {
        super.setupSubviews()
        
        tableView.register(WrapperTableViewCell<MainSwapView>.self)
        tableView.delaysContentTouches = false
        
        // TODO: Same code as CheckListViewController. Refactor
        view.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { make in
            make.centerX.leading.equalToSuperview()
            make.bottom.equalTo(view.snp.bottomMargin)
        }
        
        confirmButton.wrappedView.snp.makeConstraints { make in
            make.height.equalTo(ButtonHeights.common.rawValue)
            make.edges.equalTo(confirmButton.snp.margins)
        }
        
        confirmButton.setupCustomMargins(top: .small, leading: .large, bottom: .large, trailing: .large)
        
        tableView.snp.remakeConstraints { make in
            make.leading.centerX.top.equalToSuperview()
            make.bottom.equalTo(confirmButton.snp.top)
        }
        
        confirmButton.wrappedView.configure(with: Presets.Button.primary)
        confirmButton.wrappedView.setup(with: .init(title: "Confirm", enabled: false))
        
        confirmButton.wrappedView.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    override func prepareData() {
        super.prepareData()
        
        DispatchQueue.main.async {
            LoadingView.show()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        switch sections[indexPath.section] as? Models.Sections {
        case .rateAndTimer:
            cell = self.tableView(tableView, timerCellForRowAt: indexPath)
            
        case .swapCard:
            cell = self.tableView(tableView, swapMainCellForRowAt: indexPath)
        
        case .amountSegment:
            cell = self.tableView(tableView, segmentControlCellForRowAt: indexPath)
            
        case .errors:
            cell = self.tableView(tableView, infoViewCellForRowAt: indexPath)
            
        default:
            cell = UITableViewCell()
        }
        
        cell.setupCustomMargins(all: .large)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, segmentControlCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        guard let cell: WrapperTableViewCell<FESegmentControl> = tableView.dequeueReusableCell(for: indexPath),
              let model = sectionRows[section]?[indexPath.row] as? SegmentControlViewModel
        else {
            return UITableViewCell()
        }
        
        cell.setup { view in
            view.configure(with: .init())
            view.setup(with: model)
            
            view.didChangeValue = { [weak self] segment in
                self?.view.endEditing(true)
                self?.interactor?.setAmount(viewAction: .init(minMaxToggleValue: segment))
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, swapMainCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        guard let cell: WrapperTableViewCell<MainSwapView> = tableView.dequeueReusableCell(for: indexPath),
              let model = sectionRows[section]?[indexPath.row] as? MainSwapViewModel
        else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
        
        cell.setup { view in
            view.configure(with: .init(shadow: Presets.Shadow.light,
                                       background: .init(backgroundColor: LightColors.Background.two,
                                                         tintColor: LightColors.Text.one,
                                                         border: Presets.Border.zero)))
            view.setup(with: model)
            
            view.didChangeFromFiatAmount = { [weak self] amount in
                self?.interactor?.setAmount(viewAction: .init(fromFiatAmount: amount))
            }
            
            view.didChangeFromCryptoAmount = { [weak self] amount in
                self?.interactor?.setAmount(viewAction: .init(fromCryptoAmount: amount))
            }
            
            view.didChangeToFiatAmount = { [weak self] amount in
                self?.interactor?.setAmount(viewAction: .init(toFiatAmount: amount))
            }
            
            view.didChangeToCryptoAmount = { [weak self] amount in
                self?.interactor?.setAmount(viewAction: .init(toCryptoAmount: amount))
            }
            
            view.didTapFromAssetsSelection = { [weak self] in
                self?.interactor?.selectAsset(viewAction: .init(from: true))
            }
            
            view.didTapToAssetsSelection = { [weak self] in
                self?.interactor?.selectAsset(viewAction: .init(to: true))
            }
            
            view.didChangePlaces = { [weak self] in
                self?.interactor?.switchPlaces(viewAction: .init())
            }
            
            view.contentSizeChanged = { [weak self] in
                self?.tableView.beginUpdates()
                self?.tableView.endUpdates()
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, infoViewCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: WrapperTableViewCell<WrapperView<FEInfoView>> = tableView.dequeueReusableCell(for: indexPath)
        else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
        
        cell.setup { view in
            view.setup { view in
                view.setupCustomMargins(all: .large)
            }
        }
        
        return cell
    }
    
    // MARK: - User Interaction

    @objc override func buttonTapped() {
        super.buttonTapped()
        
        interactor?.showConfirmation(viewAction: .init())
    }
    
    // MARK: - SwapResponseDisplay
    
    override func displayMessage(responseDisplay: MessageModels.ResponseDisplays) {
        if responseDisplay.error != nil {
            LoadingView.hide()
        }
        
        guard let section = sections.firstIndex(of: Models.Sections.errors),
              let cell = tableView.cellForRow(at: .init(row: 0, section: section)) as? WrapperTableViewCell<WrapperView<FEInfoView>> else {
                  interactor?.showInfoPopup(viewAction: .init())
                  return
              }
        
        cell.setup { view in
            view.setup { [weak self] view in
                let model = responseDisplay.model
                view.setup(with: model)
                
                let config = responseDisplay.config
                view.configure(with: config)
                self?.tableView.beginUpdates()
                self?.tableView.endUpdates()
            }
        }
        
        guard let error = responseDisplay.error as? SwapErrors else { return }
        
        switch error {
        case .noQuote:
            displayUpdateRate(responseDisplay: .init(rate: .init()))
            
        default:
            return
        }
    }
    
    func displaySetAmount(responseDisplay: SwapModels.Amounts.ResponseDisplay) {
        // TODO: replace with Coordinator call
        LoadingView.hide()
        
        confirmButton.wrappedView.isEnabled = responseDisplay.continueEnabled
        guard let section = sections.firstIndex(of: Models.Sections.swapCard),
              let cell = tableView.cellForRow(at: .init(row: 0, section: section)) as? WrapperTableViewCell<MainSwapView> else { return }
        
        cell.setup { view in
            let model = responseDisplay.amounts
            view.setup(with: model)
        }
        
        guard let section = sections.firstIndex(of: Models.Sections.amountSegment),
              let cell = tableView.cellForRow(at: .init(row: 0, section: section)) as? WrapperTableViewCell<FESegmentControl> else { return }
        
        cell.setup { view in
            let model = responseDisplay.minMaxToggleValue
            view.setup(with: model)
        }
    }
    
    func displayUpdateRate(responseDisplay: SwapModels.Rate.ResponseDisplay) {
        guard let section = sections.firstIndex(of: Models.Sections.rateAndTimer),
              let cell = tableView.cellForRow(at: .init(row: 0, section: section)) as? WrapperTableViewCell<ExchangeRateView> else { return }
        
        cell.setup { view in
            let model = responseDisplay.rate
            view.setup(with: model)
            view.completion = { [weak self] in
                self?.interactor?.updateRate(viewAction: .init())
            }
        }
    }
    
    func displaySelectAsset(responseDisplay: SwapModels.Assets.ResponseDisplay) {
        coordinator?.showAssetSelector(currencies: dataStore?.currencies,
                                       selected: { [weak self] model in
            guard let model = model as? AssetViewModel else { return }
            
            // TODO: replace with coordinator call
            LoadingView.show()
            guard responseDisplay.from?.isEmpty == false else {
                self?.interactor?.assetSelected(viewAction: .init(to: model.subtitle))
                return
            }
            self?.interactor?.assetSelected(viewAction: .init(from: model.subtitle))
        })
    }
    
    func displayConfirmation(responseDisplay: SwapModels.ShowConfirmDialog.ResponseDisplay) {
        let _: WrapperPopupView<SwapConfirmationView>? = coordinator?.showPopup(with: responseDisplay.config,
                                                                                viewModel: responseDisplay.viewModel,
                                                                                confirmedCallback: { [weak self] in
            self?.coordinator?.showPinInput { pin in
                LoadingView.show()
                self?.interactor?.confirm(viewAction: .init(pin: pin))
            }
        })
    }
    
    func displayConfirm(responseDisplay: SwapModels.Confirm.ResponseDisplay) {
        LoadingView.hide()
        coordinator?.showSwapInfo(from: responseDisplay.from, to: responseDisplay.to, exchangeId: responseDisplay.exchangeId)
    }
    
    func displayInfoPopup(responseDisplay: SwapModels.InfoPopup.ResponseDisplay) {
        coordinator?.showPopup(on: self,
                               blurred: true,
                               with: responseDisplay.popupViewModel,
                               config: responseDisplay.popupConfig,
                               closeButtonCallback: { [weak self] in
            self?.coordinator?.goBack()
        }, callbacks: [ { [weak self] in
            self?.coordinator?.hidePopup()
            self?.coordinator?.goBack()
        }])
    }
    
    // MARK: - Additional Helpers
}
