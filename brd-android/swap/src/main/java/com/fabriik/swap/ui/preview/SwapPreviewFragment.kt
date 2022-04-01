package com.fabriik.swap.ui.preview

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.lifecycleScope
import androidx.navigation.fragment.findNavController
import com.breadwallet.util.formatCryptoForUi
import com.fabriik.swap.R
import com.fabriik.swap.databinding.FragmentSwapPreviewBinding
import com.fabriik.swap.ui.base.SwapView
import com.fabriik.swap.utils.loadFromUrl
import kotlinx.coroutines.launch

class SwapPreviewFragment : Fragment(), SwapView<SwapPreviewState, SwapPreviewEffect> {

    private lateinit var binding: FragmentSwapPreviewBinding

    private val viewModel: SwapPreviewViewModel by lazy {
        ViewModelProvider(this)
            .get(SwapPreviewViewModel::class.java)
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?
    ): View {
        return inflater.inflate(R.layout.fragment_swap_preview, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        binding = FragmentSwapPreviewBinding.bind(view)

        binding.apply {
            backButton.setOnClickListener {
                lifecycleScope.launch {
                    viewModel.actions.send(
                        SwapPreviewAction.Back
                    )
                }
            }

            closeButton.setOnClickListener {
                lifecycleScope.launch {
                    viewModel.actions.send(
                        SwapPreviewAction.Close
                    )
                }
            }

            btnConfirm.setOnClickListener {
                lifecycleScope.launch {
                    viewModel.actions.send(
                        SwapPreviewAction.ConfirmClicked
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
                SwapPreviewAction.LoadExchangeData
            )
        }
    }

    override fun render(state: SwapPreviewState) {
        with(state) {
            binding.ivSellingCurrency.loadFromUrl(
                sellingCurrency.image
            )

            binding.ivBuyingCurrency.loadFromUrl(
                buyingCurrency.image
            )

            exchangeData?.let {
                binding.tvSellingCurrency.text = it.amount.formatCryptoForUi(
                    sellingCurrency.name
                )

                binding.tvBuyingCurrency.text = it.result.formatCryptoForUi(
                    buyingCurrency.name
                )
            }
        }
    }

    override fun handleEffect(effect: SwapPreviewEffect?) {
        when (effect) {
            SwapPreviewEffect.GoToHome ->
                requireActivity().finish()
            SwapPreviewEffect.GoBack ->
                findNavController().popBackStack()
        }
    }
}