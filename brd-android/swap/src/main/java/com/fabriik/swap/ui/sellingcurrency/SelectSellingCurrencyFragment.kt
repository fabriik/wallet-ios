package com.fabriik.swap.ui.sellingcurrency

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.core.view.isVisible
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.lifecycleScope
import androidx.navigation.fragment.findNavController
import com.fabriik.swap.R
import com.fabriik.swap.data.responses.SwapCurrency
import com.fabriik.swap.databinding.FragmentSelectCurrencyBinding
import kotlinx.coroutines.launch

class SelectSellingCurrencyFragment : Fragment() {

    private lateinit var binding: FragmentSelectCurrencyBinding

    private val viewModel: SelectSellingCurrencyViewModel by lazy {
        ViewModelProvider(this)
            .get(SelectSellingCurrencyViewModel::class.java)
    }

    private val adapter = SelectSellingCurrenciesAdapter {
        lifecycleScope.launch {
            viewModel.actions.send(
                SelectSellingCurrencyAction.CurrencySelected(it)
            )
        }
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?
    ): View {
        return inflater.inflate(R.layout.fragment_select_currency, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        binding = FragmentSelectCurrencyBinding.bind(view)

        binding.apply {
            rvCurrencies.adapter = adapter
            rvCurrencies.setHasFixedSize(true)

            closeButton.setOnClickListener {
                requireActivity().finish()
            }
        }

        viewModel.state.observe(viewLifecycleOwner) {
            render(it)
        }

        viewModel.effect.observe(viewLifecycleOwner) {
            handleEffect(it)
        }

        lifecycleScope.launch {
            viewModel.actions.send(
                SelectSellingCurrencyAction.LoadCurrencies
            )
        }
    }

    private fun handleEffect(effect: SelectSellingCurrencyEffect?) {
        when (effect) {
            SelectSellingCurrencyEffect.CloseScreen ->
                requireActivity().finish()
            is SelectSellingCurrencyEffect.NavigateToBuyingCurrencies ->
                navigateToBuyingCurrency(effect.sellingCurrency)
        }
    }

    private fun render(state: SelectSellingCurrencyState) {
        with(state) {
            binding.loadingBar.isVisible = isLoading
            adapter.submitList(currencies)

            if (errorMessage != null) {
                Toast.makeText(requireContext(), errorMessage, Toast.LENGTH_SHORT)
                    .show()
            }
        }
    }

    private fun navigateToBuyingCurrency(currency: SwapCurrency) {
        findNavController().navigate(
            R.id.action_buying_currency //todo: add currency
        )
    }
}