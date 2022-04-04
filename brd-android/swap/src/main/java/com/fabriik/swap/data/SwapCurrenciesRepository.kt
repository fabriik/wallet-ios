package com.fabriik.swap.data

import com.breadwallet.breadbox.BreadBox
import com.breadwallet.breadbox.toBigDecimal
import com.breadwallet.crypto.Wallet
import com.breadwallet.repository.RatesRepository
import com.breadwallet.tools.manager.BRSharedPrefs
import com.breadwallet.tools.util.TokenUtil
import com.fabriik.swap.data.model.BuyingCurrencyData
import com.fabriik.swap.data.model.SellingCurrencyData
import com.fabriik.swap.data.responses.SwapCurrency
import kotlinx.coroutines.flow.first
import java.math.BigDecimal

internal class SwapCurrenciesRepository(
    private val swapApi: SwapApi,
    private val breadBox: BreadBox,
    private val ratesRepository: RatesRepository
) {

    private val fiatIso = BRSharedPrefs.getPreferredFiatIso()

    suspend fun getSellingCurrenciesData(): List<SellingCurrencyData> {
        val currencies = swapApi.getCurrencies()
        val wallets = breadBox.wallets().first()

        return wallets.mapNotNull { wallet ->
            val currency = currencies.firstOrNull {
                it.name == wallet.currency.code
            } ?: return@mapNotNull null

            SellingCurrencyData(
                currency = currency.copy(
                    fullName = getCurrencyFullName(currency)
                ),
                fiatBalance = getFiatForCrypto(
                    currency = currency,
                    wallet = wallet
                ),
                cryptoBalance = wallet.balance.toBigDecimal(),
                fiatPricePerUnit = ratesRepository.getFiatPerCryptoUnit(
                    cryptoCode = wallet.currency.code,
                    fiatCode = fiatIso
                )
            )
        }
    }

    suspend fun getBuyingCurrenciesData(sellingCurrency: SwapCurrency): List<BuyingCurrencyData> {
        val currencies = swapApi.getCurrencies()
            .filter { it.name != sellingCurrency.name }

        return swapApi.getExchangeAmounts(
            to = currencies,
            from = sellingCurrency,
            amount = BigDecimal.ONE
        ).mapNotNull { exchangeData ->
            val currency = currencies.firstOrNull {
                it.name == exchangeData.to
            } ?: return@mapNotNull null

            BuyingCurrencyData(
                sellingCurrency = sellingCurrency,
                currency = currency.copy(
                    fullName = TokenUtil.tokenForCode(currency.name)?.name ?: currency.fullName
                ),
                rate = exchangeData.result,
                fiatPricePerUnit = ratesRepository.getFiatPerCryptoUnit(
                    cryptoCode = currency.name,
                    fiatCode = fiatIso
                )
            )
        }
    }

    private fun getFiatForCrypto(currency: SwapCurrency, wallet: Wallet) =
        ratesRepository.getFiatForCrypto(
            cryptoAmount = wallet.balance.toBigDecimal(),
            cryptoCode = currency.name,
            fiatCode = fiatIso
        ) ?: BigDecimal.ZERO

    private fun getCurrencyFullName(currency: SwapCurrency) =
        TokenUtil.tokenForCode(currency.name)?.name ?: currency.fullName
}