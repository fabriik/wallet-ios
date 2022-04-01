package com.fabriik.swap.ui.preview

import android.app.Application
import androidx.lifecycle.*
import com.fabriik.swap.R
import com.fabriik.swap.data.SwapApi
import com.fabriik.swap.data.model.BuyingCurrencyData
import com.fabriik.swap.ui.base.SwapViewModel
import com.fabriik.swap.ui.buyingCurrency.SelectBuyingCurrencyState
import com.fabriik.swap.utils.SingleLiveEvent
import com.fabriik.swap.utils.toBundle
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.flow.consumeAsFlow
import kotlinx.coroutines.launch
import java.math.BigDecimal

class SwapPreviewViewModel(
    application: Application,
    savedStateHandle: SavedStateHandle
) : AndroidViewModel(application),
    SwapViewModel<SwapPreviewState, SwapPreviewAction, SwapPreviewEffect?>,
    LifecycleObserver {

    override val actions: Channel<SwapPreviewAction> = Channel(Channel.UNLIMITED)

    override val state: LiveData<SwapPreviewState>
        get() = _state

    override val effect: LiveData<SwapPreviewEffect?>
        get() = _effect

    private val arguments = SwapPreviewFragmentArgs.fromBundle(
        savedStateHandle.toBundle()
    )

    private val api: SwapApi = SwapApi.create()
    private val _state = MutableLiveData<SwapPreviewState>().apply {
        value = SwapPreviewState(
            amount = arguments.amount,
            buyingCurrency = arguments.buyingCurrency,
            sellingCurrency = arguments.sellingCurrency
        )
    }
    private val _effect = SingleLiveEvent<SwapPreviewEffect?>()

    init {
        handleAction()
    }

    private fun handleAction() {
        viewModelScope.launch {
            actions.consumeAsFlow().collect {
                when (it) {
                    is SwapPreviewAction.Back -> {
                        _effect.postValue(
                            SwapPreviewEffect.GoBack
                        )
                    }
                    is SwapPreviewAction.Close -> {
                        _effect.postValue(
                            SwapPreviewEffect.GoToHome
                        )
                    }
                    is SwapPreviewAction.ConfirmClicked -> createTransaction()
                    is SwapPreviewAction.LoadExchangeData -> loadExchangeData()
                }
            }
        }
    }

    private fun createTransaction() {
        // TODO: call API
    }

    private fun loadExchangeData() {
        viewModelScope.launch(Dispatchers.IO) {
            try {
                updateState {
                    it.copy(isLoading = true)
                }

                val data = api.getExchangeAmounts(
                    from = arguments.sellingCurrency,
                    to = listOf(arguments.buyingCurrency),
                    amount = arguments.amount
                ).firstOrNull()

                updateState {
                    it.copy(
                        isLoading = false,
                        exchangeData = data,
                        errorMessage = if (data == null) "Error fetching exchange data" else null
                    )
                }
            } catch (e: Exception) {
                updateState {
                    it.copy(
                        isLoading = false,
                        errorMessage = e.message
                    )
                }
            }
        }
    }

    private suspend fun updateState(handler: suspend (intent: SwapPreviewState) -> SwapPreviewState) {
        _state.postValue(handler(state.value!!))
    }
}