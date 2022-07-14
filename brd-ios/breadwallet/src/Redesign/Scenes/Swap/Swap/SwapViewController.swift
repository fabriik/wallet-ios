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
    
    lazy var confirmButton: FEButton = {
        let button = FEButton()
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
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.snp.bottomMargin)
            make.leading.equalToSuperview().inset(Margins.large.rawValue)
            make.height.equalTo(ButtonHeights.common.rawValue)
        }
        
        tableView.snp.remakeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(confirmButton.snp.top)
        }
        confirmButton.configure(with: Presets.Button.primary)
        confirmButton.setup(with: .init(title: "Confirm"))
        confirmButton.isEnabled = false
        
        confirmButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
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
            
        default:
            cell = UITableViewCell()
        }
        
        cell.setupCustomMargins(all: .large)
        
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
            
            view.assetsSelectionCallback = { [weak self] in
                self?.coordinator?.showAssetSelector { [weak self] model in
                    guard model != nil else { return }
                    
                    self?.interactor?.assetSelected(viewAction: .init())
                }
            }
            
            view.contentSizeChanged = { [weak self] in
                self?.tableView.beginUpdates()
                self?.tableView.endUpdates()
            }
        }
        
        return cell
    }
    
    // MARK: - User Interaction

    @objc override func buttonTapped() {
        super.buttonTapped()
        
        // TODO: Confirm logic
    }
    
    // MARK: - SwapResponseDisplay
    
    func displaySetAmount(responseDisplay: SwapModels.Amounts.ResponseDisplay) {
        confirmButton.isEnabled = responseDisplay.shouldEnableConfirm
        
        guard let section = sections.firstIndex(of: Models.Sections.swapCard),
              let cell = tableView.cellForRow(at: .init(row: 0, section: section)) as? WrapperTableViewCell<MainSwapView> else { return }
        
        let model = responseDisplay.amounts
        
        cell.setup { view in
            view.setup(with: model)
        }
    }
    
    // MARK: - Additional Helpers
}
