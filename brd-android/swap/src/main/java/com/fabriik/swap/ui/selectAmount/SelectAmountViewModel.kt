package com.fabriik.swap.ui.selectAmount

import android.app.Application
import androidx.lifecycle.*
import com.fabriik.swap.R
import com.fabriik.swap.data.SwapApi
import com.fabriik.swap.ui.base.SwapViewModel
import com.fabriik.swap.utils.SingleLiveEvent
import com.fabriik.swap.utils.toBundle
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.flow.consumeAsFlow
import kotlinx.coroutines.launch
import java.math.BigDecimal

class SelectAmountViewModel(
    application: Application,
    savedStateHandle: SavedStateHandle
) : AndroidViewModel(application),
    SwapViewModel<SelectAmountState, SelectAmountAction, SelectAmountEffect?>,
    LifecycleObserver {

    override val actions: Channel<SelectAmountAction> = Channel(Channel.UNLIMITED)

    override val state: LiveData<SelectAmountState>
        get() = _state

    override val effect: LiveData<SelectAmountEffect?>
        get() = _effect

    private val arguments = SelectAmountFragmentArgs.fromBundle(
        savedStateHandle.toBundle()
    )

    private val api: SwapApi = SwapApi.create()
    private val _state = MutableLiveData<SelectAmountState>().apply {
        value = SelectAmountState(
            title = application.applicationContext.getString(
                R.string.Swap_swapFor2,
                arguments.sellingCurrency.formatCode(),
                arguments.buyingCurrency.formatCode()
            ),
            buyingCurrency = arguments.buyingCurrency,
            sellingCurrency = arguments.sellingCurrency
        )
    }
    private val _effect = SingleLiveEvent<SelectAmountEffect?>()

    init {
        handleAction()
    }

    private fun handleAction() {
        viewModelScope.launch {
            actions.consumeAsFlow().collect {
                when (it) {
                    is SelectAmountAction.Back -> {
                        _effect.postValue(
                            SelectAmountEffect.GoBack
                        )
                    }
                    is SelectAmountAction.Close -> {
                        _effect.postValue(
                            SelectAmountEffect.GoToHome
                        )
                    }
                    is SelectAmountAction.ConfirmClicked -> {
                        _effect.postValue(
                            SelectAmountEffect.GoToPreview(
                                amount = BigDecimal.TEN, // todo: read from view
                                buyingCurrency = arguments.buyingCurrency,
                                sellingCurrency = arguments.sellingCurrency,
                            )
                        )
                    }
                    is SelectAmountAction.AmountChanged -> onInputChanged(it)
                }
            }
        }
    }

    private fun onInputChanged(action: SelectAmountAction.AmountChanged) {
        // todo: calculate new value
    }
}