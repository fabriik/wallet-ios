package com.fabriik.kyc.ui.personalinformation

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.lifecycleScope
import com.fabriik.common.ui.base.FabriikView
import com.fabriik.kyc.R
import com.fabriik.kyc.databinding.FragmentAccountVerificationBinding
import com.fabriik.kyc.databinding.FragmentPersonalInformationBinding
import kotlinx.coroutines.flow.collect

class PersonalInformationFragment : Fragment(), FabriikView<PersonalInformationContract.State, PersonalInformationContract.Effect> {

    private lateinit var binding: FragmentPersonalInformationBinding
    private val viewModel: PersonalInformationViewModel by lazy {
        ViewModelProvider(this).get(PersonalInformationViewModel::class.java)
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?
    ): View {
        return inflater.inflate(R.layout.fragment_personal_information, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        binding = FragmentPersonalInformationBinding.bind(view)

        with(binding) {
            // todo: setuo
        }


        // collect UI state
        lifecycleScope.launchWhenStarted {
            viewModel.state.collect {
                render(it)
            }
        }

        // collect UI effect
        lifecycleScope.launchWhenStarted {
            viewModel.effect.collect {
                handleEffect(it)
            }
        }
    }

    override fun render(state: PersonalInformationContract.State) {
        with(binding) {

        }
    }

    override fun handleEffect(effect: PersonalInformationContract.Effect) {
        when (effect) {

        }
    }
}