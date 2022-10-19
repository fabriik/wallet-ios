//
//  DeleteProfileInfoViewController.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 19/07/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

class DeleteProfileInfoViewController: BaseTableViewController<DeleteProfileInfoCoordinator,
                                       DeleteProfileInfoInteractor,
                                       DeleteProfileInfoPresenter,
                                       DeleteProfileInfoStore>,
                                       DeleteProfileInfoResponseDisplays {
    typealias Models = DeleteProfileInfoModels
    
    override var sceneLeftAlignedTitle: String? { return L10n.AccountDelete.deleteAccountTitle }
    
    private var recoveryKeyFlowNextButton: FEButton?
    private var recoveryKeyFlowBarButton: UIBarButtonItem?
    
    lazy var confirmButton: WrapperView<FEButton> = {
        let button = WrapperView<FEButton>()
        return button
    }()
    
    // MARK: - Overrides
    
    override func setupSubviews() {
        super.setupSubviews()
        
        view.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { make in
            make.centerX.leading.equalToSuperview()
            make.bottom.equalTo(view.snp.bottomMargin)
        }
        
        confirmButton.wrappedView.snp.makeConstraints { make in
            make.height.equalTo(FieldHeights.common.rawValue)
            make.edges.equalTo(confirmButton.snp.margins)
        }
        confirmButton.setupCustomMargins(top: .small, leading: .large, bottom: .large, trailing: .large)
        
        tableView.snp.remakeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(confirmButton.snp.top)
        }
        
        confirmButton.wrappedView.configure(with: Presets.Button.primary)
        confirmButton.wrappedView.setup(with: .init(title: L10n.Button.confirm, enabled: false))
        
        confirmButton.wrappedView.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        switch sections[indexPath.section] as? DeleteProfileInfoModels.Section {
        case .title:
            cell =  self.tableView(tableView, labelCellForRowAt: indexPath)
            (cell as? WrapperTableViewCell<FELabel>)?.wrappedView.configure(with: .init(font: Fonts.Title.six, textColor: LightColors.Text.one))
            
        case .checkmarks:
            cell = self.tableView(tableView, checkmarkCellForRowAt: indexPath)
            
        case .tickbox:
            cell = self.tableView(tableView, tickboxCellForRowAt: indexPath)
            
        default:
            cell = UITableViewCell()
        }
        
        cell.setupCustomMargins(vertical: .huge, horizontal: .large)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, checkmarkCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        guard let cell: WrapperTableViewCell<ChecklistItemView> = tableView.dequeueReusableCell(for: indexPath),
              let model = sectionRows[section]?[indexPath.row] as? ChecklistItemViewModel else {
            return UITableViewCell()
        }
        
        cell.setup { view in
            view.configure(with: .init())
            view.setup(with: model)
            view.setupCustomMargins(vertical: .medium)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, tickboxCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        guard let cell: WrapperTableViewCell<TickboxItemView> = tableView.dequeueReusableCell(for: indexPath),
              let model = sectionRows[section]?[indexPath.row] as? TickboxItemViewModel else {
            return UITableViewCell()
        }
        
        cell.setup { view in
            view.configure(with: .init())
            view.setup(with: model)
            
            view.didToggleTickbox = { [weak self] value in
                self?.tickboxToggled(value: value)
            }
        }
        
        return cell
    }
    
    // MARK: - User Interaction
    
    override func buttonTapped() {
        super.buttonTapped()
        
        guard let navigationController = coordinator?.navigationController, let keyStore = dataStore?.keyMaster else { return }
        RecoveryKeyFlowController.pushUnlinkWalletFlowWithoutIntro(from: navigationController,
                                                                   keyMaster: keyStore,
                                                                   phraseEntryReason: .validateForWipingWalletAndDeletingFromDevice({ [weak self] in
            self?.interactor?.deleteProfile(viewAction: .init())
        })) { [weak self] nextButton, barButton in
            self?.recoveryKeyFlowNextButton = nextButton
            self?.recoveryKeyFlowBarButton = barButton
            self?.recoveryKeyFlowNextButton?.isEnabled = false
            self?.recoveryKeyFlowBarButton?.isEnabled = false
        }
    }
    
    func tickboxToggled(value: Bool) {
        interactor?.toggleTickbox(viewAction: .init(value: value))
    }
    
    // MARK: - DeleteProfileInfoResponseDisplay
    
    func displayDeleteProfile(responseDisplay: DeleteProfileInfoModels.DeleteProfile.ResponseDisplay) {
        guard let navigationController = coordinator?.navigationController else { return }
        
        coordinator?.showPopup(on: navigationController,
                               blurred: false,
                               with: responseDisplay.popupViewModel,
                               config: responseDisplay.popupConfig,
                               closeButtonCallback: { [weak self] in
            self?.interactor?.wipeWallet(viewAction: .init())
        }, callbacks: [ { [weak self] in
            self?.interactor?.wipeWallet(viewAction: .init())
        } ])
    }
    
    func displayToggleTickbox(responseDisplay: DeleteProfileInfoModels.Tickbox.ResponseDisplay) {
        confirmButton.wrappedView.setup(with: .init(title: L10n.Button.confirm, enabled: responseDisplay.model.enabled))
    }

    override func displayMessage(responseDisplay: MessageModels.ResponseDisplays) {
        super.displayMessage(responseDisplay: responseDisplay)
        
        recoveryKeyFlowNextButton?.isEnabled = true
        recoveryKeyFlowBarButton?.isEnabled = true
    }
    
    // MARK: - Additional Helpers
}
