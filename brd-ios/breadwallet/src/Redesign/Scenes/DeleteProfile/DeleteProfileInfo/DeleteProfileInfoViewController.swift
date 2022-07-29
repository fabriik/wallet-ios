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
    
    // TODO: Localize.
    override var sceneLeftAlignedTitle: String? { return "You are about to delete your Fabriik account." }
    
    private var recoveryKeyFlowNextButton: FEButton?
    
    lazy var confirmButton: FEButton = {
        let button = FEButton()
        return button
    }()
    
    // MARK: - Overrides
    
    override func setupSubviews() {
        super.setupSubviews()
        
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
        confirmButton.setup(with: .init(title: "Confirm", enabled: false))
        
        confirmButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
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
        })) { [weak self] nextButton in
            self?.recoveryKeyFlowNextButton = nextButton
            self?.recoveryKeyFlowNextButton?.isEnabled = false
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
            self?.coordinator?.hidePopup()
            self?.interactor?.wipeWallet(viewAction: .init())
        } ])
    }
    
    func displayToggleTickbox(responseDisplay: DeleteProfileInfoModels.Tickbox.ResponseDisplay) {
        confirmButton.setup(with: .init(title: "Confirm", enabled: responseDisplay.model.enabled))
    }

    override func displayMessage(responseDisplay: MessageModels.ResponseDisplays) {
        super.displayMessage(responseDisplay: responseDisplay)
        
        recoveryKeyFlowNextButton?.isEnabled = true
    }
    
    // MARK: - Additional Helpers
}
