//
//  CheckListViewController.swift
//  breadwallet
//
//  Created by Rok on 06/06/2022.
//
//

import UIKit

class CheckListViewController: BaseTableViewController<BaseCoordinator,
                               CheckListInteractor,
                               CheckListPresenter,
                               CheckListStore>,
                               CheckListResponseDisplays {
    typealias Models = CheckListModels

    override var sceneLeftAlignedTitle: String? { return "Checklist base VC" }
    var checklistTitle: LabelViewModel { return .text("OVERRIDE IN SUBCLASS") }
    var checkmarks: [ChecklistItemViewModel] { return [] }
    
    var continueCallback: (() -> Void)?
    
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
        
        confirmButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    override func prepareData() {
        sections = [
            Models.Sections.title,
            Models.Sections.checkmarks
        ]
        
        sectionRows = [
            Models.Sections.title: [checklistTitle],
            Models.Sections.checkmarks: checkmarks
        ]
        
        // TODO: add multi button support
        confirmButton.setup(with: .init(title: "Confirm"))
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        switch sections[indexPath.section] as? Models.Sections {
        case .title:
            cell =  self.tableView(tableView, labelCellForRowAt: indexPath)
            (cell as? WrapperTableViewCell<FELabel>)?.wrappedView.configure(with: .init(font: Fonts.Title.six, textColor: LightColors.Text.one))
            
        case .checkmarks:
            cell = self.tableView(tableView, checkmarkCellForRowAt: indexPath)
            
        default:
            cell = UITableViewCell()
        }
        
        cell.setupCustomMargins(vertical: .huge, horizontal: .extraHuge)
        
        return cell
    }
    
    // MARK: - User Interaction
    override func buttonTapped() {
        super.buttonTapped()
        
        print("navigate in subclass!")
    }
    
    // MARK: - CheckListResponseDisplay
    
    // MARK: - Additional Helpers
}
