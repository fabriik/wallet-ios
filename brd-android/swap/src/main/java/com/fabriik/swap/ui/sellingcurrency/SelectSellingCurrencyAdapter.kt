package com.fabriik.swap.ui.sellingcurrency

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.ListAdapter
import androidx.recyclerview.widget.RecyclerView
import com.breadwallet.breadbox.formatCryptoForUi
import com.breadwallet.tools.manager.BRSharedPrefs
import com.breadwallet.ui.formatFiatForUi
import com.fabriik.swap.R
import com.fabriik.swap.data.model.SellingCurrencyData
import com.fabriik.swap.databinding.ListItemSellingCurrencyBinding
import com.fabriik.swap.utils.loadFromUrl
import java.util.*

class SelectSellingCurrencyAdapter(private val callback: (SellingCurrencyData) -> Unit) :
    ListAdapter<SellingCurrencyData, SelectSellingCurrencyAdapter.CurrencyViewHolder>(
        CallbackDiff
    ) {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int) = CurrencyViewHolder(
        LayoutInflater.from(parent.context).inflate(
            R.layout.list_item_selling_currency, parent, false
        )
    )

    override fun onBindViewHolder(holder: CurrencyViewHolder, position: Int) {
        holder.bind(
            item = getItem(position),
            callback = callback
        )
    }

    inner class CurrencyViewHolder(view: View) : RecyclerView.ViewHolder(view) {

        private val binding = ListItemSellingCurrencyBinding.bind(view)

        fun bind(item: SellingCurrencyData, callback: (SellingCurrencyData) -> Unit) {
            binding.apply {
                root.setOnClickListener { callback(item) }

                val currencyCode = item.currency.name.toUpperCase(Locale.ROOT)
                ivIcon.loadFromUrl(item.currency.image)
                tvCurrency.text = item.currency.fullName
                tvCurrencyCode.text = currencyCode
                tvCryptoBalance.text = item.cryptoBalance.formatCryptoForUi(
                    currencyCode = item.currency.name
                )
                tvFiatBalance.text = item.fiatBalance.formatFiatForUi(
                    currencyCode = BRSharedPrefs.getPreferredFiatIso()
                )
            }
        }
    }

    private object CallbackDiff : DiffUtil.ItemCallback<SellingCurrencyData>() {

        override fun areItemsTheSame(oldItem: SellingCurrencyData, newItem: SellingCurrencyData) =
            newItem.currency.name == oldItem.currency.name

        override fun areContentsTheSame(oldItem: SellingCurrencyData, newItem: SellingCurrencyData) =
            newItem == oldItem
    }
}
