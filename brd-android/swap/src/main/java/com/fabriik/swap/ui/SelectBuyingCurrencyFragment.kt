package com.fabriik.swap.ui

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import androidx.navigation.fragment.findNavController
import com.fabriik.swap.R
import com.fabriik.swap.databinding.FragmentSelectCurrencyBinding
import java.util.*

class SelectBuyingCurrencyFragment : Fragment() {

    private lateinit var binding: FragmentSelectCurrencyBinding
    private lateinit var viewModel: SwapViewModel
    private val adapter = CurrenciesAdapter {
        viewModel.onBuyingCurrencySelected(it)
        navigateToAmountSelection()
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?
    ): View {
        return inflater.inflate(R.layout.fragment_select_currency, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        binding = FragmentSelectCurrencyBinding.bind(view)
        viewModel = ViewModelProvider(requireActivity())
            .get(SwapViewModel::class.java)

        viewModel.getBuyingCurrencies().observe(viewLifecycleOwner) {
            adapter.submitList(it)
        }

        viewModel.selectedSellingCurrency?.let {
            binding.title.text = getString(R.string.Swap_swapFor, it.name.toUpperCase(Locale.ROOT))
        }

        binding.apply {
            rvCurrencies.adapter = adapter
            rvCurrencies.setHasFixedSize(true)
            backButton.isVisible = true

            backButton.setOnClickListener {
                findNavController().popBackStack()
            }

            closeButton.setOnClickListener {
                requireActivity().finish()
            }
        }
    }

    private fun navigateToAmountSelection() {
        findNavController().navigate(
            R.id.action_select_amount
        )
    }
}