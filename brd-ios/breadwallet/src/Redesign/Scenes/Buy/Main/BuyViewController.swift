//
//  BuyViewController.swift
//  breadwallet
//
//  Created by Rok on 01/08/2022.
//
//

import UIKit

class BuyViewController: BaseTableViewController<BuyCoordinator, BuyInteractor, BuyPresenter, BuyStore>, BuyResponseDisplays {
    
    typealias Models = BuyModels
    
    override var sceneLeftAlignedTitle: String? {
         // TODO: localize
        return "Buy"
    }
    
    lazy var continueButton: WrapperView<FEButton> = {
        let button = WrapperView<FEButton>()
        return button
    }()
    
    // MARK: - Overrides
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let section = sections.firstIndex(of: Models.Sections.rate),
              let cell = tableView.cellForRow(at: .init(row: 0, section: section)) as? WrapperTableViewCell<ExchangeRateView>
        else { return continueButton.wrappedView.isEnabled = false }
        
        cell.wrappedView.invalidate()
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        tableView.register(WrapperTableViewCell<SwapCurrencyView>.self)
        tableView.register(WrapperTableViewCell<CardSelectionView>.self)
        tableView.delaysContentTouches = false
        
        // TODO: Same code as CheckListViewController. Refactor
        view.addSubview(continueButton)
        continueButton.snp.makeConstraints { make in
            make.centerX.leading.equalToSuperview()
            make.bottom.equalTo(view.snp.bottomMargin)
        }
        
        continueButton.wrappedView.snp.makeConstraints { make in
            make.height.equalTo(ButtonHeights.common.rawValue)
            make.edges.equalTo(continueButton.snp.margins)
        }
        
        continueButton.setupCustomMargins(top: .small, leading: .large, bottom: .large, trailing: .large)
        
        tableView.snp.remakeConstraints { make in
            make.leading.centerX.top.equalToSuperview()
            make.bottom.equalTo(continueButton.snp.top)
        }
        
        continueButton.wrappedView.configure(with: Presets.Button.primary)
        continueButton.wrappedView.setup(with: .init(title: "Continue", enabled: false))
        continueButton.wrappedView.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
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
        case .accountLimits:
            cell = self.tableView(tableView, labelCellForRowAt: indexPath)
            
        case .rate:
            cell = self.tableView(tableView, timerCellForRowAt: indexPath)

        case .from:
            cell = self.tableView(tableView, cryptoSelectionCellForRowAt: indexPath)

        case .to:
            cell = self.tableView(tableView, paymentSelectionCellForRowAt: indexPath)

        case .error:
            cell = self.tableView(tableView, infoViewCellForRowAt: indexPath)

        default:
            cell = UITableViewCell()
        }
        
        cell.setupCustomMargins(all: .large)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, cryptoSelectionCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        guard let cell: WrapperTableViewCell<SwapCurrencyView> = tableView.dequeueReusableCell(for: indexPath),
              let model = sectionRows[section]?[indexPath.row] as? SwapCurrencyViewModel
        else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
        
        cell.setup { view in
            view.configure(with: .init(shadow: Presets.Shadow.light,
                                       background: .init(backgroundColor: LightColors.Background.one,
                                                         tintColor: LightColors.Text.one,
                                                         border: Presets.Border.zero)))
            view.setup(with: model)
            
            view.didChangeFiatAmount = { [weak self] value in
                self?.interactor?.setAmount(viewAction: .init(fiatValue: value))
            }
            
            view.didChangeCryptoAmount = { [weak self] value in
                self?.interactor?.setAmount(viewAction: .init(tokenValue: value))
            }
            
            view.didTapSelectAsset = { [weak self] in
                guard let dataStore = self?.dataStore else { return }
                
                self?.coordinator?.showAssetSelector(currencies: dataStore.currencies, supportedCurrencies: dataStore.supportedCurrencies) { item in
                    guard let item = item as? AssetViewModel else { return }
                    self?.interactor?.setAssets(viewAction: .init(currency: item.subtitle))
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, paymentSelectionCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        guard let cell: WrapperTableViewCell<CardSelectionView> = tableView.dequeueReusableCell(for: indexPath),
              let model = sectionRows[section]?[indexPath.row] as? CardSelectionViewModel
        else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
        
        cell.setup { view in
            view.configure(with: .init())
            view.setup(with: model)
            
            view.didTapSelectCard = { [weak self] in
                self?.interactor?.getPaymentCards(viewAction: .init())
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, infoViewCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: WrapperTableViewCell<WrapperView<FEInfoView>> = tableView.dequeueReusableCell(for: indexPath)
        else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
        
        cell.wrappedView.setup { view in
            view.setupCustomMargins(all: .large)
        }
        
        return cell
    }
    
    // MARK: - User Interaction

    @objc override func buttonTapped() {
        super.buttonTapped()
        
        interactor?.showOrderPreview(viewAction: .init())
    }
    
    // MARK: - BuyResponseDisplay
    
    func displayPaymentCards(responseDisplay: BuyModels.PaymentCards.ResponseDisplay) {
        view.endEditing(true)
        coordinator?.showCardSelector(cards: responseDisplay.allPaymentCards, selected: { [weak self] selectedCard in
            self?.interactor?.setAssets(viewAction: .init(card: selectedCard))
        })
    }
    
    func displayAssets(responseDisplay actionResponse: BuyModels.Assets.ResponseDisplay) {
        LoadingView.hide()
        
        guard let fromSection = sections.firstIndex(of: Models.Sections.from),
              let toSection = sections.firstIndex(of: Models.Sections.to),
              let fromCell = tableView.cellForRow(at: .init(row: 0, section: fromSection)) as? WrapperTableViewCell<SwapCurrencyView>,
              let toCell = tableView.cellForRow(at: .init(row: 0, section: toSection)) as? WrapperTableViewCell<CardSelectionView>
        else { return continueButton.wrappedView.isEnabled = false }
        
        fromCell.wrappedView.setup(with: actionResponse.cryptoModel)
        toCell.wrappedView.setup(with: actionResponse.cardModel)
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
        continueButton.wrappedView.isEnabled = dataStore?.isFormValid ?? false
    }
    
    func displayExchangeRate(responseDisplay: BuyModels.Rate.ResponseDisplay) {
        LoadingView.hide()
        
        guard let section = sections.firstIndex(of: Models.Sections.rate),
              let cell = tableView.cellForRow(at: .init(row: 0, section: section)) as? WrapperTableViewCell<ExchangeRateView>
        else { return continueButton.wrappedView.isEnabled = false }
        
        cell.setup { view in
            view.setup(with: responseDisplay)
            view.completion = { [weak self] in
                self?.interactor?.getExchangeRate(viewAction: .init())
            }
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func displayOrderPreview(responseDisplay: BuyModels.OrderPreview.ResponseDisplay) {
        coordinator?.showOrderPreview(coreSystem: dataStore?.coreSystem,
                                      keyStore: dataStore?.keyStore,
                                      to: dataStore?.toAmount,
                                      from: dataStore?.from,
                                      card: dataStore?.paymentCard,
                                      quote: dataStore?.quote,
                                      networkFee: dataStore?.networkFee,
                                      expirationTimestamp: dataStore?.expirationTimestamp ?? 0)
    }
    
    // MARK: - Additional Helpers
}
