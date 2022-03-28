package com.fabriik.swap.ui

import androidx.lifecycle.LifecycleObserver
import androidx.lifecycle.ViewModel
import androidx.lifecycle.liveData
import com.fabriik.swap.data.Resource
import com.fabriik.swap.data.SwapApi
import kotlinx.coroutines.Dispatchers

class SwapViewModel(
    private val api: SwapApi = SwapApi.create()
) : ViewModel(), LifecycleObserver {

    fun getCurrencies() = liveData(Dispatchers.IO) {
        emit(
            Resource.loading(
                data = null
            )
        )

        try {
            emit(
                Resource.success(
                    data = api.getCurrencies()
                )
            )
        } catch (exception: Exception) {
            emit(
                Resource.error(
                    data = null,
                    message = exception.message ?: "Error Occurred!"
                )
            )
        }
    }
}