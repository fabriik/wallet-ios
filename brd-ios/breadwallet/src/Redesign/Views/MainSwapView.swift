//
//  MainSwapView.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 05/07/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit
import SnapKit

struct MainSwapConfiguration: Configurable {
    var shadow: ShadowConfiguration?
    var background: BackgroundConfiguration?
}

struct MainSwapViewModel: ViewModel {
    var selectedBaseCurrency: String
    var selectedBaseCurrencyIcon: UIImage?
    
    var selectedTermCurrency: String
    var selectedTermCurrencyIcon: UIImage?
    
    var fromFiatAmount: Decimal?
    var fromFiatAmountString: String?
    
    var fromCryptoAmount: Decimal?
    var fromCryptoAmountString: String?
    
    var toFiatAmount: Decimal?
    var toFiatAmountString: String?
    
    var toCryptoAmount: Decimal?
    var toCryptoAmountString: String?
    
    var balanceString: String
    
    var topFeeString: String?
    var bottomFeeString: String?
    
    var shouldShowFees: Bool = false
}

class MainSwapView: FEView<MainSwapConfiguration, MainSwapViewModel> {
    private lazy var containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.backgroundColor = .clear
        stack.axis = .vertical
        stack.distribution = .fill
        return stack
    }()
    
    private lazy var baseSwapCurrencyView: SwapCurrencyView = {
        let view = SwapCurrencyView()
        return view
    }()
    
    private lazy var termSwapCurrencyView: SwapCurrencyView = {
        let view = SwapCurrencyView()
        return view
    }()
    
    private lazy var dividerWithButtonView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = LightColors.Outline.two
        return view
    }()
    
    private lazy var swapButton: FEButton = {
        let view = FEButton()
        view.setImage(UIImage(named: "swap"), for: .normal)
        view.addTarget(self, action: #selector(switchPlacesButtonTapped), for: .touchUpInside)
        return view
    }()
    
    var didChangeFromFiatAmount: ((String?) -> Void)?
    var didChangeFromCryptoAmount: ((String?) -> Void)?
    var didTapFromAssetsSelection: (() -> Void)?
    
    var didChangeToFiatAmount: ((String?) -> Void)?
    var didChangeToCryptoAmount: ((String?) -> Void)?
    var didTapToAssetsSelection: (() -> Void)?
    
    var didChangePlaces: (() -> Void)?
    
    var contentSizeChanged: (() -> Void)?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configure(background: config?.background)
        configure(shadow: config?.shadow)
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        content.addSubview(containerStackView)
        containerStackView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        containerStackView.addArrangedSubview(baseSwapCurrencyView)
        containerStackView.addArrangedSubview(dividerWithButtonView)
        containerStackView.addArrangedSubview(termSwapCurrencyView)
        
        dividerWithButtonView.snp.makeConstraints { make in
            // TODO: Add to constants.
            make.height.equalTo(32)
        }
        
        dividerWithButtonView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.height.width.equalTo(1)
            make.leading.trailing.equalToSuperview()
            make.center.equalToSuperview()
        }
        
        dividerWithButtonView.addSubview(swapButton)
        swapButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        baseSwapCurrencyView.currencySelectorStackView
            .addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                         action: #selector(topCurrencyTapped(_:))))
        termSwapCurrencyView.currencySelectorStackView
            .addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                         action: #selector(bottomCurrencyTapped(_:))))
        
        getAmounts()
    }
    
    private func getAmounts() {
        baseSwapCurrencyView.didChangeFiatAmount = { [weak self] amount in
            self?.didChangeFromFiatAmount?(amount)
            self?.toggleFeeAndAmountsStackView()
        }
        
        baseSwapCurrencyView.didChangeCryptoAmount = { [weak self] amount in
            self?.didChangeFromCryptoAmount?(amount)
            self?.toggleFeeAndAmountsStackView()
        }
        
        termSwapCurrencyView.didChangeFiatAmount = { [weak self] amount in
            self?.didChangeToFiatAmount?(amount)
            self?.toggleFeeAndAmountsStackView()
        }
        
        termSwapCurrencyView.didChangeCryptoAmount = { [weak self] amount in
            self?.didChangeToCryptoAmount?(amount)
            self?.toggleFeeAndAmountsStackView()
        }
    }
    
    override func configure(with config: MainSwapConfiguration?) {
        guard let config = config else { return }
        super.configure(with: config)
        
        configure(shadow: config.shadow)
    }
    
    override func setup(with viewModel: MainSwapViewModel?) {
        guard let viewModel = viewModel else { return }
        super.setup(with: viewModel)
        
        baseSwapCurrencyView.setup(with: .init(selectedCurrency: viewModel.selectedBaseCurrency,
                                              selectedCurrencyIcon: viewModel.selectedBaseCurrencyIcon,
                                              fiatAmountString: viewModel.fromFiatAmountString,
                                              cryptoAmountString: viewModel.fromCryptoAmountString,
                                              titleString: String(format: "I have %@", viewModel.balanceString),
                                              feeString: viewModel.topFeeString))
        
        termSwapCurrencyView.setup(with: .init(selectedCurrency: viewModel.selectedTermCurrency,
                                                 selectedCurrencyIcon: viewModel.selectedTermCurrencyIcon,
                                                 fiatAmountString: viewModel.toFiatAmountString,
                                                 cryptoAmountString: viewModel.toCryptoAmountString,
                                                 titleString: "I want",
                                                 feeString: viewModel.bottomFeeString))
        
        toggleFeeAndAmountsStackView(animated: false)
    }
    
    // MARK: - User interaction
    
    @objc private func topCurrencyTapped(_ sender: Any?) {
        didTapFromAssetsSelection?()
    }
    
    @objc private func bottomCurrencyTapped(_ sender: Any?) {
        didTapToAssetsSelection?()
    }
    
    @objc private func switchPlacesButtonTapped(_ sender: UIButton?) {
        endEditing(true)
        
        didChangePlaces?()

        SwapCurrencyView.animateSwitchPlaces(sender: sender,
                                             baseSwapCurrencyView: baseSwapCurrencyView,
                                             termSwapCurrencyView: termSwapCurrencyView)
        
        toggleFeeAndAmountsStackView()
        
    }
    
    private func toggleFeeAndAmountsStackView(animated: Bool = true) {
        guard let viewModel = viewModel else { return }
        
        baseSwapCurrencyView.toggleFeeAndAmountsStackView(state: viewModel.shouldShowFees ? .shown : .hidden, animated: animated)
        termSwapCurrencyView.toggleFeeAndAmountsStackView(state: viewModel.shouldShowFees ? .shown : .hidden, animated: animated)
        contentSizeChanged?()
    }
}
