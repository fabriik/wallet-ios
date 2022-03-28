package com.fabriik.swap.ui

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import com.fabriik.swap.R
import com.fabriik.swap.databinding.FragmentSelectAmountBinding
import com.fabriik.swap.databinding.FragmentSwapPreviewBinding

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
    }
}