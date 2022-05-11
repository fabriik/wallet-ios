//
//  DemoViewController.swift
//  breadwallet
//
//  Created by Rok on 09/05/2022.
//
//

import UIKit

class DemoViewController: BaseTableViewController<DemoCoordinator,
                          DemoInteractor,
                          DemoPresenter,
                          DemoStore>,
                          DemoResponseDisplays {
    typealias Models = DemoModels

    // MARK: - Overrides

    override func setupSubviews() {
        super.setupSubviews()
        
        tableView.frame = view.frame
        tableView.register(WrapperTableViewCell<FELabel>.self)
        tableView.register(WrapperTableViewCell<FEButton>.self)
        
        sections = [
            Models.Section.demo,
            Models.Section.button
        ]
        sectionRows = [
            Models.Section.button: [
                "Click me!!",
                "Dont Click me please!!"
            ]]
    }
    
    // MARK: - User Interaction
    // MARK: - DemoResponseDisplay
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section] as? Models.Section
        
        let cell: UITableViewCell
        switch section {
        case .demo:
            cell = self.tableView(tableView, labelCellForRowAt: indexPath)
            
        case .button:
            cell = self.tableView(tableView, buttonCellForRowAt: indexPath)
            
        default:
            cell = super.tableView(tableView, cellForRowAt: indexPath)
        }
        
        (cell as? Marginable)?.setupCustomMargins(all: .extraHuge)
        cell.layoutIfNeeded()
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, labelCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = sections[indexPath.section] as? Models.Section,
              let text = sectionRows[section]?[indexPath.row] as? String,
              let cell: WrapperTableViewCell<FELabel> = tableView.dequeueReusableCell(for: indexPath)
        else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
        
        cell.setup { label in
            label.setup(with: .text(text))
            label.configure(with: .init(font: .boldSystemFont(ofSize: 25), textColor: .blue))
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, buttonCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = sections[indexPath.section] as? Models.Section,
              let text = sectionRows[section]?[indexPath.row] as? String,
              let cell: WrapperTableViewCell<FEButton> = tableView.dequeueReusableCell(for: indexPath)
        else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
        
        cell.setup { button in
            button.setup(with: .init(title: text))
            button.configure(with: Presets.Button.primary)
        }
        
        return cell
        
    }

    // MARK: - Additional Helpers
}
