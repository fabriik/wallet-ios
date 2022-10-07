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
    var from: SwapCurrencyViewModel?
    var to: SwapCurrencyViewModel?
}

class MainSwapView: FEView<MainSwapConfiguration, MainSwapViewModel> {
    private lazy var containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.backgroundColor = .clear
        stack.axis = .vertical
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
    var didTapFromAssetsSelection: (() -> Void)? {
        get {
            return baseSwapCurrencyView.didTapSelectAsset
        }
        set {
            baseSwapCurrencyView.didTapSelectAsset = newValue
        }
    }
    var didChangeToFiatAmount: ((String?) -> Void)?
    var didChangeToCryptoAmount: ((String?) -> Void)?
    var didTapToAssetsSelection: (() -> Void)? {
        get {
            return termSwapCurrencyView.didTapSelectAsset
        }
        set {
            termSwapCurrencyView.didTapSelectAsset = newValue
        }
    }
    var didFinish: ((_ didSwitchPlaces: Bool) -> Void)?
    var contentSizeChanged: (() -> Void)? {
        didSet {
            baseSwapCurrencyView.didChangeContent = contentSizeChanged
            termSwapCurrencyView.didChangeContent = contentSizeChanged
        }
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        content.addSubview(containerStackView)
        containerStackView.snp.makeConstraints { make in
            make.leading.equalTo(content.snp.leadingMargin)
            make.trailing.equalTo(content.snp.trailingMargin)
            make.top.equalTo(content.snp.topMargin)
            make.bottom.equalTo(content.snp.bottomMargin)
        }
        
        containerStackView.addArrangedSubview(baseSwapCurrencyView)
        containerStackView.addArrangedSubview(dividerWithButtonView)
        containerStackView.addArrangedSubview(termSwapCurrencyView)
        
        dividerWithButtonView.snp.makeConstraints { make in
            make.height.equalTo(ViewSizes.medium.rawValue)
        }
        
        dividerWithButtonView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.height.equalTo(ViewSizes.minimum.rawValue)
            make.leading.trailing.equalToSuperview()
            make.center.equalToSuperview()
        }
        
        dividerWithButtonView.addSubview(swapButton)
        swapButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        getAmounts()
    }
    
    private func getAmounts() {
        baseSwapCurrencyView.didChangeFiatAmount = { [weak self] amount in
            self?.didChangeFromFiatAmount?(amount)
        }
        
        baseSwapCurrencyView.didChangeCryptoAmount = { [weak self] amount in
            self?.didChangeFromCryptoAmount?(amount)
        }
        
        termSwapCurrencyView.didChangeFiatAmount = { [weak self] amount in
            self?.didChangeToFiatAmount?(amount)
        }
        
        termSwapCurrencyView.didChangeCryptoAmount = { [weak self] amount in
            self?.didChangeToCryptoAmount?(amount)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configure(background: config?.background)
        configure(shadow: config?.shadow)
    }
    
    override func configure(with config: MainSwapConfiguration?) {
        super.configure(with: config)
        
        baseSwapCurrencyView.configure(with: .init())
        termSwapCurrencyView.configure(with: .init())
        
        configure(background: config?.background)
        configure(shadow: config?.shadow)
    }
    
    override func setup(with viewModel: MainSwapViewModel?) {
        guard let viewModel = viewModel else { return }
        super.setup(with: viewModel)
        
        // There could be a better way
        if baseSwapCurrencyView.selectorStackView.transform != .identity {
            baseSwapCurrencyView.selectorStackView.transform = .identity
            termSwapCurrencyView.selectorStackView.transform = .identity
        }
        
        baseSwapCurrencyView.setup(with: viewModel.from)
        termSwapCurrencyView.setup(with: viewModel.to)
        
        baseSwapCurrencyView.didChangeContent = contentSizeChanged
        baseSwapCurrencyView.didFinish = didFinish
        termSwapCurrencyView.didChangeContent = contentSizeChanged
        termSwapCurrencyView.didFinish = didFinish
        
        contentSizeChanged?()
    }
    
    // MARK: - User interaction
    
    @objc private func topCurrencyTapped(_ sender: Any?) {
        endEditing(true)
        
        didTapFromAssetsSelection?()
    }
    
    @objc private func bottomCurrencyTapped(_ sender: Any?) {
        endEditing(true)
        
        didTapToAssetsSelection?()
    }
    
    @objc private func switchPlacesButtonTapped(_ sender: UIButton?) {
        didFinish?(true)
        contentSizeChanged?()
        
        animateSwitchPlaces()
    }

    func animateSwitchPlaces() {
        let isNormal = swapButton.transform == .identity
        
        let base = baseSwapCurrencyView.selectorStackView
        let term = termSwapCurrencyView.selectorStackView
        let baseTop = base.convert(base.bounds, to: self).minY
        let termTop = term.convert(term.bounds, to: self).minY
        let verticalDistance = isNormal ? baseTop - termTop : termTop - baseTop
        
        swapButton.isEnabled = false
        
        UIView.animate(withDuration: Presets.Animation.duration * 2,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 3.0,
                       options: .curveEaseIn) { [weak self] in
            self?.baseSwapCurrencyView.selectorStackView.transform = isNormal ? .init(translationX: 0, y: -verticalDistance) : .identity
            self?.termSwapCurrencyView.selectorStackView.transform = isNormal ? .init(translationX: 0, y: verticalDistance) : .identity
            self?.swapButton.transform = isNormal ? CGAffineTransform(rotationAngle: .pi) : .identity
        }
        
        UIView.animate(withDuration: Presets.Animation.duration) { [weak self] in
            self?.baseSwapCurrencyView.setAlphaToLabels(alpha: 0.2)
            self?.termSwapCurrencyView.setAlphaToLabels(alpha: 0.2)
            self?.baseSwapCurrencyView.resetTextFieldValues()
            self?.termSwapCurrencyView.resetTextFieldValues()
        } completion: { _ in
            UIView.animate(withDuration: Presets.Animation.duration) { [weak self] in
                self?.baseSwapCurrencyView.setAlphaToLabels(alpha: 1)
                self?.termSwapCurrencyView.setAlphaToLabels(alpha: 1)
            } completion: { [weak self] _ in
                self?.swapButton.isEnabled = true
            }
        }
    }
}
