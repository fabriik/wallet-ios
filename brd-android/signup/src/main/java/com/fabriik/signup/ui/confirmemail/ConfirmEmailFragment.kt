package com.fabriik.signup.ui.confirmemail

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import com.fabriik.signup.R
import com.fabriik.signup.databinding.FragmentConfirmEmailBinding
import com.fabriik.signup.ui.base.FabriikView

class ConfirmEmailFragment : Fragment(), FabriikView<ConfirmEmailViewState, ConfirmEmailViewEffect> {

    private lateinit var binding: FragmentConfirmEmailBinding
    private val viewModel: ConfirmEmailViewModel by lazy {
        ViewModelProvider(this).get(ConfirmEmailViewModel::class.java)
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?
    ): View {
        return inflater.inflate(R.layout.fragment_confirm_email, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        binding = FragmentConfirmEmailBinding.bind(view)
    }

    override fun render(state: ConfirmEmailViewState) {
        TODO("Not yet implemented")
    }

    override fun handleEffect(effect: ConfirmEmailViewEffect?) {
        TODO("Not yet implemented")
    }
}