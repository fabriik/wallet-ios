package com.fabriik.swap.ui

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.ListAdapter
import androidx.recyclerview.widget.RecyclerView
import com.fabriik.swap.R
import com.fabriik.swap.data.responses.SwapCurrency
import com.fabriik.swap.databinding.ListItemCurrencyBinding

class CurrenciesAdapter(private val callback: (SwapCurrency) -> Unit) :
    ListAdapter<SwapCurrency, CurrenciesAdapter.CurrencyViewHolder>(
        CallbackDiff
    ) {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int) = CurrencyViewHolder(
        LayoutInflater.from(parent.context).inflate(
            R.layout.list_item_currency, parent, false
        )
    )

    override fun onBindViewHolder(holder: CurrencyViewHolder, position: Int) {
        holder.bind(
            item = getItem(position),
            callback = callback
        )
    }

    inner class CurrencyViewHolder(view: View) : RecyclerView.ViewHolder(view) {

        private val binding = ListItemCurrencyBinding.bind(view)

        fun bind(item: SwapCurrency, callback: (SwapCurrency) -> Unit) {
            //binding.ivIcon
            binding.tvCurrency.text = item.fullName
            binding.root.setOnClickListener {
                callback(item)
            }
        }
    }

    private object CallbackDiff : DiffUtil.ItemCallback<SwapCurrency>() {

        override fun areItemsTheSame(oldItem: SwapCurrency, newItem: SwapCurrency) =
            newItem.name == oldItem.name

        override fun areContentsTheSame(oldItem: SwapCurrency, newItem: SwapCurrency) =
            newItem == oldItem
    }
}
