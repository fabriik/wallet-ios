package com.fabriik.signup.ui.confirmemail

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.lifecycleScope
import com.fabriik.signup.R
import com.fabriik.signup.databinding.FragmentConfirmEmailBinding
import com.fabriik.signup.ui.base.FabriikView
import com.fabriik.signup.ui.login.LogInViewAction
import kotlinx.coroutines.launch

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

        binding.btnConfirm.setOnClickListener {
            lifecycleScope.launch {
                viewModel.actions.send(
                    ConfirmEmailViewAction.ConfirmClicked(
                        binding.etCode.text.toString()
                    )
                )
            }
        }

        binding.tvResend.setOnClickListener {
            lifecycleScope.launch {
                viewModel.actions.send(
                    ConfirmEmailViewAction.ResendCodeClicked
                )
            }
        }

        viewModel.state.observe(viewLifecycleOwner) {
            render(it)
        }

        viewModel.effect.observe(viewLifecycleOwner) {
            handleEffect(it)
        }
    }

    override fun render(state: ConfirmEmailViewState) {
        with(state) {
            //todo: loading
        }
    }

    override fun handleEffect(effect: ConfirmEmailViewEffect?) {
        when (effect) {
            is ConfirmEmailViewEffect.FinishWithToastMessage -> {
                Toast.makeText(
                    context, effect.message, Toast.LENGTH_LONG
                ).show()
                requireActivity().finish()
            }
        }
    }
}