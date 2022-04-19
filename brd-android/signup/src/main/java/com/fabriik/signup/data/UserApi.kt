package com.fabriik.signup.data

import com.fabriik.signup.data.requests.ConfirmRegistrationRequest
import com.fabriik.signup.data.requests.LoginRequest
import com.fabriik.signup.data.requests.RegisterRequest
import com.fabriik.signup.data.responses.LoginResponse
import com.fabriik.signup.data.responses.RegisterResponse
import com.fabriik.signup.data.responses.UserApiResponse
import org.json.JSONObject
import retrofit2.Retrofit
import retrofit2.converter.moshi.MoshiConverterFactory

class UserApi(private val service: UserService) {

    suspend fun login(username: String, password: String) : Resource<LoginResponse> {
        val response = service.login(
            LoginRequest(
                username = username,
                password = password
            )
        )

        return mapToResource(response)
    }

    suspend fun register(email: String, phone: String, firstName: String, lastName: String, password: String) : Resource<RegisterResponse> {
        val response = service.register(
            RegisterRequest(
                email = email,
                phone = phone,
                password = password,
                lastName = lastName,
                firstName = firstName
            )
        )

        return mapToResource(response)
    }

    suspend fun confirmRegistration(sessionKey: String, confirmationCode: String) : Resource<JSONObject> {
        val response = service.confirmRegistration(
            ConfirmRegistrationRequest(
                sessionKey = sessionKey,
                confirmationCode = confirmationCode
            )
        )

        return mapToResource(response)
    }

    private fun <T> mapToResource(response: UserApiResponse<T>) : Resource<T> {
        return when {
            response.result == "ok" && response.data != null ->
                Resource.success(response.data)
            response.result == "error" && response.error != null ->
                Resource.error(message = response.error.code)
            else ->
                Resource.error(message = "Unknown error - invalid state")
        }
    }

    companion object {

        fun create() = UserApi(
            Retrofit.Builder()
                .baseUrl(FabriikApiConstants.HOST_AUTH_API)
                .addConverterFactory(MoshiConverterFactory.create())
                .build()
                .create(UserService::class.java)
        )
    }
}