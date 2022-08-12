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
    var info: IconDescriptionConfiguration = .init()
}

struct BuyOrderViewModel: ViewModel {
    var price: TitleValueViewModel
    var amount: TitleValueViewModel
    var cardFee: TitleValueViewModel
    var networkFee: TitleValueViewModel
    var totalCost: TitleValueViewModel
}

class BuyOrderView: FEView<BuyOrderConfiguration, BuyOrderViewModel> {
    
    private lazy var mainStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = Margins.large.rawValue
        return view
    }()
    
    private lazy var priceView: TitleValueView = {
        let view = TitleValueView()
        view.axis = .vertical
        return view
    }()
    
    private lazy var amountView: TitleValueView = {
        let view = TitleValueView()
        view.axis = .vertical
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
    
    private lazy var totalCostView: TitleValueView = {
        let view = TitleValueView()
        return view
    }()
    
    override func setupSubviews() {
        super.setupSubviews()
        
        content.addSubview(mainStack)
        mainStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
        
        mainStack.addArrangedSubview(totalCostView)
        totalCostView.snp.makeConstraints { make in
            make.height.equalTo(FieldHeights.small.rawValue)
        }
    }
    
    override func configure(with config: BuyOrderConfiguration?) {
        super.configure(with: config)
        
        priceView.configure(with: config?.price)
        amountView.configure(with: config?.amount)
        cardFeeView.configure(with: config?.cardFee)
        networkFeeView.configure(with: config?.networkFee)
        totalCostView.configure(with: config?.totalCost)
    }
    
    override func setup(with viewModel: BuyOrderViewModel?) {
        super.setup(with: viewModel)
        
        priceView.setup(with: viewModel?.price)
        amountView.setup(with: viewModel?.amount)
        cardFeeView.setup(with: viewModel?.cardFee)
        networkFeeView.setup(with: viewModel?.networkFee)
        totalCostView.setup(with: viewModel?.totalCost)
    }
}

