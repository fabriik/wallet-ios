package com.fabriik.kyc.ui.features.accountverification

import android.app.Application
import com.fabriik.common.ui.base.FabriikViewModel

class AccountVerificationViewModel(
    application: Application
) : FabriikViewModel<AccountVerificationContract.State, AccountVerificationContract.Event, AccountVerificationContract.Effect>(application) {

    override fun createInitialState() = AccountVerificationContract.State()

    override fun handleEvent(event: AccountVerificationContract.Event) {
        when (event) {

        }
    }
}