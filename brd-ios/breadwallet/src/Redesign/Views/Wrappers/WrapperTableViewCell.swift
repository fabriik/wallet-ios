// 
//  WrapperTableViewCell.swift
//  breadwallet
//
//  Created by Rok on 10/05/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

protocol Wrappable: UIView {
    associatedtype WrappedView: UIView
    
    var wrappedView: WrappedView { get set }
}

class WrapperTableViewCell<T: UIView>: UITableViewCell, Wrappable, Marginable, Reusable, Identifiable {
    
    // MARK: Variables
    var wrappedView = T()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupViews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // TODO: fix this logic to work with selectionStyle
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        (wrappedView as? Reusable)?.prepareForReuse()
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        // TODO: fix this logic to work with selectionStyle
    }
    
    var shouldHighlight: Bool = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        wrappedView.layoutSubviews()
    }
    
    private func setupViews() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(wrappedView)
        wrappedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setup(_ closure: (T) -> Void) {
        closure(wrappedView)
    }
}
