// 
//  FETimerView.swift
//  breadwallet
//
//  Created by Rok on 05/07/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

extension Presets {
    struct Timer {
        static var one = TimerConfiguration(background: .init(tintColor: LightColors.primary), font: Fonts.Body.two)
    }
}

struct TimerConfiguration: Configurable {
    var background: BackgroundConfiguration = .init(backgroundColor: .clear, tintColor: LightColors.primary)
    var font = Fonts.Body.two
}

struct TimerViewModel: ViewModel {
    var till: Double = 0
    var repeats = false
    var finished: (() -> Void)?
}

class FETimerView: FEView<TimerConfiguration, TimerViewModel> {
    
    private lazy var stack: UIStackView = {
        let view = UIStackView()
        view.spacing = Margins.extraSmall.rawValue
        view.alignment = .center
        return view
    }()
    
    private lazy var titleLabel: FELabel = {
        let view = FELabel()
        view.setup(with: .text("00:15s"))
        view.textAlignment = .right
        return view
    }()
    
    private lazy var iconView: CircleTimerView = {
        let view = CircleTimerView()
        return view
    }()
    
    private var timer: Timer?
    private var triggerDate: Date?
    
    override func setupSubviews() {
        super.setupSubviews()
        
        content.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.height.equalTo(ViewSizes.extraSmall.rawValue)
            make.width.lessThanOrEqualTo(content.snp.width)
        }
        
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(iconView)
        
        iconView.snp.makeConstraints { make in
            make.height.width.equalTo(stack.snp.height).multipliedBy(0.7)
        }
    }
    
    override func configure(with config: TimerConfiguration?) {
        guard let config = config else { return }
        super.configure(with: config)
        
        configure(background: config.background)
        titleLabel.configure(with: .init(font: config.font, textColor: config.background.tintColor))
    }
    
    override func setup(with viewModel: TimerViewModel?) {
        guard let viewModel = viewModel else { return }
        super.setup(with: viewModel)
        
        let dateValue = TimeInterval(viewModel.till) / 1000.0
        triggerDate = Date(timeIntervalSince1970: dateValue)
        
        iconView.startTimer(duration: CFTimeInterval(15))
        
        timer?.invalidate()
        timer = nil
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    @objc private func updateTime() {
        guard let triggerDate = triggerDate else { return }
        
        // Remove the 1 second delay
        let components = Calendar.current.dateComponents([.minute, .second], from: Date() - 1, to: triggerDate)

        guard let minutes = components.minute,
              let seconds = components.second else {
            return
        }
        
        titleLabel.text = String(format: "%02d:%02ds", minutes, seconds)
        
        guard seconds == 0, minutes == 0 else {
            content.layoutIfNeeded()
            return
        }
        
        timer?.invalidate()
        timer = nil
        
        viewModel?.finished?()
        
        guard viewModel?.repeats == true else {
            content.layoutIfNeeded()
            return
        }
        
        setup(with: viewModel)
        
        content.layoutIfNeeded()
    }
}
