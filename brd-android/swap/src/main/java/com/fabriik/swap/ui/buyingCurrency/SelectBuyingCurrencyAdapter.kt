package com.fabriik.swap.ui.buyingCurrency

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.ListAdapter
import androidx.recyclerview.widget.RecyclerView
import com.breadwallet.tools.manager.BRSharedPrefs
import com.breadwallet.util.formatCryptoForUi
import com.breadwallet.util.formatFiatForUi
import com.fabriik.swap.R
import com.fabriik.swap.data.model.BuyingCurrencyData
import com.fabriik.swap.databinding.ListItemBuyingCurrencyBinding

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

    inner class CurrencyViewHolder(view: View) : RecyclerView.ViewHolder(view) {

        private val binding = ListItemBuyingCurrencyBinding.bind(view)

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

                viewIcon.loadIconForCurrency(
                    item.currency.name
                )
            }
        }
    }

    private object CallbackDiff : DiffUtil.ItemCallback<BuyingCurrencyData>() {

        override fun areItemsTheSame(oldItem: BuyingCurrencyData, newItem: BuyingCurrencyData) =
            newItem.currency.name == oldItem.currency.name

        override fun areContentsTheSame(oldItem: BuyingCurrencyData, newItem: BuyingCurrencyData) =
            newItem == oldItem
    }
}
