package com.fabriik.swap.ui

import android.graphics.Color
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.content.ContextCompat
import androidx.core.graphics.drawable.DrawableCompat
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import androidx.navigation.fragment.findNavController
import com.fabriik.swap.R
import com.fabriik.swap.databinding.FragmentSelectAmountBinding
import com.fabriik.swap.databinding.FragmentSwapPreviewBinding
import com.fabriik.swap.utils.loadFromUrl
import com.squareup.picasso.Callback
import com.squareup.picasso.Picasso
import java.lang.Exception

class SwapPreviewFragment : Fragment() {

    private lateinit var binding: FragmentSwapPreviewBinding
    private lateinit var viewModel: SwapViewModel

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?
    ): View {
        return inflater.inflate(R.layout.fragment_swap_preview, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        binding = FragmentSwapPreviewBinding.bind(view)
        viewModel = ViewModelProvider(requireActivity())
            .get(SwapViewModel::class.java)

        binding.apply {
            backButton.setOnClickListener {
                findNavController().popBackStack()
            }

            closeButton.setOnClickListener {
                requireActivity().finish()
            }

            viewModel.selectedBuyingCurrency?.let {
                ivBuyingCurrency.loadFromUrl(it.image)
            }

            viewModel.selectedSellingCurrency?.let {
                ivSellingCurrency.loadFromUrl(it.image)
            }

            tvBuyingCurrency.text = "30.22 ETH"
            tvSellingCurrency.text = "2.22 BTC"
        }
    }
}