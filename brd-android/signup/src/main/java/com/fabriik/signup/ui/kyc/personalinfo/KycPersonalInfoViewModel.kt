package com.fabriik.signup.ui.kyc.personalinfo

import android.app.Application
import androidx.lifecycle.SavedStateHandle
import com.fabriik.signup.R
import com.fabriik.signup.ui.base.FabriikViewModel
import com.fabriik.signup.utils.getString
import com.fabriik.signup.utils.toBundle
import java.util.*

class KycPersonalInfoViewModel(
    application: Application,
    savedStateHandle: SavedStateHandle
) : FabriikViewModel<KycPersonalInfoContract.State, KycPersonalInfoContract.Event, KycPersonalInfoContract.Effect>(
    application
) {

    private val arguments = KycPersonalInfoFragmentArgs.fromBundle(
        savedStateHandle.toBundle()
    )

    override fun createInitialState() = KycPersonalInfoContract.State()

    override fun handleEvent(event: KycPersonalInfoContract.Event) {
        when (event) {
            is KycPersonalInfoContract.Event.TaxIdChanged ->
                setState {
                    copy(
                        taxId = event.taxId,
                        taxIdValid = event.taxId.isNotBlank()
                    )
                }

            is KycPersonalInfoContract.Event.DateOfBirthChanged ->
                setState {
                    copy(
                        dateOfBirth = event.date,
                        dateOfBirthValid = event.date != null
                    )
                }

            is KycPersonalInfoContract.Event.NextClicked ->
                validatePersonalData()

            is KycPersonalInfoContract.Event.DateOfBirthClicked ->
                setEffect {
                    KycPersonalInfoContract.Effect.OpenDatePicker(
                        currentState.dateOfBirth
                    )
                }
        }
    }

    private fun validatePersonalData() {
        val validData = currentState.dateOfBirthValid && currentState.taxIdValid

        if (validData) {
            postPersonalData(
                zip = arguments.zip,
                city = arguments.city,
                state = arguments.state,
                street = arguments.street,
                country = arguments.country,
                taxId = currentState.taxId,
                dateOfBirth = currentState.dateOfBirth!!
            )
        } else {
            setEffect {
                KycPersonalInfoContract.Effect.ShowSnackBar(
                    getString(R.string.ResetPassword_EnterValidData)
                )
            }
        }
    }

    private fun postPersonalData(
        zip: String,
        city: String,
        state: String?,
        street: String,
        country: String,
        taxId: String,
        dateOfBirth: Date
    ) {
        // TODO: API call

        setEffect {
            KycPersonalInfoContract.Effect.GoToIdUpload
        }
    }
}