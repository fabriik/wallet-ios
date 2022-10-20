//
//  TokenCell.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2018-04-08.
//  Copyright © 2018-2019 Breadwinner AG. All rights reserved.
//

import UIKit

enum EditWalletType {
    case manage
    case add
    
    var addTitle: String {
        return self == .manage ? L10n.TokenList.show : L10n.TokenList.add
    }
    
    var removeTitle: String {
        return self == .manage ? L10n.TokenList.hide : L10n.TokenList.remove
    }
}

class ManageCurrencyCell: UITableViewCell {
    
    static let cellIdentifier = "ManageCurrencyCell"

    private let header = UILabel(font: Fonts.Body.one, color: LightColors.Text.one)
    private let icon = UIImageView()
    private let button = ToggleButton(normalTitle: L10n.TokenList.add,
                                      normalColor: LightColors.primary,
                                      selectedTitle: L10n.TokenList.hide,
                                      selectedColor: LightColors.Error.one)
    private var identifier: CurrencyId = ""
    private var listType: EditWalletType = .add
    private var isCurrencyHidden = false
    private var isCurrencyRemovable = true
    
    var didAddIdentifier: ((CurrencyId) -> Void)?
    var didRemoveIdentifier: ((CurrencyId) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    func set(currency: CurrencyMetaData, balance: Amount?, listType: EditWalletType, isHidden: Bool, isRemovable: Bool) {
        header.text = currency.name
        icon.image = currency.imageSquareBackground
        isCurrencyHidden = isHidden
        isCurrencyRemovable = isRemovable
        identifier = currency.uid
        self.listType = listType
        setState()
    }

    private func setupViews() {
        header.adjustsFontSizeToFitWidth = true
        
        addSubviews()
        addConstraints()
        setInitialData()
    }

    private func addSubviews() {
        contentView.addSubview(header)
        contentView.addSubview(icon)
        contentView.addSubview(button)
    }

    private func addConstraints() {
        icon.constrain([
            icon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: C.padding[2]),
            icon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            icon.heightAnchor.constraint(equalToConstant: 36.0),
            icon.widthAnchor.constraint(equalToConstant: 36.0)])
        header.constrain([
            header.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: C.padding[1]),
            header.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)])
        button.constrain([
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -C.padding[2]),
            button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            button.heightAnchor.constraint(equalToConstant: 36.0),
            button.widthAnchor.constraint(equalToConstant: 70.0),
            button.leadingAnchor.constraint(greaterThanOrEqualTo: header.trailingAnchor, constant: C.padding[1])])
    }

    private func setInitialData() {
        selectionStyle = .none
        icon.contentMode = .scaleAspectFill
    }
    
    private func setState() {
        if listType == .add {
            button.setTitle(L10n.TokenList.add, for: .normal)
            button.setTitle(L10n.TokenList.remove, for: .selected)
        } else {
            button.setTitle(L10n.TokenList.remove, for: .normal)
            button.setTitle(L10n.TokenList.remove, for: .selected)
        }
        
        button.tap = strongify(self) { myself in
            if self.listType == .manage {
                myself.didRemoveIdentifier?(myself.identifier)
            } else if self.listType == .add {
                let isRemoveButton = myself.button.isSelected
                if isRemoveButton {
                    myself.didRemoveIdentifier?(myself.identifier)
                } else {
                    myself.didAddIdentifier?(myself.identifier)
                }
                myself.button.isSelected = !isRemoveButton
            }
        }
        if listType == .add {
            button.isSelected = !isCurrencyHidden
        } else {
            button.isEnabled = isCurrencyRemovable
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
