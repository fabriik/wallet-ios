package com.fabriik.swap.ui

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.LifecycleObserver
import androidx.lifecycle.liveData
import com.breadwallet.breadbox.BreadBox
import com.breadwallet.breadbox.toBigDecimal
import com.breadwallet.ext.throttleLatest
import com.breadwallet.repository.RatesRepository
import com.breadwallet.tools.manager.BRSharedPrefs
import com.fabriik.swap.data.Resource
import com.fabriik.swap.data.SwapApi
import com.fabriik.swap.data.responses.SwapCurrency
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.mapLatest
import java.math.BigDecimal
import org.kodein.di.KodeinAware
import org.kodein.di.android.closestKodein
import org.kodein.di.erased.instance

class SwapViewModel(
    application: Application
) : AndroidViewModel(application), LifecycleObserver, KodeinAware {

    override val kodein by closestKodein { application.applicationContext }

    private val breadBox by instance<BreadBox>()
    private val api: SwapApi = SwapApi.create()
    private val currencies = mutableListOf<SwapCurrency>()
    private val fiatIso = BRSharedPrefs.getPreferredFiatIso()
    private val ratesRepo = RatesRepository.getInstance(
        application.applicationContext
    )

    var selectedAmount: BigDecimal? = null
        private set

    var selectedBuyingCurrency: SwapCurrency? = null
        private set

    var selectedSellingCurrency: SwapCurrency? = null
        private set

    fun getSellingCurrencies(query: String) = liveData(Dispatchers.IO) {
        if (currencies.isEmpty()) {
            getCurrencies()
        }

        val result = currencies.filter {
            it.name.contains(query, ignoreCase = true) ||
            it.fullName.contains(query, ignoreCase = true)
        }

        emit(
            result
        )
    }

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

        val currencyCodes = currencies.map { it.name }

        val currenciesWithRates = breadBox.wallets()
            .throttleLatest(WALLET_UPDATE_THROTTLE)
            .mapLatest { wallets ->
                val fiatIso = BRSharedPrefs.getPreferredFiatIso()
                wallets.filter { currencyCodes.contains(it.currency.code) }
                    .map {
                        SellingCurrencyData(
                            currency = currencies.find { currency -> currency.name == it.currency.code }!!,
                            fiatBalance = ratesRepo.getFiatForCrypto(
                                it.balance.toBigDecimal(),
                                it.currency.code,
                                fiatIso
                            )
                                ?: BigDecimal.ZERO,
                            cryptoBalance = it.balance.toBigDecimal(),
                        )
                    }
            }.first()

        emit(
            Resource.success(
                data = ArrayList(currenciesWithRates)
            )
        )
    }

    fun getBuyingCurrencies() = liveData(Dispatchers.IO) {
        checkNotNull(selectedSellingCurrency)

        emit(
            currencies.filter {
                it.name != selectedSellingCurrency!!.name
            }.map {
                BuyingCurrencyData(
                    currency = it,
                    rate = BigDecimal.TEN/*ratesRepo.getAllRatesForCurrency(
                        cryptoCode = it.name,
                        fiatCode = fiatIso
                    )*/
                )
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

    data class SellingCurrencyData(
        val currency: SwapCurrency,
        val fiatBalance: BigDecimal,
        val cryptoBalance: BigDecimal
    )

    data class BuyingCurrencyData(
        val currency: SwapCurrency,
        val rate: BigDecimal
    )

    companion object {
        private const val WALLET_UPDATE_THROTTLE = 2_000L
    }
}