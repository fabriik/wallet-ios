// 
//  FailureViewController.swift
//  breadwallet
//
//  Created by Rok on 12/08/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

extension Scenes {
    static let Failure = FailureViewController.self
}

class FailureViewController: BaseInfoViewController {
    override var imageName: String? { return "errorIcon" }
    override var titleText: String? { return "There was an error while processing your payment" }
    override var descriptionText: String? { return "Please contact your card issuer/bank or try again with a different payment method." }
    override var buttonViewModels: [ButtonViewModel] {
        return [
            .init(title: "Try a different payment method"),
            .init(title: "Contact support")
        ]
    }

    override var buttonCallbacks: [(() -> Void)] {
        return [
            goHome,
            showDetails
        ]
    }
    
    override func tableView(_ tableView: UITableView, coverCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, coverCellForRowAt: indexPath)
        
        guard let cell = cell as? WrapperTableViewCell<FEImageView> else {
            return cell
        }
        cell.wrappedView.snp.makeConstraints { make in
            make.edges.equalTo(cell.contentView.snp.margins)
            make.height.equalTo(ViewSizes.large.rawValue)
        }
        
        return cell
    }

    func goHome() {
        print("first!")
    }

    func showDetails() {
        print("second!")
    }
}
