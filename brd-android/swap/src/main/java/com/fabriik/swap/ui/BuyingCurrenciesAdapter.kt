package com.fabriik.swap.ui

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.ListAdapter
import androidx.recyclerview.widget.RecyclerView
import com.fabriik.swap.R
import com.fabriik.swap.data.responses.SwapCurrency
import com.fabriik.swap.databinding.ListItemBuyingCurrencyBinding
import com.fabriik.swap.utils.loadFromUrl
import java.util.*

class BuyingCurrenciesAdapter(private val callback: (SwapCurrency) -> Unit) :
    ListAdapter<SwapViewModel.BuyingCurrencyData, BuyingCurrenciesAdapter.CurrencyViewHolder>(
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

        fun bind(item: SwapViewModel.BuyingCurrencyData, callback: (SwapCurrency) -> Unit) {
            binding.apply {
                root.setOnClickListener { callback(item.currency) }

                val currencyCode = item.currency.name.toUpperCase(Locale.ROOT)
                ivIcon.loadFromUrl(item.currency.image)
                tvCurrency.text = item.currency.fullName
                tvCurrencyCode.text = currencyCode
                tvExchangeRate.text = "1 $currencyCode = ${item.rate.toPlainString()} ${item.currency.name}"
            }
        }
    }

    private object CallbackDiff : DiffUtil.ItemCallback<SwapViewModel.BuyingCurrencyData>() {

        override fun areItemsTheSame(oldItem: SwapViewModel.BuyingCurrencyData, newItem: SwapViewModel.BuyingCurrencyData) =
            newItem.currency.name == oldItem.currency.name

        override fun areContentsTheSame(oldItem: SwapViewModel.BuyingCurrencyData, newItem: SwapViewModel.BuyingCurrencyData) =
            newItem == oldItem
    }
}
