package com.fabriik.signup.ui

import android.content.Context
import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.databinding.DataBindingUtil
import androidx.navigation.findNavController
import com.fabriik.signup.R
import com.fabriik.signup.databinding.ActivitySignupBinding

class SignupActivity : AppCompatActivity() {

    private lateinit var binding: ActivitySignupBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = DataBindingUtil.setContentView(this, R.layout.activity_signup)

        with(binding) {
            btnBack.setOnClickListener {
                findNavController(R.id.nav_host_fragment).popBackStack()
            }
            btnDismiss.setOnClickListener { finish() }
        }
    }

    companion object {
        fun getStartIntent(context: Context) = Intent(context, SignupActivity::class.java)
    }
}