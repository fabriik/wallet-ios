//
// Created by Equaleyes Solutions Ltd
//

import UIKit

class AccountVerificationViewController: BaseTableViewController<KYCCoordinator,
                                         AccountVerificationInteractor,
                                         AccountVerificationPresenter,
                                         AccountVerificationStore>,
                                         AccountVerificationResponseDisplays {
    typealias Models = AccountVerificationModels

    override var sceneLeftAlignedTitle: String? {
        // TODO: localize
        return "Account Verification"
    }
    
    // MARK: - Overrides
    
    override func setupSubviews() {
        super.setupSubviews()
        
        tableView.register(WrapperTableViewCell<VerificationView>.self)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section] as? Models.Section
        
        let cell: UITableViewCell
        switch section {
            
        case .verificationLevel:
            cell = self.tableView(tableView, verificationCellForRowAt: indexPath)

        default:
            cell = super.tableView(tableView, cellForRowAt: indexPath)
        }
        
        cell.setupCustomMargins(vertical: .huge, horizontal: .large)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, verificationCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        guard let model = sectionRows[section]?[indexPath.row] as? VerificationViewModel,
              let cell: WrapperTableViewCell<VerificationView> = tableView.dequeueReusableCell(for: indexPath)
        else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
        cell.setup { view in
            view.setup(with: model)
            let configs = [
                Presets.VerificationView.verified,
                Presets.VerificationView.pending,
                Presets.VerificationView.resubmit
            ]
            
            let config: VerificationConfiguration
            switch (model.kyc, model.status) {
            case (.levelOne, .levelOne),
                (.levelOne, .levelTwo),
                (.levelTwo, .levelTwo(.levelTwo)):
                config = configs[0]
                
            case (.levelOne, _):
                config = configs[1]
                
            case (.levelTwo, .levelTwo(.resubmit)),
                (.levelTwo, .levelTwo(.expired)),
                (.levelTwo, .levelTwo(.declined)):
                config = configs[2]
                
            default:
                config = configs[1]
            }
            
            view.configure(with: config)
        }
        cell.setupCustomMargins(all: .extraSmall)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        interactor?.startVerification(viewAction: .init(level: indexPath.row))
    }

    // MARK: - User Interaction

    // MARK: - AccountVerificationResponseDisplay
    func displayStartVerification(responseDisplay: AccountVerificationModels.Start.ResponseDisplay) {
        switch responseDisplay.level {
        case .one:
            coordinator?.showKYCLevelOne()
            
        case .two:
            coordinator?.showKYCLevelTwo()
        }
    }

    // MARK: - Additional Helpers
}
