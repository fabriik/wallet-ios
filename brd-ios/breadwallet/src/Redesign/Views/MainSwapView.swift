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
    
    var fromFiatAmount: NSNumber
    var fromFiatAmountString: String?
    
    var fromCryptoAmount: NSNumber
    var fromCryptoAmountString: String?
    
    var toFiatAmount: NSNumber
    var toFiatAmountString: String?
    
    var toCryptoAmount: NSNumber
    var toCryptoAmountString: String?
}

class MainSwapView: FEView<MainSwapConfiguration, MainSwapViewModel> {
    private lazy var containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.backgroundColor = .clear
        stack.axis = .vertical
        stack.distribution = .fill
        return stack
    }()
    
    private lazy var topSwapCurrencyView: SwapCurrencyView = {
        let view = SwapCurrencyView()
        return view
    }()
    
    private lazy var bottomSwapCurrencyView: SwapCurrencyView = {
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
    var didChangeToFiatAmount: ((String?) -> Void)?
    var didChangeToCryptoAmount: ((String?) -> Void)?
    var assetsSelectionCallback: (() -> Void)?
    
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
        
        containerStackView.addArrangedSubview(topSwapCurrencyView)
        containerStackView.addArrangedSubview(dividerWithButtonView)
        containerStackView.addArrangedSubview(bottomSwapCurrencyView)
        
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
        
        topSwapCurrencyView.currencySelectorStackView
            .addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                         action: #selector(topCurrencyTapped(_:))))
        bottomSwapCurrencyView.currencySelectorStackView
            .addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                         action: #selector(bottomCurrencyTapped(_:))))
        
        getAmounts()
        
        topSwapCurrencyView.toggleFeeAndAmountsStackView(state: .hidden, animated: false)
        bottomSwapCurrencyView.toggleFeeAndAmountsStackView(state: .hidden, animated: false)
    }
    
    private func getAmounts() {
        topSwapCurrencyView.didChangeFiatAmount = { [weak self] amount in
            self?.didChangeFromFiatAmount?(amount)
        }
        
        topSwapCurrencyView.didChangeCryptoAmount = { [weak self] amount in
            self?.didChangeFromCryptoAmount?(amount)
        }
        
        bottomSwapCurrencyView.didChangeFiatAmount = { [weak self] amount in
            self?.didChangeToFiatAmount?(amount)
        }
        
        bottomSwapCurrencyView.didChangeCryptoAmount = { [weak self] amount in
            self?.didChangeToCryptoAmount?(amount)
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
        
        topSwapCurrencyView.setup(with: .init(selectedCurrency: viewModel.selectedBaseCurrency,
                                              selectedCurrencyIcon: viewModel.selectedBaseCurrencyIcon,
                                              fiatAmountString: viewModel.fromFiatAmountString,
                                              cryptoAmountString: viewModel.fromCryptoAmountString))
        
        bottomSwapCurrencyView.setup(with: .init(selectedCurrency: viewModel.selectedTermCurrency,
                                                 selectedCurrencyIcon: viewModel.selectedTermCurrencyIcon,
                                                 fiatAmountString: viewModel.toFiatAmountString,
                                                 cryptoAmountString: viewModel.toCryptoAmountString))
    }
    
    // MARK: - User interaction
    
    @objc private func topCurrencyTapped(_ sender: Any?) {
        assetsSelectionCallback?()
    }
    
    @objc private func bottomCurrencyTapped(_ sender: Any?) {
        assetsSelectionCallback?()
    }
    
    @objc private func switchPlacesButtonTapped(_ sender: UIButton?) {
        endEditing(true)
        
        SwapCurrencyView.animateSwitchPlaces(sender: sender,
                                             topSwapCurrencyView: topSwapCurrencyView,
                                             bottomSwapCurrencyView: bottomSwapCurrencyView)
        
        // Will be used..
//        topSwapCurrencyView.toggleFeeAndAmountsStackView(state: .shown, animated: true)
//        bottomSwapCurrencyView.toggleFeeAndAmountsStackView(state: .shown, animated: true)
//        contentSizeChanged?()
    }
}
