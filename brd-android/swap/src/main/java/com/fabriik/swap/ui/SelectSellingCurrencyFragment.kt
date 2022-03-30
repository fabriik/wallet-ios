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
import com.fabriik.swap.data.Status
import com.fabriik.swap.databinding.FragmentSelectCurrencyBinding

class SelectSellingCurrencyFragment : Fragment() {

    private lateinit var binding: FragmentSelectCurrencyBinding
    private lateinit var viewModel: SwapViewModel
    private val adapter = SellingCurrenciesAdapter {
        viewModel.onSellingCurrencySelected(it)
        navigateToBuyingCurrency()
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

        binding.apply {
            rvCurrencies.adapter = adapter
            rvCurrencies.setHasFixedSize(true)

            closeButton.setOnClickListener {
                requireActivity().finish()
            }
        }

        viewModel.getCurrencies().observe(viewLifecycleOwner) {
            when (it.status) {
                Status.SUCCESS -> {
                    binding.loadingBar.isVisible = false
                    adapter.submitList(
                        it.data
                    )
                }
                Status.LOADING -> {
                    binding.loadingBar.isVisible = true
                }
                Status.ERROR -> {
                    binding.loadingBar.isVisible = false
                    // todo
                }
            }
        }
    }

    private fun navigateToBuyingCurrency() {
        findNavController().navigate(
            R.id.action_buying_currency
        )
    }
}