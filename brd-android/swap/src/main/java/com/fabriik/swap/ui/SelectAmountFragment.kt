package com.fabriik.swap.ui

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.widget.doAfterTextChanged
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import androidx.navigation.fragment.findNavController
import com.breadwallet.legacy.presenter.customviews.BRKeyboard
import com.fabriik.swap.R
import com.fabriik.swap.databinding.FragmentSelectAmountBinding
import com.fabriik.swap.utils.loadFromUrl
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.flow.callbackFlow
import java.math.BigDecimal
import java.util.*

class SelectAmountFragment : Fragment() {

    private lateinit var binding: FragmentSelectAmountBinding
    private lateinit var viewModel: SwapViewModel

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?
    ): View {
        return inflater.inflate(R.layout.fragment_select_amount, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        binding = FragmentSelectAmountBinding.bind(view)
        viewModel = ViewModelProvider(requireActivity())
            .get(SwapViewModel::class.java)

        viewModel.selectedSellingCurrency?.let { sellingCurrency ->
            viewModel.selectedBuyingCurrency?.let { buyingCurrency ->
                binding.title.text = getString(
                    R.string.Swap_swapFor2,
                    sellingCurrency.name.toUpperCase(Locale.ROOT),
                    buyingCurrency.name.toUpperCase(Locale.ROOT)
                )
            }
        }

        binding.apply {
            backButton.setOnClickListener {
                findNavController().popBackStack()
            }

            closeButton.setOnClickListener {
                requireActivity().finish()
            }

            btnContinue.setOnClickListener {
                findNavController().navigate(
                    R.id.action_swap_preview
                )
            }

            etPayWith.doAfterTextChanged {
                viewModel.onAmountChanged(
                    BigDecimal.TEN
                )
            }

            viewModel.selectedBuyingCurrency?.let {
                ivIconReceive.loadFromUrl(it.image)
            }

            viewModel.selectedSellingCurrency?.let {
                ivIconPayWith.loadFromUrl(it.image)
            }

            keyboard.bindInput()
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