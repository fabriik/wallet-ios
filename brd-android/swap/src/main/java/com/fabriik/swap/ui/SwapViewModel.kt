package com.fabriik.swap.ui

import androidx.lifecycle.LifecycleObserver
import androidx.lifecycle.ViewModel
import androidx.lifecycle.liveData
import com.fabriik.swap.data.Resource
import com.fabriik.swap.data.SwapApi
import com.fabriik.swap.data.responses.SwapCurrency
import kotlinx.coroutines.Dispatchers
import java.math.BigDecimal

class SwapViewModel(
    private val api: SwapApi = SwapApi.create()
) : ViewModel(), LifecycleObserver {

    private val currencies = mutableListOf<SwapCurrency>()

    var selectedAmount: BigDecimal? = null
        private set

    var selectedBuyingCurrency: SwapCurrency? = null
        private set

    var selectedSellingCurrency: SwapCurrency? = null
        private set

    fun getCurrencies() = liveData(Dispatchers.IO) {
        // download data if list is empty
        if (currencies.isEmpty()) {

            // show loading indicator
            emit(Resource.loading())

            try {
                val currencies = api.getCurrencies()
                if (currencies.isNotEmpty()) {
                    this@SwapViewModel.currencies.addAll(
                        currencies
                    )
                } else {
                    emit(
                        Resource.error(
                            data = null,
                            message = "Error Occurred!"
                        )
                    )
                    return@liveData
                }
            } catch (exception: Exception) {
                emit(
                    Resource.error(
                        data = null,
                        message = exception.message ?: "Error Occurred!"
                    )
                )
                return@liveData
            }
        }

        emit(
            Resource.success(
                data = ArrayList(currencies)
            )
        )
    }

    fun getBuyingCurrencies() = liveData(Dispatchers.IO) {
        emit(
            currencies.filter {
                it.name != selectedSellingCurrency?.name
            }
        )
    }

    fun onBuyingCurrencySelected(currency: SwapCurrency) {
        selectedBuyingCurrency = currency
    }

    fun onSellingCurrencySelected(currency: SwapCurrency) {
        selectedSellingCurrency = currency
    }

    fun onAmountChanged(amount: BigDecimal) {
        selectedAmount = amount
    }
}