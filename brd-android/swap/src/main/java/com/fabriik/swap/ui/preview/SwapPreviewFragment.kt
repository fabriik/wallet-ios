package com.fabriik.swap.ui.preview

import android.graphics.Color
import android.graphics.drawable.GradientDrawable
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.core.content.ContextCompat
import androidx.core.view.isVisible
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.lifecycleScope
import androidx.navigation.fragment.findNavController
import com.breadwallet.tools.util.TokenUtil
import com.breadwallet.util.formatCryptoForUi
import com.fabriik.swap.R
import com.fabriik.swap.databinding.FragmentSwapPreviewBinding
import com.fabriik.swap.ui.base.SwapView
import com.fabriik.swap.utils.loadFromUrl
import com.fabriik.swap.utils.viewScope
import com.squareup.picasso.Picasso
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.ensureActive
import kotlinx.coroutines.launch
import java.io.File
import java.util.*

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

            // load icon of selling currency
            binding.viewSellingIcon.loadIconForCurrency(
                currencyCode = sellingCurrency.name,
                scope = binding.viewSellingIcon.viewScope
            )

            // load icon of buying currency
            binding.viewBuyingIcon.loadIconForCurrency(
                currencyCode = buyingCurrency.name,
                scope = binding.viewSellingIcon.viewScope
            )

            binding.content.isVisible = state.isContentVisible
            binding.loadingBar.isVisible = state.isLoading

            exchangeData?.let {
                binding.tvSellingCurrency.text = it.amount.formatCryptoForUi(
                    sellingCurrency.name
                )

                binding.tvBuyingCurrency.text = it.result.formatCryptoForUi(
                    buyingCurrency.name
                )

                binding.tvFee.text = it.fee.formatCryptoForUi(
                    sellingCurrency.name
                )

                val formattedRateAmount = it.rate.formatCryptoForUi(
                    currencyCode = buyingCurrency.name
                )

                binding.tvPrice.text = "1 ${sellingCurrency.formatCode()} = $formattedRateAmount"

                binding.tvTotalCharge.text = it.amount.formatCryptoForUi(
                    sellingCurrency.name
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

    private fun loadTokenIcon(
        currencyCode: String,
        iconContainer: ViewGroup,
        iconLetter: TextView,
        iconWhite: ImageView
    ) {
        val defaultTokenColor = R.color.light_gray

        lifecycleScope.launch {
            // Get icon for currency
            val tokenIconPath = TokenUtil.getTokenIconPath(currencyCode, false)

            // Get icon color
            val tokenColor = TokenUtil.getTokenStartColor(currencyCode)

            ensureActive()

            with(binding) {
                val iconDrawable = iconContainer.background as GradientDrawable

                if (tokenIconPath.isNullOrBlank()) {
                    iconLetter.visibility = View.VISIBLE
                    iconWhite.visibility = View.GONE
                    iconLetter.text = currencyCode.take(1).toUpperCase(Locale.ROOT)
                } else {
                    val iconFile = File(tokenIconPath)
                    Picasso.get().load(iconFile).into(iconWhite)
                    iconLetter.visibility = View.GONE
                    iconWhite.visibility = View.VISIBLE
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
}