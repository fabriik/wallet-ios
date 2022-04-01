package com.fabriik.swap.ui.buyingCurrency

import android.graphics.Color
import android.graphics.drawable.GradientDrawable
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.content.ContextCompat
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.ListAdapter
import androidx.recyclerview.widget.RecyclerView
import com.breadwallet.tools.manager.BRSharedPrefs
import com.breadwallet.tools.util.TokenUtil
import com.breadwallet.util.formatCryptoForUi
import com.breadwallet.util.formatFiatForUi
import com.fabriik.swap.R
import com.fabriik.swap.data.model.BuyingCurrencyData
import com.fabriik.swap.databinding.ListItemBuyingCurrencyBinding
import com.fabriik.swap.ui.sellingcurrency.SelectSellingCurrencyAdapter
import com.fabriik.swap.utils.loadFromUrl
import com.squareup.picasso.Picasso
import kotlinx.coroutines.*
import java.io.File
import java.util.*

class SelectBuyingCurrencyAdapter(private val callback: (BuyingCurrencyData) -> Unit) :
    ListAdapter<BuyingCurrencyData, SelectBuyingCurrencyAdapter.CurrencyViewHolder>(
        CallbackDiff
    ) {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int) = CurrencyViewHolder(
        LayoutInflater.from(parent.context).inflate(
            R.layout.list_item_buying_currency, parent, false
        )
    )

    override fun onBindViewHolder(holder: CurrencyViewHolder, position: Int) {
        holder.bind(
            item = getItem(position),
            callback = callback
        )
    }

    override fun onViewRecycled(holder: SelectBuyingCurrencyAdapter.CurrencyViewHolder) {
        super.onViewRecycled(holder)
        holder.unBindViewHolder()
    }

    inner class CurrencyViewHolder(view: View) : RecyclerView.ViewHolder(view) {

        private val defaultTokenColor = R.color.light_gray
        private val binding = ListItemBuyingCurrencyBinding.bind(view)
        private val boundScope = CoroutineScope(Dispatchers.Main + SupervisorJob())

        fun bind(item: BuyingCurrencyData, callback: (BuyingCurrencyData) -> Unit) {
            binding.apply {
                root.setOnClickListener { callback(item) }

                val currencyCode = item.currency.formatCode()
                val formattedAmount = item.rate.formatCryptoForUi(
                    currencyCode = item.sellingCurrency.name
                )

                tvCurrency.text = item.currency.fullName
                tvExchangeRate.text = "1 $currencyCode = $formattedAmount"
                tvTradePrice.text = item.fiatPricePerUnit.formatFiatForUi(
                    currencyCode = BRSharedPrefs.getPreferredFiatIso()
                )
                loadTokenIcon(
                    item.currency.name
                )
            }
        }

        private fun loadTokenIcon(currencyCode: String) {
            boundScope.launch {
                // Get icon for currency
                val tokenIconPath = Dispatchers.Default {
                    TokenUtil.getTokenIconPath(currencyCode, false)
                }

                // Get icon color
                val tokenColor = Dispatchers.Default {
                    TokenUtil.getTokenStartColor(currencyCode)
                }

                ensureActive()

                with(binding) {
                    val iconDrawable = iconContainer.background as GradientDrawable

                    if (tokenIconPath.isNullOrBlank()) {
                        iconLetter.visibility = View.VISIBLE
                        currencyIconWhite.visibility = View.GONE
                        iconLetter.text = currencyCode.take(1).toUpperCase(Locale.ROOT)
                    } else {
                        val iconFile = File(tokenIconPath)
                        Picasso.get().load(iconFile).into(currencyIconWhite)
                        iconLetter.visibility = View.GONE
                        currencyIconWhite.visibility = View.VISIBLE
                    }

                    // set icon color
                    iconDrawable.setColor(
                        if (tokenColor.isNullOrBlank()) {
                            ContextCompat.getColor(root.context, defaultTokenColor)
                        } else {
                            Color.parseColor(tokenColor)
                        }
                    )
                }
            }
        }

        fun unBindViewHolder() {
            boundScope.coroutineContext.cancelChildren()
        }
    }

    private object CallbackDiff : DiffUtil.ItemCallback<BuyingCurrencyData>() {

        override fun areItemsTheSame(oldItem: BuyingCurrencyData, newItem: BuyingCurrencyData) =
            newItem.currency.name == oldItem.currency.name

        override fun areContentsTheSame(oldItem: BuyingCurrencyData, newItem: BuyingCurrencyData) =
            newItem == oldItem
    }
}
