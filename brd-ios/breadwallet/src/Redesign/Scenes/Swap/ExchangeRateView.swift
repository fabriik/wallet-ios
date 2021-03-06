// 
//  ExchangeRateView.swift
//  breadwallet
//
//  Created by Rok on 05/07/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

struct ExchangeRateConfiguration: Configurable {
    var title = LabelConfiguration(font: Fonts.Subtitle.two, textColor: LightColors.Text.one)
    var value = LabelConfiguration(font: Fonts.Body.two, textColor: LightColors.Text.one)
    var background = BackgroundConfiguration()
    var timer = Presets.Timer.one
}

struct ExchangeRateViewModel: ViewModel {
    var exchangeRate: String?
    var timer = TimerViewModel(till: 0, image: .imageName("timelapse"), repeats: true)
}

class ExchangeRateView: FEView<ExchangeRateConfiguration, ExchangeRateViewModel> {
    
    var completion: (() -> Void)? {
        set {
            timerView.completion = newValue
        }
        get {
            return timerView.completion
        }
    }
    
    private lazy var titleLabel: FELabel = {
        let view = FELabel()
        // TODO: localize
        view.setup(with: .text("Rate:"))
        return view
    }()
    
    private lazy var valueLabel: FELabel = {
        let view = FELabel()
        return view
    }()
    
    private lazy var timerView: FETimerView = {
        let view = FETimerView()
        return view
    }()
    
    private lazy var refreshImageView: FEImageView = {
        let view = FEImageView()
        view.setup(with: .imageName("rotate_left"))
        view.alpha = 0
        return view
    }()
    
    override func setupSubviews() {
        super.setupSubviews()
        
        content.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        
        content.addSubview(valueLabel)
        valueLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(Margins.extraSmall.rawValue)
            make.top.bottom.equalToSuperview()
        }
        
        content.addSubview(refreshImageView)
        refreshImageView.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(Margins.extraSmall.rawValue)
            make.top.bottom.equalToSuperview()
        }
        
        content.addSubview(timerView)
        timerView.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.leading.lessThanOrEqualTo(valueLabel.snp.trailing).priority(.low)
        }
    }
    
    override func configure(with config: ExchangeRateConfiguration?) {
        guard let config = config else { return }
        super.configure(with: config)
        
        configure(background: config.background)
        titleLabel.configure(with: config.title)
        valueLabel.configure(with: config.value)
        timerView.configure(with: config.timer)
    }
    
    override func setup(with viewModel: ExchangeRateViewModel?) {
        guard let text = viewModel?.exchangeRate else {
            valueLabel.text = "No quote for pair."
            return
        }

        super.setup(with: viewModel)
        valueLabel.text = text
        timerView.setup(with: viewModel?.timer)
        rotate()
    }
    
    private func rotate() {
        hideValue(true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (1 - Presets.Animation.duration) + Presets.Animation.duration) { [weak self] in
            self?.hideValue(false)
        }
    }
    
    private func hideValue(_ isHidden: Bool) {
        UIView.animate(withDuration: Presets.Animation.duration) { [weak self] in
            self?.valueLabel.alpha = isHidden ? 0 : 1
            self?.refreshImageView.alpha = isHidden ? 1 : 0
        }
    }
}
