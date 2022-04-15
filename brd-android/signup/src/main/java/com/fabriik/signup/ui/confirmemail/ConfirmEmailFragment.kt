package com.fabriik.signup.ui.confirmemail

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import com.fabriik.signup.R
import com.fabriik.signup.databinding.FragmentConfirmEmailBinding

class ConfirmEmailFragment : Fragment() {

    private lateinit var binding: FragmentConfirmEmailBinding

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?
    ): View {
        return inflater.inflate(R.layout.fragment_confirm_email, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        binding = FragmentConfirmEmailBinding.bind(view)
    }
}