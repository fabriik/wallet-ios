// 
//  DeleteProfileInfoCoordinator.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 19/07/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

class DeleteProfileInfoCoordinator: BaseCoordinator, DeleteProfileInfoRoutes {
    // MARK: - ProfileRoutes
    
    override func start() {
        open(scene: Scenes.DeleteProfileInfo)
    }
    
    // MARK: - Aditional helpers
    
}
