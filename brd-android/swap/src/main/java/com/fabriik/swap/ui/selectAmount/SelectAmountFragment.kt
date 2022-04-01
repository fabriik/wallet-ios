package com.fabriik.swap.ui.selectAmount

import android.graphics.Color
import android.graphics.drawable.GradientDrawable
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.core.content.ContextCompat
import androidx.core.widget.doAfterTextChanged
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.lifecycleScope
import androidx.navigation.fragment.findNavController
import com.breadwallet.util.formatCryptoForUi
import com.breadwallet.legacy.presenter.customviews.BRKeyboard
import com.breadwallet.tools.util.TokenUtil
import com.fabriik.swap.R
import com.fabriik.swap.data.responses.SwapCurrency
import com.fabriik.swap.databinding.FragmentSelectAmountBinding
import com.fabriik.swap.ui.base.SwapView
import com.fabriik.swap.ui.buyingCurrency.SelectBuyingCurrencyEffect
import com.fabriik.swap.ui.buyingCurrency.SelectBuyingCurrencyFragmentDirections
import com.fabriik.swap.utils.loadFromUrl
import com.squareup.picasso.Picasso
import kotlinx.coroutines.ensureActive
import kotlinx.coroutines.launch
import java.io.File
import java.math.BigDecimal
import java.util.*

class SelectAmountFragment : Fragment(), SwapView<SelectAmountState, SelectAmountEffect> {

    private lateinit var binding: FragmentSelectAmountBinding

    private val viewModel: SelectAmountViewModel by lazy {
        ViewModelProvider(this)
            .get(SelectAmountViewModel::class.java)
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?
    ): View {
        return inflater.inflate(R.layout.fragment_select_amount, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        binding = FragmentSelectAmountBinding.bind(view)

        binding.apply {
            etPayWith.showSoftInputOnFocus = false

            backButton.setOnClickListener {
                lifecycleScope.launch {
                    viewModel.actions.send(
                        SelectAmountAction.Back
                    )
                }
            }

            closeButton.setOnClickListener {
                lifecycleScope.launch {
                    viewModel.actions.send(
                        SelectAmountAction.Close
                    )
                }
            }

            btnContinue.setOnClickListener {
                lifecycleScope.launch {
                    viewModel.actions.send(
                        SelectAmountAction.ConfirmClicked
                    )
                }
            }

            etPayWith.doAfterTextChanged {
                lifecycleScope.launch {
                    viewModel.actions.send(
                        SelectAmountAction.AmountChanged(
                            it?.toString()?.toBigDecimal() ?: BigDecimal.ZERO
                        )
                    )
                }
            }

            viewModel.state.observe(viewLifecycleOwner) {
                render(it)
            }

            viewModel.effect.observe(viewLifecycleOwner) {
                handleEffect(it)
            }

            keyboard.bindInput()
        }
    }

    override fun render(state: SelectAmountState) {
        with(state) {
            binding.title.text = title

            binding.etReceive.setText(
                receivedAmount.formatCryptoForUi(
                    currencyCode = buyingCurrency.name,
                    showCurrencyCode = false
                )
            )

            // load icon of selling currency
            loadTokenIcon(
                iconWhite = binding.sellingCurrencyIconWhite,
                iconLetter = binding.sellingIconLetter,
                currencyCode = sellingCurrency.name,
                iconContainer = binding.sellingIconContainer
            )

            // load icon of buying currency
            loadTokenIcon(
                iconWhite = binding.buyingCurrencyIconWhite,
                iconLetter = binding.buyingIconLetter,
                currencyCode = buyingCurrency.name,
                iconContainer = binding.buyingIconContainer
            )
        }
    }

    override fun handleEffect(effect: SelectAmountEffect?) {
        when (effect) {
            SelectAmountEffect.GoToHome ->
                requireActivity().finish()
            SelectAmountEffect.GoBack ->
                findNavController().popBackStack()
            is SelectAmountEffect.GoToPreview ->
                navigateToPreview(
                    amount = effect.amount,
                    buyingCurrency = effect.buyingCurrency,
                    sellingCurrency = effect.sellingCurrency
                )
        }
    }

    private fun navigateToPreview(
        amount: BigDecimal,
        sellingCurrency: SwapCurrency,
        buyingCurrency: SwapCurrency
    ) {
        findNavController().navigate(
            SelectAmountFragmentDirections.actionSwapPreview(
                amount = amount,
                buyingCurrency = buyingCurrency,
                sellingCurrency = sellingCurrency
            )
        )
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

    private fun BRKeyboard.bindInput() {
        setOnInsertListener { key ->
            val operation = when {
                key.isEmpty() -> KeyboardOperation.Delete
                key[0] == '.' -> KeyboardOperation.AddDecimal
                Character.isDigit(key[0]) -> KeyboardOperation.AddDigit(key.toInt())
                else -> return@setOnInsertListener
            }

            binding.apply {
                val oldInput = etPayWith.text?.toString() ?: ""
                val newInput = operation.change(oldInput)
                etPayWith.setText(newInput)
            }
        }
    }

    sealed class KeyboardOperation {
        abstract fun change(oldInput: String): String

        object Delete : KeyboardOperation() {
            override fun change(oldInput: String) = when {
                oldInput.length > 1 -> oldInput.dropLast(1)
                else -> "0"
            }
        }

        object AddDecimal : KeyboardOperation() {
            override fun change(oldInput: String) = when {
                oldInput.contains(".") -> oldInput
                oldInput.isEmpty() -> "0."
                else -> "$oldInput."
            }
        }

        class AddDigit(private val digit: Int) : KeyboardOperation() {
            override fun change(oldInput: String) = when {
                oldInput == "0" && digit == 0 -> oldInput
                oldInput == "0" -> digit.toString()
                else -> oldInput + digit.toString()
            }
        }
    }
}