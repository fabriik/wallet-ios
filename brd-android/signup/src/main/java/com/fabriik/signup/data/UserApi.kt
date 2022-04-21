package com.fabriik.signup.data

import android.content.Context
import com.fabriik.signup.R
import com.fabriik.signup.data.requests.*
import com.fabriik.signup.data.responses.ConfirmRegistrationResponse
import com.fabriik.signup.data.responses.LoginResponse
import com.fabriik.signup.data.responses.RegisterResponse
import com.fabriik.signup.data.responses.UserApiResponse
import com.squareup.moshi.Moshi
import com.squareup.moshi.Types
import retrofit2.HttpException
import retrofit2.Retrofit
import retrofit2.converter.moshi.MoshiConverterFactory
import java.lang.Exception
import kotlin.reflect.KClass

class UserApi(
    private val context: Context,
    private val service: UserService
) {

    private val moshi = Moshi.Builder().build()

    suspend fun login(username: String, password: String) : Resource<LoginResponse?> {
        return try {
            val response = service.login(
                LoginRequest(
                    username = username,
                    password = password
                )
            )
            mapToResource(response)
        } catch (ex: Exception) {
            mapToResource(ex, LoginResponse::class)
        }
    }

    suspend fun register(email: String, phone: String, firstName: String, lastName: String, password: String) : Resource<RegisterResponse?> {
        return try {
            val response = service.register(
                RegisterRequest(
                    email = email,
                    phone = phone,
                    password = password,
                    lastName = lastName,
                    firstName = firstName
                )
            )
            mapToResource(response)
        } catch (ex: Exception) {
            mapToResource(ex, RegisterResponse::class)
        }
    }

    suspend fun confirmRegistration(sessionKey: String, confirmationCode: String) : Resource<ConfirmRegistrationResponse?> {
        return try {
            val response = service.confirmRegistration(
                ConfirmRegistrationRequest(
                    sessionKey = sessionKey,
                    confirmationCode = confirmationCode
                )
            )
            mapToResource(response)
        } catch (ex: Exception) {
            mapToResource(ex, ConfirmRegistrationResponse::class)
        }
    }

    suspend fun startPasswordReset(email: String) : Resource<String?> {
        return try {
            val response = service.startPasswordReset(
                StartPasswordResetRequest(email)
            )
            mapToResource(response)
        } catch (ex: Exception) {
            mapToResource(ex, String::class)
        }
    }

    suspend fun resetPassword(code: String, password: String) : Resource<String?> {
        return try {
            val response = service.resetPassword(
                PasswordResetRequest(
                    key = code,
                    password = password
                )
            )

            mapToResource(response)
        } catch (ex: Exception) {
            mapToResource(ex, String::class)
        }
    }

    private fun <T> mapToResource(response: UserApiResponse<T?>) : Resource<T?> {
        return when {
            response.result == "ok" ->
                Resource.success(response.data)
            response.result == "error" && response.error != null ->
                Resource.error(message = response.error.code)
            else ->
                Resource.error(message = "Unknown error - invalid state")
        }
    }

    private fun <T> mapToResource(ex: Exception, kClass: KClass<*>) : Resource<T?> {
        var errorMessage: String? = null

        if (ex is HttpException) {
            ex.response()?.errorBody()?.let {
                val responseType = Types.newParameterizedType(UserApiResponse::class.java, kClass.java)
                val responseAdapter = moshi.adapter<UserApiResponse<Any>>(responseType)

                val response = responseAdapter.fromJson(
                    it.source()
                )

                errorMessage = response?.error?.message
            }
        }

        return Resource.error(
            message = errorMessage ?: context.getString(R.string.SignUp_DefaultErrorMessage)
        )
    }

    companion object {

        fun create(context: Context) = UserApi(
            context = context.applicationContext,
            service = Retrofit.Builder()
                .baseUrl(FabriikApiConstants.HOST_AUTH_API)
                .addConverterFactory(MoshiConverterFactory.create())
                .build()
                .create(UserService::class.java)
        )
    }
}