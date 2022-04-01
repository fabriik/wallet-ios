package com.fabriik.swap.ui.buyingCurrency

import android.app.Application
import androidx.lifecycle.*
import com.breadwallet.repository.RatesRepository
import com.fabriik.swap.R
import com.fabriik.swap.data.SwapApi
import com.fabriik.swap.data.model.BuyingCurrencyData
import com.fabriik.swap.ui.base.SwapViewModel
import com.fabriik.swap.utils.SingleLiveEvent
import com.fabriik.swap.utils.toBundle
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.flow.consumeAsFlow
import kotlinx.coroutines.launch
import java.math.BigDecimal

class SelectBuyingCurrencyViewModel(
    application: Application,
    savedStateHandle: SavedStateHandle
) : AndroidViewModel(application),
    SwapViewModel<SelectBuyingCurrencyState, SelectBuyingCurrencyAction, SelectBuyingCurrencyEffect?>,
    LifecycleObserver {

    override val actions: Channel<SelectBuyingCurrencyAction> = Channel(Channel.UNLIMITED)

    override val state: LiveData<SelectBuyingCurrencyState>
        get() = _state

    override val effect: LiveData<SelectBuyingCurrencyEffect?>
        get() = _effect

    private val arguments = SelectBuyingCurrencyFragmentArgs.fromBundle(
        savedStateHandle.toBundle()
    )

    private var searchQuery: String = ""
    private val api: SwapApi = SwapApi.create()
    private val _state = MutableLiveData<SelectBuyingCurrencyState>().apply {
        value = SelectBuyingCurrencyState(
            title = application.applicationContext.getString(
                R.string.Swap_swapFor, arguments.sellingCurrency.formatCode()
            )
        )
    }
    private val _effect = SingleLiveEvent<SelectBuyingCurrencyEffect?>()
    private var currencies: List<BuyingCurrencyData> = mutableListOf()

    init {
        handleAction()
    }

    private fun handleAction() {
        viewModelScope.launch {
            actions.consumeAsFlow().collect {
                when (it) {
                    is SelectBuyingCurrencyAction.Back -> {
                        _effect.postValue(
                            SelectBuyingCurrencyEffect.GoBack
                        )
                    }
                    is SelectBuyingCurrencyAction.Close -> {
                        _effect.postValue(
                            SelectBuyingCurrencyEffect.GoToHome
                        )
                    }
                    is SelectBuyingCurrencyAction.LoadCurrencies -> loadCurrencies()
                    is SelectBuyingCurrencyAction.SearchChanged -> onSearchChanged(it)
                    is SelectBuyingCurrencyAction.CurrencySelected -> onCurrencySelected(it)
                }
            }
        }
    }

    private fun loadCurrencies() {
        if (currencies.isNotEmpty()) {
            return
        }

        viewModelScope.launch(Dispatchers.IO) {
            try {
                updateState {
                    it.copy(isLoading = true)
                }

                val currencies = api.getCurrencies()
                    .filter { it.name != arguments.sellingCurrency.name }

                val buyingCurrencies = api.getExchangeAmounts(
                    from = arguments.sellingCurrency,
                    to = currencies,
                    amount = BigDecimal.ONE
                ).mapNotNull { exchangeData ->
                    val currency = currencies.firstOrNull {
                        it.name == exchangeData.to
                    } ?: return@mapNotNull null

                    BuyingCurrencyData(
                        sellingCurrency = arguments.sellingCurrency,
                        currency = currency,
                        rate = exchangeData.result
                    )
                }

                updateState {
                    it.copy(
                        isLoading = false,
                        currencies = buyingCurrencies
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

    private fun onCurrencySelected(action: SelectBuyingCurrencyAction.CurrencySelected) {
        _effect.postValue(
            SelectBuyingCurrencyEffect.GoToAmountSelection(
                exchangeRate = action.currency.rate,
                buyingCurrency = action.currency.currency,
                sellingCurrency = arguments.sellingCurrency
            )
        )
    }

    private fun onSearchChanged(action: SelectBuyingCurrencyAction.SearchChanged) {
        searchQuery = action.query

        viewModelScope.launch(Dispatchers.IO) {
            updateState {
                it.copy(
                    currencies = currencies.filter { data ->
                        data.currency.name.contains(searchQuery, true) ||
                                data.currency.fullName.contains(searchQuery, true)
                    }
                )
            }
        }
    }

    private suspend fun updateState(handler: suspend (intent: SelectBuyingCurrencyState) -> SelectBuyingCurrencyState) {
        _state.postValue(handler(state.value!!))
    }
}