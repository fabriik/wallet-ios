// 
//  BaseTableViewController.swift
//  breadwallet
//
//  Created by Rok on 10/05/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

class BaseTableViewController<C: CoordinatableRoutes,
                              I: Interactor & FetchViewActions,
                              P: Presenter & FetchActionResponses,
                              DS: BaseDataStore & NSObject>: VIPTableViewController<C, I, P, DS>,
                                                                              FetchResponseDisplays {
    override var isModalDismissableEnabled: Bool { return true }
    override var dismissText: String { return "close" }

    // MARK: - Cleaner Swift Setup

    lazy var emptyStateView: UIView = {
        let view = UIView()
        return view
    }()

    override func setupSubviews() {
        super.setupSubviews()
        
        // TODO: register proper accessoryViews
        tableView.registerAccessoryView(WrapperAccessoryView<FELabel>.self)
        tableView.registerAccessoryView(WrapperAccessoryView<FEButton>.self)
        // TODO: register base cells
        tableView.register(WrapperTableViewCell<FELabel>.self)
        tableView.register(WrapperTableViewCell<FEButton>.self)
        tableView.register(WrapperTableViewCell<FETextField>.self)
        tableView.register(WrapperTableViewCell<WrapperView<FEInfoView>>.self)
        
        // eg.
//        tableView.register(WrapperCell<WrapperView<AnimationImageView>>.self)
    }

    override func prepareData() {
        super.prepareData()
        interactor?.getData(viewAction: .init())
    }

    // MARK: ResponseDisplay
    func displayData(responseDisplay: FetchModels.Get.ResponseDisplay) {
        sections = responseDisplay.sections
        sectionRows = responseDisplay.sectionRows
        tableView.reloadData()
        tableView.backgroundView?.isHidden = !sections.isEmpty
    }

    // MARK: UITableViewDataSource
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let type = (sections[section] as? Sectionable)?.header
        return self.tableView(tableView, accessoryViewForType: type, for: section) { [weak self] in
            self?.tableView(tableView, didSelectHeaderIn: section)
        }
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let type = (sections[section] as? Sectionable)?.footer
        return self.tableView(tableView, accessoryViewForType: type, for: section) { [weak self] in
            self?.tableView(tableView, didSelectFooterIn: section)
        }
    }

    // MARK: Headers/Footer dequeuing
    func tableView(_ tableView: UITableView, accessoryViewForType type: AccessoryType?, for section: Int, callback: @escaping (() -> Void)) -> UIView? {
        let view: UIView?
        switch type {
        case .plain(let string):
            view = self.tableView(tableView, supplementaryViewWith: string)

        case .attributed(let attributedString):
            view = self.tableView(tableView, supplementaryViewWith: attributedString)

        case .action(let title):
            view = self.tableView(tableView, supplementaryViewWith: title, for: section, callback: callback)

        default:
            view = UIView(frame: .zero)
        }
        (view as? Marginable)?.setupCustomMargins(vertical: .small, horizontal: .small)

        return view
    }
    
    private func tableView(_ tableView: UITableView, supplementaryViewWith text: String?) -> UIView? {
        guard let view: WrapperAccessoryView<FELabel> = tableView.dequeueAccessoryView(),
              let text = text
        else { return UIView(frame: .zero) }

        view.setup { view in
            view.setup(with: .text(text))
            view.configure(with: Presets.Label.secondary)
        }

        return view
    }

    private func tableView(_ tableView: UITableView, supplementaryViewWith attributedText: NSAttributedString?) -> UIView? {
        guard let view: WrapperAccessoryView<FELabel> = tableView.dequeueAccessoryView(),
              let text = attributedText
        else { return UIView(frame: .zero) }

        view.setup { view in
            // TODO: attributed string support
            view.setup(with: .attributedText(text))
            view.configure(with: Presets.Label.secondary)
        }

        return view
    }

    private func tableView(_ tableView: UITableView, supplementaryViewWith buttonTitle: String?, for section: Int, callback: @escaping (() -> Void)) -> UIView? {
        // TODO: custom button (actionButton look alike?)
        guard let view: WrapperAccessoryView<FEButton> = tableView.dequeueAccessoryView(),
              let text = buttonTitle
        else { return UIView(frame: .zero) }

        view.setup { view in
            view.setup(with: .init(title: text))
            view.configure(with: Presets.Button.secondary)
            // TODO: add callback to suplementaryViewTapped
        }

        return view
    }
    
    func tableView(_ tableView: UITableView, supplementaryViewTapped section: Int) {
        // TODO: override in class to handle suplementary button events
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
    
    // MARK: Custom cells
    // TODO: add dequeue methos for other standard cells
    func tableView(_ tableView: UITableView, labelCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        guard let text = sectionRows[section]?[indexPath.row] as? String,
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
        let section = sections[indexPath.section]
        guard let text = sectionRows[section]?[indexPath.row] as? String,
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
    
    func tableView(_ tableView: UITableView, textFieldCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        guard let model = sectionRows[section]?[indexPath.row] as? TextFieldModel,
              let cell: WrapperTableViewCell<FETextField> = tableView.dequeueReusableCell(for: indexPath)
        else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
        
        cell.setup { button in
            button.setup(with: model)
            button.configure(with: Presets.TexxtField.primary)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, infoViewCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        guard let model = sectionRows[section]?[indexPath.row] as? InfoViewModel,
              let cell: WrapperTableViewCell<WrapperView<FEInfoView>> = tableView.dequeueReusableCell(for: indexPath)
        else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
        
        cell.setup { view in
            view.setup { button in
                button.setup(with: model)
                button.configure(with: Presets.InfoView.primary)
                button.setupCustomMargins(all: .extraHuge)
            }
            view.setupCustomMargins(all: .medium)
        }
        cell.setupCustomMargins(all: .extraSmall)
        
        return cell
    }

    // MARK: UserInteractions
    func didSelectItem(in section: Int, row: Int) {
    }

    func didLongPressItem(in section: Int, row: Int) {
    }
}
