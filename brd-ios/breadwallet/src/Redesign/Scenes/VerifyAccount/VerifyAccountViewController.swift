//
// Created by Equaleyes Solutions Ltd
//

import UIKit

class VerifyAccountViewController: BaseTableViewController<KYCCoordinator,
                                   VerifyAccountInteractor,
                                   VerifyAccountPresenter,
                                   VerifyAccountStore>,
                                   VerifyAccountResponseDisplays {
    
    typealias Models = VerifyAccountModels
    
    lazy var verifyButton: WrapperView<FEButton> = {
        let button = WrapperView<FEButton>()
        return button
    }()
    
    override func setupSubviews() {
        super.setupSubviews()
        
        view.addSubview(verifyButton)
        verifyButton.snp.makeConstraints { make in
            make.centerX.leading.equalToSuperview()
            make.bottom.equalTo(view.snp.bottomMargin)
        }
        
        verifyButton.wrappedView.snp.makeConstraints { make in
            make.height.equalTo(ButtonHeights.common.rawValue)
            make.edges.equalTo(verifyButton.snp.margins)
        }
        
        verifyButton.setupCustomMargins(top: .small, leading: .large, bottom: .large, trailing: .large)
        
        verifyButton.wrappedView.configure(with: Presets.Button.primary)
        verifyButton.wrappedView.setup(with: .init(title: L10n.Account.accountVerify))
        
        verifyButton.wrappedView.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    // MARK: - Overrides
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        switch sections[indexPath.section] as? Models.Section {
        case .image:
            cell = self.tableView(tableView, coverCellForRowAt: indexPath)
            
        case .title:
            cell = self.tableView(tableView, titleLabelCellForRowAt: indexPath)
            
        case .description:
            cell = self.tableView(tableView, descriptionLabelCellForRowAt: indexPath)
            
        default:
            cell = super.tableView(tableView, cellForRowAt: indexPath)
        }
        
        cell.setupCustomMargins(vertical: .huge, horizontal: .large)
        
        return cell
    }

    // MARK: - User Interaction
    
    override func buttonTapped() {
        super.buttonTapped()
        
        coordinator?.showVerifications()
    }

    // MARK: - VerifyAccountResponseDisplay

    // MARK: - Additional Helpers
}
