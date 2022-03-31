package com.fabriik.swap.ui.buyingCurrency

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.core.view.isVisible
import androidx.core.widget.addTextChangedListener
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.lifecycleScope
import androidx.navigation.fragment.findNavController
import com.fabriik.swap.R
import com.fabriik.swap.data.responses.SwapCurrency
import com.fabriik.swap.databinding.FragmentSelectCurrencyBinding
import com.fabriik.swap.ui.SwapViewModel
import com.fabriik.swap.ui.base.SwapView
import com.fabriik.swap.ui.sellingcurrency.SelectSellingCurrencyAction
import com.fabriik.swap.ui.sellingcurrency.SelectSellingCurrencyEffect
import com.fabriik.swap.ui.sellingcurrency.SelectSellingCurrencyState
import com.fabriik.swap.ui.sellingcurrency.SelectSellingCurrencyViewModel
import kotlinx.coroutines.launch
import java.util.*

class SelectBuyingCurrencyFragment : Fragment(),
    SwapView<SelectBuyingCurrencyState, SelectBuyingCurrencyEffect> {

    private lateinit var binding: FragmentSelectCurrencyBinding

    private val adapter = SelectBuyingCurrencyAdapter {
        lifecycleScope.launch {
            viewModel.actions.send(
                SelectBuyingCurrencyAction.CurrencySelected(it)
            )
        }
    }

    private val viewModel: SelectBuyingCurrencyViewModel by lazy {
        ViewModelProvider(this)
            .get(SelectBuyingCurrencyViewModel::class.java)
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
            backButton.isVisible = true

            backButton.setOnClickListener {
                lifecycleScope.launch {
                    viewModel.actions.send(
                        SelectBuyingCurrencyAction.Back
                    )
                }
            }

            closeButton.setOnClickListener {
                lifecycleScope.launch {
                    viewModel.actions.send(
                        SelectBuyingCurrencyAction.Close
                    )
                }
            }

            searchEdit.addTextChangedListener {
                lifecycleScope.launch {
                    viewModel.actions.send(
                        SelectBuyingCurrencyAction.SearchChanged(
                            it?.toString() ?: ""
                        )
                    )
                }
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
                SelectBuyingCurrencyAction.LoadCurrencies
            )
        }
    }

    override fun render(state: SelectBuyingCurrencyState) {
        with(state) {
            binding.loadingBar.isVisible = isLoading
            binding.title.text = title
            adapter.submitList(currencies)

            if (errorMessage != null) {
                Toast.makeText(requireContext(), errorMessage, Toast.LENGTH_SHORT)
                    .show()
            }
        }
    }

    override fun handleEffect(effect: SelectBuyingCurrencyEffect?) {
        when (effect) {
            SelectBuyingCurrencyEffect.GoToHome ->
                requireActivity().finish()
            SelectBuyingCurrencyEffect.GoBack ->
                findNavController().popBackStack()
            is SelectBuyingCurrencyEffect.GoToAmountSelection ->
                navigateToAmountSelection(
                    sellingCurrency = effect.sellingCurrency,
                    buyingCurrency = effect.buyingCurrency
                )
        }
    }

    private fun navigateToAmountSelection(sellingCurrency: SwapCurrency, buyingCurrency: SwapCurrency) {
        findNavController().navigate(
            SelectBuyingCurrencyFragmentDirections.actionSelectAmount(
                sellingCurrency = sellingCurrency,
                buyingCurrency = buyingCurrency
            )
        )
    }
}