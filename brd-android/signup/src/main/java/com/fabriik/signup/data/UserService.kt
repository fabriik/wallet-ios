package com.fabriik.signup.data

import com.fabriik.signup.data.requests.ConfirmRegistrationRequest
import com.fabriik.signup.data.requests.LoginRequest
import com.fabriik.signup.data.requests.RegisterRequest
import com.fabriik.signup.data.responses.ConfirmRegistrationResponse
import com.fabriik.signup.data.responses.LoginResponse
import com.fabriik.signup.data.responses.RegisterResponse
import com.fabriik.signup.data.responses.UserApiResponse
import org.json.JSONObject
import retrofit2.http.*

interface UserService {

    @POST("login")
    suspend fun login(
        @Body request: LoginRequest
    ) : UserApiResponse<LoginResponse>

    @POST("register")
    suspend fun register(
        @Body request: RegisterRequest
    ) : UserApiResponse<RegisterResponse>

    @POST("register/confirm")
    suspend fun confirmRegistration(
        @Body request: ConfirmRegistrationRequest
    ) : UserApiResponse<ConfirmRegistrationResponse>
}