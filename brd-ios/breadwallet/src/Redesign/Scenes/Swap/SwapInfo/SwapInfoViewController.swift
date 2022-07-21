//
//  SwapInfoViewController.swift
//  breadwallet
//
//  Created by Dijana Angelovska on 13.7.22.
//
//

import UIKit

class SwapInfoViewController: BaseTableViewController<SwapCoordinator, SwapInfoInteractor, SwapInfoPresenter,
                              SwapInfoStore>,
                              SwapInfoResponseDisplays {
    typealias Models = SwapInfoModels
    
    lazy var backHomeButton: FEButton = {
        let button = FEButton()
        return button
    }()
    
    lazy var swapDetails: FELabel = {
        let label = FELabel()
        let tap = UITapGestureRecognizer(target: self, action: #selector(swapDetailsTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
        return label
    }()
    
    // MARK: - Overrides
    
    override var closeImage: UIImage? { return .init(named: "")}
    
    override func setupSubviews() {
        super.setupSubviews()
        
        tableView.snp.updateConstraints { make in
            make.top.equalToSuperview().inset(ViewSizes.extraLarge.rawValue * 2)
        }
        view.addSubview(backHomeButton)
        backHomeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().inset(Margins.large.rawValue)
            make.height.equalTo(ButtonHeights.common.rawValue)
        }
        
        view.addSubview(swapDetails)
        swapDetails.snp.makeConstraints { make in
            make.top.equalTo(backHomeButton.snp.bottom).offset(Margins.small.rawValue)
            make.centerX.equalToSuperview()
            make.leading.height.equalTo(backHomeButton)
            make.bottom.equalTo(view.snp.bottomMargin).offset(Margins.large.rawValue)
        }
        
        // TODO: Localize
        backHomeButton.configure(with: Presets.Button.primary)
        backHomeButton.setup(with: .init(title: "Back to Home"))
        
        swapDetails.configure(with: .init(font: Fonts.button, textColor: LightColors.primary, textAlignment: .center))
        swapDetails.setup(with: .text("Swap details"))
        
        backHomeButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
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
        
        cell.setupCustomMargins(all: .extraHuge)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleLabelCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        guard let model = sectionRows[section]?[indexPath.row] as? LabelViewModel,
              let cell: WrapperTableViewCell<FELabel> = tableView.dequeueReusableCell(for: indexPath)
        else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
        
        cell.setup { view in
            view.configure(with: .init(font: Fonts.Title.five, textColor: LightColors.Text.one, textAlignment: .center))
            view.setup(with: model)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, descriptionLabelCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        guard let model = sectionRows[section]?[indexPath.row] as? LabelViewModel,
              let cell: WrapperTableViewCell<FELabel> = tableView.dequeueReusableCell(for: indexPath)
        else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
        
        cell.setup { view in
            view.configure(with: .init(font: Fonts.Body.one, textColor: LightColors.Text.two, textAlignment: .center))
            view.setup(with: model)
            view.setupCustomMargins(vertical: .extraHuge, horizontal: .extraHuge)
            view.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.leading.trailing.equalToSuperview().inset(Margins.extraHuge.rawValue)
            }
        }
        
        return cell
    }
    
    // MARK: - User Interaction
    
    override func buttonTapped() {
        super.buttonTapped()
        
        coordinator?.goBack()
    }
    
    @objc func swapDetailsTapped() {
        // TODO: Add action when ready
        coordinator?.showSwapDetails()
    }
    
    // MARK: - SwapInfoResponseDisplay
    
    // MARK: - Additional Helpers
}
