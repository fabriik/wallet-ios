// 
//  BuyOrderView.swift
//  breadwallet
//
//  Created by Dijana Angelovska on 12.8.22.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

struct BuyOrderConfiguration: Configurable {
    var price: TitleValueConfiguration = Presets.TitleValue.vertical
    var amount: TitleValueConfiguration = Presets.TitleValue.vertical
    var cardFee: TitleValueConfiguration = Presets.TitleValue.vertical
    var networkFee: TitleValueConfiguration = Presets.TitleValue.vertical
    var totalCost: TitleValueConfiguration = Presets.TitleValue.subtitle
    var shadow: ShadowConfiguration? = Presets.Shadow.light
    var background: BackgroundConfiguration? = .init(backgroundColor: LightColors.Background.one,
                                                     tintColor: LightColors.Text.one,
                                                     border: Presets.Border.zero)
}

struct BuyOrderViewModel: ViewModel {
    var rate: ExchangeRateViewModel
    var price: TitleValueViewModel
    var amount: TitleValueViewModel
    var cardFee: TitleValueViewModel
    var networkFee: TitleValueViewModel
    var totalCost: TitleValueViewModel
}

class BuyOrderView: FEView<BuyOrderConfiguration, BuyOrderViewModel> {
    
    var cardFeeInfoTapped: (() -> Void)?
    var networkFeeInfoTapped: (() -> Void)?
    
    private lazy var mainStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = Margins.medium.rawValue
        return view
    }()
    
    private lazy var rateView: ExchangeRateView = {
        let view = ExchangeRateView()
        return view
    }()
    
    private lazy var lineView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var priceView: TitleValueView = {
        let view = TitleValueView()
        return view
    }()
    
    private lazy var amountView: TitleValueView = {
        let view = TitleValueView()
        return view
    }()
    
    private lazy var cardFeeView: TitleValueView = {
        let view = TitleValueView()
        return view
    }()
    
    private lazy var networkFeeView: TitleValueView = {
        let view = TitleValueView()
        return view
    }()
    
    private lazy var secondLineView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var totalCostView: TitleValueView = {
        let view = TitleValueView()
        return view
    }()
    
    override func setupSubviews() {
        super.setupSubviews()
        
        content.addSubview(mainStack)
        content.setupCustomMargins(all: .large)
        mainStack.snp.makeConstraints { make in
            make.edges.equalTo(content.snp.margins)
        }
        
        mainStack.addArrangedSubview(rateView)
        rateView.snp.makeConstraints { make in
            make.height.equalTo(FieldHeights.small.rawValue)
        }
        
        mainStack.addArrangedSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.height.equalTo(ViewSizes.minimum.rawValue)
        }
        
        mainStack.addArrangedSubview(priceView)
        priceView.snp.makeConstraints { make in
            make.height.equalTo(FieldHeights.common.rawValue)
        }
        
        mainStack.addArrangedSubview(amountView)
        amountView.snp.makeConstraints { make in
            make.height.equalTo(FieldHeights.common.rawValue)
        }
        
        mainStack.addArrangedSubview(cardFeeView)
        cardFeeView.snp.makeConstraints { make in
            make.height.equalTo(FieldHeights.small.rawValue)
        }
        
        mainStack.addArrangedSubview(networkFeeView)
        networkFeeView.snp.makeConstraints { make in
            make.height.equalTo(FieldHeights.common.rawValue)
        }
        
        mainStack.addArrangedSubview(secondLineView)
        secondLineView.snp.makeConstraints { make in
            make.height.equalTo(ViewSizes.minimum.rawValue)
        }
        
        mainStack.addArrangedSubview(totalCostView)
        totalCostView.snp.makeConstraints { make in
            make.height.equalTo(FieldHeights.small.rawValue)
        }
        
        lineView.layer.borderWidth = 1.0
        lineView.layer.borderColor = LightColors.Outline.three.cgColor
        secondLineView.layer.borderWidth = 1.0
        secondLineView.layer.borderColor = LightColors.Outline.three.cgColor
        
        cardFeeView.didTapInfoButton = { [weak self] in
            self?.cardFeeInfoButtonTapped()
        }
        
        networkFeeView.didTapInfoButton = { [weak self] in
            self?.networkFeeViewInfoButtonTapped()
        }
    }
    
    override func configure(with config: BuyOrderConfiguration?) {
        super.configure(with: config)
        
        priceView.configure(with: config?.price)
        amountView.configure(with: config?.amount)
        cardFeeView.configure(with: config?.cardFee)
        networkFeeView.configure(with: config?.networkFee)
        totalCostView.configure(with: config?.totalCost)
        
        configure(background: config?.background)
        configure(shadow: config?.shadow)
    }
    
    override func setup(with viewModel: BuyOrderViewModel?) {
        super.setup(with: viewModel)
        
        rateView.setup(with: viewModel?.rate)
        priceView.setup(with: viewModel?.price)
        amountView.setup(with: viewModel?.amount)
        cardFeeView.setup(with: viewModel?.cardFee)
        networkFeeView.setup(with: viewModel?.networkFee)
        totalCostView.setup(with: viewModel?.totalCost)
        
        needsUpdateConstraints()
    }
    
    private func cardFeeInfoButtonTapped() {
        cardFeeInfoTapped?()
    }
    
    private func networkFeeViewInfoButtonTapped() {
        networkFeeInfoTapped?()
    }
}
