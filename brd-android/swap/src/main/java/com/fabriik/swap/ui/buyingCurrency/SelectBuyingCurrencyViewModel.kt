package com.fabriik.swap.ui.buyingCurrency

import android.app.Application
import androidx.lifecycle.*
import com.breadwallet.repository.RatesRepository
import com.breadwallet.tools.manager.BRSharedPrefs
import com.breadwallet.tools.util.TokenUtil
import com.fabriik.swap.R
import com.fabriik.swap.data.SwapApi
import com.fabriik.swap.data.SwapCurrenciesRepository
import com.fabriik.swap.data.model.BuyingCurrencyData
import com.fabriik.swap.ui.base.SwapViewModel
import com.fabriik.swap.utils.SingleLiveEvent
import com.fabriik.swap.utils.toBundle
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.flow.consumeAsFlow
import kotlinx.coroutines.launch
import org.kodein.di.KodeinAware
import org.kodein.di.android.closestKodein
import org.kodein.di.direct
import org.kodein.di.erased.instance
import java.math.BigDecimal

class SelectBuyingCurrencyViewModel(
    application: Application,
    savedStateHandle: SavedStateHandle
) : AndroidViewModel(application),
    SwapViewModel<SelectBuyingCurrencyState, SelectBuyingCurrencyAction, SelectBuyingCurrencyEffect?>,
    LifecycleObserver, KodeinAware {

    override val kodein by closestKodein { application.applicationContext }
    override val actions: Channel<SelectBuyingCurrencyAction> = Channel(Channel.UNLIMITED)

    override val state: LiveData<SelectBuyingCurrencyState>
        get() = _state

    override val effect: LiveData<SelectBuyingCurrencyEffect?>
        get() = _effect

    private val arguments = SelectBuyingCurrencyFragmentArgs.fromBundle(
        savedStateHandle.toBundle()
    )

    private val currenciesRepository = SwapCurrenciesRepository(
        swapApi = SwapApi.create(),
        breadBox = direct.instance(),
        ratesRepository = direct.instance()
    )

    private val _state = MutableLiveData<SelectBuyingCurrencyState>().apply {
        value = SelectBuyingCurrencyState(
            title = application.applicationContext.getString(
                R.string.Swap_swapFor, arguments.sellingCurrency.formatCode()
            )
        )
    }

    private val _effect = SingleLiveEvent<SelectBuyingCurrencyEffect?>()

    private var searchQuery: String = ""
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

                currencies = currenciesRepository.getBuyingCurrenciesData(
                    arguments.sellingCurrency
                )

                updateState {
                    it.copy(
                        isLoading = false,
                        currencies = currencies
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