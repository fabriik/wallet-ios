//
//  BillingAddressViewController.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 01/08/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

class BillingAddressViewController: BaseTableViewController<BuyCoordinator,
                                    BillingAddressInteractor,
                                    BillingAddressPresenter,
                                    BillingAddressStore>,
                                    BillingAddressResponseDisplays {
    typealias Models = BillingAddressModels
    
    override var sceneTitle: String? {
        // TODO: localize
        return "Billing address"
    }
    private var isValid = false

    // MARK: - Overrides
    
    override func setupSubviews() {
        super.setupSubviews()
        
        tableView.register(WrapperTableViewCell<DoubleHorizontalTextboxView>.self)
        
        setRoundedShadowBackground()
    }
    
    override func prepareData() {
        super.prepareData()
        
        LoadingView.show()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        switch sections[indexPath.section] as? Models.Section {
        case .name:
            cell = self.tableView(tableView, nameCellForRowAt: indexPath)
            
        case .country:
            cell = self.tableView(tableView, countryTextFieldCellForRowAt: indexPath)
            
        case .stateProvince:
            cell = self.tableView(tableView, textFieldCellForRowAt: indexPath)
            
        case .cityAndZipPostal:
            cell = self.tableView(tableView, cityAndZipPostalCellForRowAt: indexPath)
            
        case .address:
            cell = self.tableView(tableView, textFieldCellForRowAt: indexPath)
            
        case .confirm:
            cell = self.tableView(tableView, buttonCellForRowAt: indexPath)
            
        default:
            cell = UITableViewCell()
        }
        
        cell.contentView.setupCustomMargins(vertical: .small, horizontal: .zero)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, nameCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        guard let cell: WrapperTableViewCell<DoubleHorizontalTextboxView> = tableView.dequeueReusableCell(for: indexPath),
              let model = sectionRows[section]?[indexPath.row] as? DoubleHorizontalTextboxViewModel else {
            return UITableViewCell()
        }
        
        cell.setup { view in
            view.configure(with: .init())
            view.setup(with: model)
            
            view.contentSizeChanged = {
                tableView.beginUpdates()
                tableView.endUpdates()
            }
            
            view.valueChanged = { [weak self] first, second in
                self?.interactor?.nameSet(viewAction: .init(first: first, last: second))
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, cityAndZipPostalCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        guard let cell: WrapperTableViewCell<DoubleHorizontalTextboxView> = tableView.dequeueReusableCell(for: indexPath),
              let model = sectionRows[section]?[indexPath.row] as? DoubleHorizontalTextboxViewModel else {
            return UITableViewCell()
        }
        
        cell.setup { view in
            view.configure(with: .init())
            view.setup(with: model)
            
            view.contentSizeChanged = {
                tableView.beginUpdates()
                tableView.endUpdates()
            }
            
            view.valueChanged = { [weak self] first, second in
                self?.interactor?.cityAndZipPostalSet(viewAction: .init(city: first, zipPostal: second))
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, countryTextFieldCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        guard let model = sectionRows[section]?[indexPath.row] as? TextFieldModel,
              let cell: WrapperTableViewCell<FETextField> = tableView.dequeueReusableCell(for: indexPath)
        else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
        
        cell.setup { view in
            view.configure(with: Presets.TextField.two)
            view.setup(with: model)
            
            view.contentSizeChanged = {
                tableView.beginUpdates()
                tableView.endUpdates()
            }
            
            view.isUserInteractionEnabled = false
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, buttonCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        guard var model = sectionRows[section]?[indexPath.row] as? ButtonViewModel,
              let cell: WrapperTableViewCell<FEButton> = tableView.dequeueReusableCell(for: indexPath)
        else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
        
        model.enabled = isValid
        cell.setup { view in
            view.configure(with: Presets.Button.primary)
            view.setup(with: model)
            view.setupCustomMargins(vertical: .large, horizontal: .large)
            
            view.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: move to cell tap callback
        switch sections[indexPath.section] as? Models.Section {
        case .country:
            guard let index = sections.firstIndex(of: Models.Section.country),
                  let cell = tableView.cellForRow(at: .init(row: 0, section: index)) as? WrapperTableViewCell<FETextField> else {
                return
            }
            
            // TODO: add a cycle to fetch countires and pass them to the coordinator (currently the coordinator does the call)
            coordinator?.showCountrySelector { [weak self] model in
                cell.wrappedView.animateTo(state: .filled, withAnimation: false)
                self?.interactor?.countrySelected(viewAction: .init(code: model?.code, countryFullName: model?.name))
            }
            
        default:
            return
        }
    }
    
    // MARK: - User Interaction
    @objc override func buttonTapped() {
        super.buttonTapped()
        
        interactor?.submit(vieAction: .init())
    }

    // MARK: - BillingAddressResponseDisplay
    func displayValidate(responseDisplay: BillingAddressModels.Validate.ResponseDisplay) {
        guard let section = sections.firstIndex(of: Models.Section.confirm),
              let cell = tableView.cellForRow(at: .init(row: 0, section: section)) as? WrapperTableViewCell<FEButton> else { return }
        
        isValid = responseDisplay.isValid
        cell.wrappedView.isEnabled = isValid
    }
    
    func displaySubmit(responseDisplay: BillingAddressModels.Submit.ResponseDisplay) {
        coordinator?.showOverlay(with: .success) {
            UserManager.shared.refresh { [weak self] _ in
                self?.coordinator?.goBack(completion: {
                    // TODO: .goBack() does not work!
                })
            }
        }
    }
    
    // MARK: - Additional Helpers
    
    override func textFieldDidUpdate(for indexPath: IndexPath, with text: String?, on section: AnyHashable) {
        super.textFieldDidUpdate(for: indexPath, with: text, on: section)
        
        switch section as? Models.Section {
        case .stateProvince:
            interactor?.stateProvinceSet(viewAction: .init(stateProvince: text))
            
        case .address:
            interactor?.addressSet(viewAction: .init(address: text))
            
        default:
            break
        }
    }
}
