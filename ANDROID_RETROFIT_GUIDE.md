# Android Retrofit Integration Guide

Hướng dẫn chi tiết để tích hợp Web API vào ứng dụng Android Kotlin với Jetpack Compose.

## 📦 Dependencies Setup

### Step 1: Add to `build.gradle.kts` (Module: app)

```kotlin
dependencies {
    // Retrofit
    implementation("com.squareup.retrofit2:retrofit:2.10.0")
    implementation("com.squareup.retrofit2:converter-gson:2.10.0")
    implementation("com.squareup.okhttp3:okhttp:4.11.0")
    implementation("com.squareup.okhttp3:logging-interceptor:4.11.0")
    
    // Kotlin Coroutines
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.7.1")
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-core:1.7.1")
    
    // Jetpack Compose (if not already added)
    implementation(platform("androidx.compose:compose-bom:2024.01.00"))
    implementation("androidx.compose.ui:ui")
    implementation("androidx.compose.material3:material3")
    implementation("androidx.lifecycle:lifecycle-viewmodel-compose:2.6.1")
    
    // Hilt for Dependency Injection
    implementation("com.google.dagger:hilt-android:2.47")
    kapt("com.google.dagger:hilt-compiler:2.47")
    
    // DataStore for storing tokens
    implementation("androidx.datastore:datastore-preferences:1.0.0")
}

plugins {
    id("com.google.dagger.hilt.android")
    kotlin("kapt")
}
```

## 🏗️ Project Structure

```
app/
├── data/
│   ├── api/
│   │   ├── ApiService.kt
│   │   ├── RetrofitClient.kt
│   │   └── interceptor/
│   │       └── AuthInterceptor.kt
│   ├── model/
│   │   ├── request/
│   │   │   ├── LoginRequest.kt
│   │   │   ├── RegisterRequest.kt
│   │   │   ├── CartRequest.kt
│   │   │   └── ProductRequest.kt
│   │   ├── response/
│   │   │   ├── ApiResponse.kt
│   │   │   ├── AuthResponse.kt
│   │   │   ├── ProductResponse.kt
│   │   │   └── OrderResponse.kt
│   │   └── entity/
│   │       ├── Product.kt
│   │       ├── Order.kt
│   │       └── Review.kt
│   ├── repository/
│   │   ├── AuthRepository.kt
│   │   ├── ProductRepository.kt
│   │   ├── CartRepository.kt
│   │   └── OrderRepository.kt
│   └── datastore/
│       └── TokenManager.kt
├── ui/
│   ├── viewmodel/
│   │   ├── AuthViewModel.kt
│   │   ├── ProductViewModel.kt
│   │   ├── CartViewModel.kt
│   │   └── OrderViewModel.kt
│   └── screen/
│       ├── LoginScreen.kt
│       ├── ProductListScreen.kt
│       ├── CartScreen.kt
│       └── OrderScreen.kt
└── MyApplication.kt
```

## 📡 API Models

### Step 1: Create API Response Wrapper

**data/model/response/ApiResponse.kt**
```kotlin
package com.example.shoppingapp.data.model.response

data class ApiResponse<T>(
    val success: Boolean,
    val message: String,
    val data: T? = null,
    val timestamp: Long = 0
)

// Paged response
data class PagedResponse<T>(
    val content: List<T>,
    val totalElements: Long,
    val totalPages: Int,
    val page: Int,
    val size: Int
)
```

### Step 2: Create Request/Response Models

**data/model/request/LoginRequest.kt**
```kotlin
package com.example.shoppingapp.data.model.request

data class LoginRequest(
    val email: String,
    val password: String
)

data class RegisterRequest(
    val name: String,
    val email: String,
    val password: String,
    val phone: String,
    val address: String
)

data class CartRequest(
    val productId: Int,
    val quantity: Int
)
```

**data/model/response/AuthResponse.kt**
```kotlin
package com.example.shoppingapp.data.model.response

data class AuthResponse(
    val id: Int,
    val name: String,
    val email: String,
    val phone: String,
    val address: String,
    val avatar: String?,
    val role: String,
    val token: String
)
```

**data/model/response/ProductResponse.kt**
```kotlin
package com.example.shoppingapp.data.model.response

import java.math.BigDecimal

data class ProductResponse(
    val id: Int,
    val name: String,
    val description: String,
    val price: BigDecimal,
    val discount: Int,
    val rating: Float,
    val sold: Int,
    val stock: Int,
    val image: String?,
    val shopName: String,
    val eta: String,
    val categoryId: Int,
    val categoryName: String
)

data class CategoryResponse(
    val id: Int,
    val name: String,
    val description: String
)

data class ReviewResponse(
    val id: Int,
    val productId: Int,
    val userId: Int,
    val rating: Int,
    val comment: String,
    val createdAt: String
)
```

**data/model/response/OrderResponse.kt**
```kotlin
package com.example.shoppingapp.data.model.response

import java.math.BigDecimal

data class OrderResponse(
    val id: Int,
    val totalPrice: BigDecimal,
    val status: String,
    val shippingAddress: String,
    val paymentMethod: String,
    val createdAt: String,
    val items: List<OrderItemResponse>
) {
    data class OrderItemResponse(
        val productId: Int,
        val productName: String,
        val quantity: Int,
        val price: BigDecimal
    )
}
```

## 🔐 Token Management

### Step 1: Create TokenManager

**data/datastore/TokenManager.kt**
```kotlin
package com.example.shoppingapp.data.datastore

import android.content.Context
import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.stringPreferencesKey
import androidx.datastore.preferences.preferencesDataStore
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map

private val Context.dataStore: DataStore<Preferences> by preferencesDataStore(name = "user_prefs")

class TokenManager(private val context: Context) {
    companion object {
        private val TOKEN_KEY = stringPreferencesKey("auth_token")
        private val USER_ID_KEY = stringPreferencesKey("user_id")
    }
    
    suspend fun saveToken(token: String) {
        context.dataStore.edit { preferences ->
            preferences[TOKEN_KEY] = token
        }
    }
    
    suspend fun saveUserId(userId: String) {
        context.dataStore.edit { preferences ->
            preferences[USER_ID_KEY] = userId
        }
    }
    
    fun getToken(): Flow<String?> = context.dataStore.data.map { preferences ->
        preferences[TOKEN_KEY]
    }
    
    fun getUserId(): Flow<String?> = context.dataStore.data.map { preferences ->
        preferences[USER_ID_KEY]
    }
    
    suspend fun clearToken() {
        context.dataStore.edit { preferences ->
            preferences[TOKEN_KEY] = ""
            preferences[USER_ID_KEY] = ""
        }
    }
}
```

## 🌐 Retrofit Setup

### Step 1: Create AuthInterceptor

**data/api/interceptor/AuthInterceptor.kt**
```kotlin
package com.example.shoppingapp.data.api.interceptor

import com.example.shoppingapp.data.datastore.TokenManager
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.runBlocking
import okhttp3.Interceptor
import okhttp3.Response

class AuthInterceptor(private val tokenManager: TokenManager) : Interceptor {
    override fun intercept(chain: Interceptor.Chain): Response {
        val originalRequest = chain.request()
        
        val token = runBlocking { tokenManager.getToken().first() }
        
        if (token.isNullOrEmpty()) {
            return chain.proceed(originalRequest)
        }
        
        val authenticatedRequest = originalRequest.newBuilder()
            .header("Authorization", "Bearer $token")
            .build()
        
        return chain.proceed(authenticatedRequest)
    }
}
```

### Step 2: Create API Service Interface

**data/api/ApiService.kt**
```kotlin
package com.example.shoppingapp.data.api

import com.example.shoppingapp.data.model.request.CartRequest
import com.example.shoppingapp.data.model.request.LoginRequest
import com.example.shoppingapp.data.model.request.RegisterRequest
import com.example.shoppingapp.data.model.response.ApiResponse
import com.example.shoppingapp.data.model.response.AuthResponse
import com.example.shoppingapp.data.model.response.CategoryResponse
import com.example.shoppingapp.data.model.response.OrderResponse
import com.example.shoppingapp.data.model.response.PagedResponse
import com.example.shoppingapp.data.model.response.ProductResponse
import com.example.shoppingapp.data.model.response.ReviewResponse
import retrofit2.Response
import retrofit2.http.Body
import retrofit2.http.DELETE
import retrofit2.http.GET
import retrofit2.http.POST
import retrofit2.http.PUT
import retrofit2.http.Path
import retrofit2.http.Query

interface ApiService {
    
    // ============ AUTH ============
    @POST("auth/register")
    suspend fun register(@Body request: RegisterRequest): Response<ApiResponse<AuthResponse>>
    
    @POST("auth/login")
    suspend fun login(@Body request: LoginRequest): Response<ApiResponse<AuthResponse>>
    
    // ============ PRODUCTS ============
    @GET("products")
    suspend fun getProducts(
        @Query("page") page: Int = 0,
        @Query("size") size: Int = 10
    ): Response<ApiResponse<PagedResponse<ProductResponse>>>
    
    @GET("products/{id}")
    suspend fun getProductById(@Path("id") id: Int): Response<ApiResponse<ProductResponse>>
    
    @GET("products/category/{categoryId}")
    suspend fun getProductsByCategory(
        @Path("categoryId") categoryId: Int,
        @Query("page") page: Int = 0,
        @Query("size") size: Int = 10
    ): Response<ApiResponse<PagedResponse<ProductResponse>>>
    
    @GET("products/search")
    suspend fun searchProducts(@Query("keyword") keyword: String): Response<ApiResponse<List<ProductResponse>>>
    
    // ============ CATEGORIES ============
    @GET("categories")
    suspend fun getAllCategories(): Response<ApiResponse<List<CategoryResponse>>>
    
    @GET("categories/{id}")
    suspend fun getCategoryById(@Path("id") id: Int): Response<ApiResponse<CategoryResponse>>
    
    // ============ CART ============
    @POST("cart/{userId}/add")
    suspend fun addToCart(
        @Path("userId") userId: Int,
        @Body request: CartRequest
    ): Response<ApiResponse<Unit>>
    
    @GET("cart/{userId}")
    suspend fun getCart(@Path("userId") userId: Int): Response<ApiResponse<List<ProductResponse>>>
    
    @PUT("cart/{userId}/update")
    suspend fun updateCartItem(
        @Path("userId") userId: Int,
        @Query("productId") productId: Int,
        @Query("quantity") quantity: Int
    ): Response<ApiResponse<Unit>>
    
    @DELETE("cart/{userId}/remove")
    suspend fun removeFromCart(
        @Path("userId") userId: Int,
        @Query("productId") productId: Int
    ): Response<ApiResponse<Unit>>
    
    @DELETE("cart/{userId}/clear")
    suspend fun clearCart(@Path("userId") userId: Int): Response<ApiResponse<Unit>>
    
    // ============ ORDERS ============
    @POST("orders/{userId}/create")
    suspend fun createOrder(
        @Path("userId") userId: Int,
        @Query("shippingAddress") shippingAddress: String,
        @Query("paymentMethod") paymentMethod: String
    ): Response<ApiResponse<OrderResponse>>
    
    @GET("orders/{id}")
    suspend fun getOrderById(@Path("id") id: Int): Response<ApiResponse<OrderResponse>>
    
    @GET("orders/user/{userId}")
    suspend fun getUserOrders(@Path("userId") userId: Int): Response<ApiResponse<List<OrderResponse>>>
    
    @PUT("orders/{id}/status")
    suspend fun updateOrderStatus(
        @Path("id") id: Int,
        @Query("status") status: String
    ): Response<ApiResponse<Unit>>
    
    // ============ REVIEWS ============
    @POST("reviews")
    suspend fun addReview(
        @Query("productId") productId: Int,
        @Query("userId") userId: Int,
        @Query("rating") rating: Int,
        @Query("comment") comment: String? = null
    ): Response<ApiResponse<ReviewResponse>>
    
    @GET("reviews/product/{productId}")
    suspend fun getProductReviews(@Path("productId") productId: Int): Response<ApiResponse<List<ReviewResponse>>>
}
```

### Step 3: Create Retrofit Client

**data/api/RetrofitClient.kt**
```kotlin
package com.example.shoppingapp.data.api

import android.content.Context
import com.example.shoppingapp.data.api.interceptor.AuthInterceptor
import com.example.shoppingapp.data.datastore.TokenManager
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import java.util.concurrent.TimeUnit

object RetrofitClient {
    
    private const val BASE_URL = "http://192.168.1.100:8080/api/v1/" // Thay IP của server
    
    fun getInstance(context: Context): ApiService {
        val tokenManager = TokenManager(context)
        
        val httpClient = OkHttpClient.Builder()
            .addInterceptor(AuthInterceptor(tokenManager))
            .addInterceptor(HttpLoggingInterceptor().apply {
                level = HttpLoggingInterceptor.Level.BODY
            })
            .connectTimeout(30, TimeUnit.SECONDS)
            .readTimeout(30, TimeUnit.SECONDS)
            .writeTimeout(30, TimeUnit.SECONDS)
            .build()
        
        return Retrofit.Builder()
            .baseUrl(BASE_URL)
            .client(httpClient)
            .addConverterFactory(GsonConverterFactory.create())
            .build()
            .create(ApiService::class.java)
    }
}
```

## 📚 Repository Pattern

### Step 1: Create Repositories

**data/repository/AuthRepository.kt**
```kotlin
package com.example.shoppingapp.data.repository

import com.example.shoppingapp.data.api.ApiService
import com.example.shoppingapp.data.datastore.TokenManager
import com.example.shoppingapp.data.model.request.LoginRequest
import com.example.shoppingapp.data.model.request.RegisterRequest
import com.example.shoppingapp.data.model.response.AuthResponse
import javax.inject.Inject

class AuthRepository @Inject constructor(
    private val apiService: ApiService,
    private val tokenManager: TokenManager
) {
    
    suspend fun register(request: RegisterRequest): Result<AuthResponse> {
        return try {
            val response = apiService.register(request)
            if (response.isSuccessful) {
                val authResponse = response.body()?.data
                if (authResponse != null) {
                    tokenManager.saveToken(authResponse.token)
                    tokenManager.saveUserId(authResponse.id.toString())
                    Result.success(authResponse)
                } else {
                    Result.failure(Exception("Invalid response"))
                }
            } else {
                Result.failure(Exception(response.message()))
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
    
    suspend fun login(request: LoginRequest): Result<AuthResponse> {
        return try {
            val response = apiService.login(request)
            if (response.isSuccessful) {
                val authResponse = response.body()?.data
                if (authResponse != null) {
                    tokenManager.saveToken(authResponse.token)
                    tokenManager.saveUserId(authResponse.id.toString())
                    Result.success(authResponse)
                } else {
                    Result.failure(Exception("Invalid response"))
                }
            } else {
                Result.failure(Exception(response.message()))
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
    
    suspend fun logout() {
        tokenManager.clearToken()
    }
}
```

**data/repository/ProductRepository.kt**
```kotlin
package com.example.shoppingapp.data.repository

import com.example.shoppingapp.data.api.ApiService
import com.example.shoppingapp.data.model.response.PagedResponse
import com.example.shoppingapp.data.model.response.ProductResponse
import javax.inject.Inject

class ProductRepository @Inject constructor(
    private val apiService: ApiService
) {
    
    suspend fun getProducts(page: Int = 0, size: Int = 10): Result<PagedResponse<ProductResponse>> {
        return try {
            val response = apiService.getProducts(page, size)
            if (response.isSuccessful) {
                val data = response.body()?.data
                if (data != null) {
                    Result.success(data)
                } else {
                    Result.failure(Exception("No data"))
                }
            } else {
                Result.failure(Exception(response.message()))
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
    
    suspend fun getProductById(id: Int): Result<ProductResponse> {
        return try {
            val response = apiService.getProductById(id)
            if (response.isSuccessful) {
                val data = response.body()?.data
                if (data != null) {
                    Result.success(data)
                } else {
                    Result.failure(Exception("Product not found"))
                }
            } else {
                Result.failure(Exception(response.message()))
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
    
    suspend fun searchProducts(keyword: String): Result<List<ProductResponse>> {
        return try {
            val response = apiService.searchProducts(keyword)
            if (response.isSuccessful) {
                val data = response.body()?.data
                if (data != null) {
                    Result.success(data)
                } else {
                    Result.failure(Exception("No results"))
                }
            } else {
                Result.failure(Exception(response.message()))
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
}
```

**data/repository/CartRepository.kt**
```kotlin
package com.example.shoppingapp.data.repository

import com.example.shoppingapp.data.api.ApiService
import com.example.shoppingapp.data.model.request.CartRequest
import com.example.shoppingapp.data.model.response.ProductResponse
import javax.inject.Inject

class CartRepository @Inject constructor(
    private val apiService: ApiService
) {
    
    suspend fun addToCart(userId: Int, request: CartRequest): Result<Unit> {
        return try {
            val response = apiService.addToCart(userId, request)
            if (response.isSuccessful) {
                Result.success(Unit)
            } else {
                Result.failure(Exception(response.message()))
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
    
    suspend fun getCart(userId: Int): Result<List<ProductResponse>> {
        return try {
            val response = apiService.getCart(userId)
            if (response.isSuccessful) {
                val data = response.body()?.data
                if (data != null) {
                    Result.success(data)
                } else {
                    Result.failure(Exception("Cart is empty"))
                }
            } else {
                Result.failure(Exception(response.message()))
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
    
    suspend fun updateCartItem(userId: Int, productId: Int, quantity: Int): Result<Unit> {
        return try {
            val response = apiService.updateCartItem(userId, productId, quantity)
            if (response.isSuccessful) {
                Result.success(Unit)
            } else {
                Result.failure(Exception(response.message()))
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
    
    suspend fun removeFromCart(userId: Int, productId: Int): Result<Unit> {
        return try {
            val response = apiService.removeFromCart(userId, productId)
            if (response.isSuccessful) {
                Result.success(Unit)
            } else {
                Result.failure(Exception(response.message()))
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
    
    suspend fun clearCart(userId: Int): Result<Unit> {
        return try {
            val response = apiService.clearCart(userId)
            if (response.isSuccessful) {
                Result.success(Unit)
            } else {
                Result.failure(Exception(response.message()))
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
}
```

## 🎬 ViewModel Examples

**ui/viewmodel/AuthViewModel.kt**
```kotlin
package com.example.shoppingapp.ui.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.shoppingapp.data.model.request.LoginRequest
import com.example.shoppingapp.data.model.request.RegisterRequest
import com.example.shoppingapp.data.model.response.AuthResponse
import com.example.shoppingapp.data.repository.AuthRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class AuthViewModel @Inject constructor(
    private val authRepository: AuthRepository
) : ViewModel() {
    
    private val _authState = MutableStateFlow<AuthState>(AuthState.Idle)
    val authState: StateFlow<AuthState> = _authState
    
    fun login(email: String, password: String) {
        viewModelScope.launch {
            _authState.value = AuthState.Loading
            val result = authRepository.login(LoginRequest(email, password))
            result.onSuccess { authResponse ->
                _authState.value = AuthState.Success(authResponse)
            }.onFailure { error ->
                _authState.value = AuthState.Error(error.message ?: "Unknown error")
            }
        }
    }
    
    fun register(name: String, email: String, password: String, phone: String, address: String) {
        viewModelScope.launch {
            _authState.value = AuthState.Loading
            val result = authRepository.register(
                RegisterRequest(name, email, password, phone, address)
            )
            result.onSuccess { authResponse ->
                _authState.value = AuthState.Success(authResponse)
            }.onFailure { error ->
                _authState.value = AuthState.Error(error.message ?: "Unknown error")
            }
        }
    }
    
    fun logout() {
        viewModelScope.launch {
            authRepository.logout()
            _authState.value = AuthState.Idle
        }
    }
}

sealed class AuthState {
    object Idle : AuthState()
    object Loading : AuthState()
    data class Success(val data: AuthResponse) : AuthState()
    data class Error(val message: String) : AuthState()
}
```

**ui/viewmodel/ProductViewModel.kt**
```kotlin
package com.example.shoppingapp.ui.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.shoppingapp.data.model.response.PagedResponse
import com.example.shoppingapp.data.model.response.ProductResponse
import com.example.shoppingapp.data.repository.ProductRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class ProductViewModel @Inject constructor(
    private val productRepository: ProductRepository
) : ViewModel() {
    
    private val _productState = MutableStateFlow<ProductState>(ProductState.Idle)
    val productState: StateFlow<ProductState> = _productState
    
    fun getProducts(page: Int = 0) {
        viewModelScope.launch {
            _productState.value = ProductState.Loading
            val result = productRepository.getProducts(page)
            result.onSuccess { data ->
                _productState.value = ProductState.Success(data)
            }.onFailure { error ->
                _productState.value = ProductState.Error(error.message ?: "Unknown error")
            }
        }
    }
    
    fun searchProducts(keyword: String) {
        viewModelScope.launch {
            _productState.value = ProductState.Loading
            val result = productRepository.searchProducts(keyword)
            result.onSuccess { data ->
                _productState.value = ProductState.SearchSuccess(data)
            }.onFailure { error ->
                _productState.value = ProductState.Error(error.message ?: "Unknown error")
            }
        }
    }
}

sealed class ProductState {
    object Idle : ProductState()
    object Loading : ProductState()
    data class Success(val data: PagedResponse<ProductResponse>) : ProductState()
    data class SearchSuccess(val data: List<ProductResponse>) : ProductState()
    data class Error(val message: String) : ProductState()
}
```

## 🎨 Jetpack Compose Screens

**ui/screen/LoginScreen.kt**
```kotlin
package com.example.shoppingapp.ui.screen

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Button
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import com.example.shoppingapp.ui.viewmodel.AuthState
import com.example.shoppingapp.ui.viewmodel.AuthViewModel

@Composable
fun LoginScreen(
    viewModel: AuthViewModel = hiltViewModel(),
    onLoginSuccess: () -> Unit = {}
) {
    val authState = viewModel.authState.collectAsState().value
    val email = remember { mutableStateOf("") }
    val password = remember { mutableStateOf("") }
    
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = androidx.compose.foundation.layout.Arrangement.Center
    ) {
        Text(
            text = "Login",
            style = MaterialTheme.typography.headlineLarge
        )
        
        Spacer(modifier = Modifier.height(20.dp))
        
        OutlinedTextField(
            value = email.value,
            onValueChange = { email.value = it },
            label = { Text("Email") },
            modifier = Modifier.fillMaxWidth()
        )
        
        Spacer(modifier = Modifier.height(10.dp))
        
        OutlinedTextField(
            value = password.value,
            onValueChange = { password.value = it },
            label = { Text("Password") },
            visualTransformation = PasswordVisualTransformation(),
            modifier = Modifier.fillMaxWidth()
        )
        
        Spacer(modifier = Modifier.height(20.dp))
        
        Button(
            onClick = { 
                viewModel.login(email.value, password.value)
            },
            modifier = Modifier.fillMaxWidth()
        ) {
            when (authState) {
                is AuthState.Loading -> CircularProgressIndicator()
                else -> Text("Login")
            }
        }
        
        when (authState) {
            is AuthState.Success -> {
                Text("Login successful!", style = MaterialTheme.typography.bodySmall)
                onLoginSuccess()
            }
            is AuthState.Error -> {
                Text((authState as AuthState.Error).message, style = MaterialTheme.typography.bodySmall)
            }
            else -> {}
        }
    }
}
```

## 📱 Important Notes

### IP Configuration
Thay đổi IP address trong `RetrofitClient.kt`:
```kotlin
private const val BASE_URL = "http://YOUR_SERVER_IP:8080/api/v1/"
```

### Network Security
Thêm `network_security_config.xml` cho development:
```xml
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <domain-config cleartextTrafficPermitted="true">
        <domain includeSubdomains="true">192.168.1.100</domain>
    </domain-config>
</network-security-config>
```

### Permissions
Thêm vào `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

---

**Happy Coding! 🚀**
