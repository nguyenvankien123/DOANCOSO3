# Shopping API Documentation

## Base URL
```
http://localhost:8080/api/v1
```

## Authentication
Hầu hết các endpoint yêu cầu JWT token. Thêm header sau vào yêu cầu:
```
Authorization: Bearer {token}
```

---

## 1. Authentication Endpoints (`/auth`)

### 1.1 Register (Đăng ký)
- **URL:** `POST /auth/register`
- **Auth Required:** No
- **Request Body:**
```json
{
  "name": "Nguyễn Văn A",
  "email": "user@example.com",
  "password": "password123",
  "phone": "0901234567",
  "address": "123 Hà Nội, Hà Nội"
}
```
- **Response Success (201):**
```json
{
  "success": true,
  "message": "User registered successfully",
  "data": {
    "id": 1,
    "name": "Nguyễn Văn A",
    "email": "user@example.com",
    "phone": "0901234567",
    "address": "123 Hà Nội, Hà Nội",
    "avatar": null,
    "role": "user",
    "token": "eyJhbGciOiJIUzUxMiJ9..."
  },
  "timestamp": 1684396298000
}
```

### 1.2 Login (Đăng nhập)
- **URL:** `POST /auth/login`
- **Auth Required:** No
- **Request Body:**
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```
- **Response Success (200):** Same as Register

---

## 2. Product Endpoints (`/products`)

### 2.1 Get All Products (Lấy tất cả sản phẩm)
- **URL:** `GET /products?page=0&size=10`
- **Auth Required:** No
- **Query Parameters:**
  - `page` (default: 0)
  - `size` (default: 10)
- **Response Success (200):**
```json
{
  "success": true,
  "message": "Products retrieved successfully",
  "data": {
    "content": [
      {
        "id": 1,
        "name": "iPhone 15 Pro",
        "description": "iPhone 15 Pro 128GB",
        "price": 25000000.00,
        "discount": 5,
        "rating": 4.8,
        "sold": 245,
        "stock": 50,
        "image": null,
        "shopName": "Apple Store",
        "eta": "2-3 ngày",
        "categoryId": 1,
        "categoryName": "Điện thoại"
      }
    ],
    "totalElements": 8,
    "totalPages": 1,
    "page": 0,
    "size": 10
  },
  "timestamp": 1684396298000
}
```

### 2.2 Get Product by ID (Lấy thông tin sản phẩm)
- **URL:** `GET /products/{id}`
- **Auth Required:** No
- **Response Success (200):** Same as single product in Get All Products

### 2.3 Get Products by Category (Lấy sản phẩm theo danh mục)
- **URL:** `GET /products/category/{categoryId}?page=0&size=10`
- **Auth Required:** No
- **Response Success (200):** Same as Get All Products

### 2.4 Search Products (Tìm kiếm sản phẩm)
- **URL:** `GET /products/search?keyword=iphone`
- **Auth Required:** No
- **Query Parameters:**
  - `keyword` (required)
- **Response Success (200):**
```json
{
  "success": true,
  "message": "Products found",
  "data": [
    {
      "id": 1,
      "name": "iPhone 15 Pro",
      ...
    }
  ],
  "timestamp": 1684396298000
}
```

### 2.5 Create Product (Tạo sản phẩm - Admin Only)
- **URL:** `POST /products`
- **Auth Required:** Yes
- **Request Body:**
```json
{
  "name": "iPhone 16 Pro",
  "description": "iPhone 16 Pro 256GB",
  "price": 26000000.00,
  "discount": 5,
  "stock": 50,
  "categoryId": 1,
  "image": "url_to_image",
  "shopName": "Apple Store",
  "eta": "2-3 ngày"
}
```
- **Response Success (201):** Single product response

### 2.6 Update Product (Cập nhật sản phẩm - Admin Only)
- **URL:** `PUT /products/{id}`
- **Auth Required:** Yes
- **Request Body:** Same as Create Product
- **Response Success (200):** Single product response

### 2.7 Delete Product (Xóa sản phẩm - Admin Only)
- **URL:** `DELETE /products/{id}`
- **Auth Required:** Yes
- **Response Success (200):**
```json
{
  "success": true,
  "message": "Product deleted successfully",
  "timestamp": 1684396298000
}
```

---

## 3. Category Endpoints (`/categories`)

### 3.1 Get All Categories (Lấy tất cả danh mục)
- **URL:** `GET /categories`
- **Auth Required:** No
- **Response Success (200):**
```json
{
  "success": true,
  "message": "Categories retrieved successfully",
  "data": [
    {
      "id": 1,
      "name": "Điện thoại",
      "description": "Điện thoại di động các hãng",
      "createdAt": "2026-05-18T08:51:38",
      "updatedAt": "2026-05-18T08:51:38"
    }
  ],
  "timestamp": 1684396298000
}
```

### 3.2 Get Category by ID (Lấy thông tin danh mục)
- **URL:** `GET /categories/{id}`
- **Auth Required:** No
- **Response Success (200):** Single category response

### 3.3 Create Category (Tạo danh mục - Admin Only)
- **URL:** `POST /categories`
- **Auth Required:** Yes
- **Request Body:**
```json
{
  "name": "Tên danh mục",
  "description": "Mô tả danh mục"
}
```
- **Response Success (201):** Single category response

### 3.4 Update Category (Cập nhật danh mục - Admin Only)
- **URL:** `PUT /categories/{id}`
- **Auth Required:** Yes
- **Request Body:** Same as Create Category
- **Response Success (200):** Single category response

### 3.5 Delete Category (Xóa danh mục - Admin Only)
- **URL:** `DELETE /categories/{id}`
- **Auth Required:** Yes
- **Response Success (200):** Success message

---

## 4. Cart Endpoints (`/cart`)

### 4.1 Add to Cart (Thêm vào giỏ hàng)
- **URL:** `POST /cart/{userId}/add`
- **Auth Required:** Yes
- **Request Body:**
```json
{
  "productId": 1,
  "quantity": 2
}
```
- **Response Success (200):**
```json
{
  "success": true,
  "message": "Product added to cart",
  "timestamp": 1684396298000
}
```

### 4.2 Get Cart (Lấy giỏ hàng)
- **URL:** `GET /cart/{userId}`
- **Auth Required:** Yes
- **Response Success (200):**
```json
{
  "success": true,
  "message": "Cart retrieved successfully",
  "data": [
    {
      "id": 1,
      "name": "iPhone 15 Pro",
      "price": 25000000.00,
      ...
    }
  ],
  "timestamp": 1684396298000
}
```

### 4.3 Update Cart Item (Cập nhật số lượng)
- **URL:** `PUT /cart/{userId}/update?productId={productId}&quantity={quantity}`
- **Auth Required:** Yes
- **Response Success (200):** Success message

### 4.4 Remove from Cart (Xóa khỏi giỏ hàng)
- **URL:** `DELETE /cart/{userId}/remove?productId={productId}`
- **Auth Required:** Yes
- **Response Success (200):** Success message

### 4.5 Clear Cart (Xóa hết giỏ hàng)
- **URL:** `DELETE /cart/{userId}/clear`
- **Auth Required:** Yes
- **Response Success (200):** Success message

---

## 5. Order Endpoints (`/orders`)

### 5.1 Create Order (Tạo đơn hàng)
- **URL:** `POST /orders/{userId}/create?shippingAddress={address}&paymentMethod={method}`
- **Auth Required:** Yes
- **Query Parameters:**
  - `shippingAddress` (required): Địa chỉ giao hàng
  - `paymentMethod` (required): credit_card, bank_transfer, etc.
- **Response Success (201):**
```json
{
  "success": true,
  "message": "Order created successfully",
  "data": {
    "id": 1,
    "totalPrice": 55000000.00,
    "status": "pending",
    "shippingAddress": "123 Hà Nội, Hà Nội",
    "paymentMethod": "credit_card",
    "createdAt": "2026-05-18T08:51:38",
    "items": [
      {
        "productId": 1,
        "productName": "iPhone 15 Pro",
        "quantity": 2,
        "price": 25000000.00
      }
    ]
  },
  "timestamp": 1684396298000
}
```

### 5.2 Get Order by ID (Lấy thông tin đơn hàng)
- **URL:** `GET /orders/{id}`
- **Auth Required:** Yes
- **Response Success (200):** Single order response

### 5.3 Get User Orders (Lấy danh sách đơn hàng của người dùng)
- **URL:** `GET /orders/user/{userId}`
- **Auth Required:** Yes
- **Response Success (200):**
```json
{
  "success": true,
  "message": "Orders retrieved successfully",
  "data": [
    {
      "id": 1,
      "totalPrice": 55000000.00,
      ...
    }
  ],
  "timestamp": 1684396298000
}
```

### 5.4 Get User Orders (Paginated)
- **URL:** `GET /orders/user/{userId}/paginated?page=0&size=10`
- **Auth Required:** Yes
- **Response Success (200):** Paginated orders

### 5.5 Update Order Status (Cập nhật trạng thái đơn hàng - Admin Only)
- **URL:** `PUT /orders/{id}/status?status={status}`
- **Auth Required:** Yes
- **Query Parameters:**
  - `status`: pending, processing, shipped, delivered, cancelled
- **Response Success (200):** Success message

---

## 6. Review Endpoints (`/reviews`)

### 6.1 Add Review (Thêm đánh giá)
- **URL:** `POST /reviews?productId={productId}&userId={userId}&rating={rating}&comment={comment}`
- **Auth Required:** Yes
- **Query Parameters:**
  - `productId` (required)
  - `userId` (required)
  - `rating` (required): 1-5
  - `comment` (optional)
- **Response Success (201):**
```json
{
  "success": true,
  "message": "Review added successfully",
  "data": {
    "id": 1,
    "productId": 1,
    "userId": 1,
    "rating": 5,
    "comment": "Sản phẩm rất tốt!",
    "createdAt": "2026-05-18T08:51:38"
  },
  "timestamp": 1684396298000
}
```

### 6.2 Get Product Reviews (Lấy đánh giá sản phẩm)
- **URL:** `GET /reviews/product/{productId}`
- **Auth Required:** No
- **Response Success (200):**
```json
{
  "success": true,
  "message": "Reviews retrieved successfully",
  "data": [
    {
      "id": 1,
      "productId": 1,
      "userId": 1,
      "rating": 5,
      "comment": "Sản phẩm rất tốt!",
      "createdAt": "2026-05-18T08:51:38"
    }
  ],
  "timestamp": 1684396298000
}
```

### 6.3 Delete Review (Xóa đánh giá - Admin Only)
- **URL:** `DELETE /reviews/{id}`
- **Auth Required:** Yes
- **Response Success (200):** Success message

---

## Error Response Format

Tất cả các lỗi sẽ trả về dạng:
```json
{
  "success": false,
  "message": "Chi tiết lỗi",
  "timestamp": 1684396298000
}
```

### Common Error Codes
- **400 Bad Request:** Yêu cầu không hợp lệ
- **401 Unauthorized:** Không có quyền truy cập
- **404 Not Found:** Tài nguyên không tìm thấy
- **500 Internal Server Error:** Lỗi máy chủ

---

## Installation & Running

### Prerequisites
- Java 21+
- MySQL 8.0+
- Maven 3.6+

### Setup Database
```bash
mysql -u root -p < database.sql
```

### Configure Application
Edit `application.properties`:
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/finalterm
spring.datasource.username=root
spring.datasource.password=your_password
```

### Build & Run
```bash
mvn clean install
mvn spring-boot:run
```

API sẽ chạy trên: `http://localhost:8080`

---

## Android Retrofit Integration Example

### Add Dependencies (build.gradle)
```gradle
dependencies {
    implementation 'com.squareup.retrofit2:retrofit:2.9.0'
    implementation 'com.squareup.retrofit2:converter-gson:2.9.0'
    implementation 'com.squareup.okhttp3:okhttp:4.10.0'
}
```

### Create API Service
```kotlin
interface ApiService {
    @POST("auth/register")
    suspend fun register(@Body request: RegisterRequest): Response<ApiResponse<AuthResponse>>
    
    @POST("auth/login")
    suspend fun login(@Body request: LoginRequest): Response<ApiResponse<AuthResponse>>
    
    @GET("products")
    suspend fun getProducts(
        @Query("page") page: Int = 0,
        @Query("size") size: Int = 10
    ): Response<ApiResponse<PagedResponse<ProductResponse>>>
    
    @POST("cart/{userId}/add")
    suspend fun addToCart(
        @Path("userId") userId: Int,
        @Body request: CartRequest
    ): Response<ApiResponse<Unit>>
    
    // ... other endpoints
}
```

### Create Retrofit Instance
```kotlin
object RetrofitClient {
    private const val BASE_URL = "http://your-server-ip:8080/api/v1/"
    
    private val httpClient = OkHttpClient.Builder()
        .addInterceptor { chain ->
            val request = chain.request().newBuilder()
                .addHeader("Authorization", "Bearer ${TokenManager.getToken()}")
                .build()
            chain.proceed(request)
        }
        .build()
    
    val apiService: ApiService by lazy {
        Retrofit.Builder()
            .baseUrl(BASE_URL)
            .client(httpClient)
            .addConverterFactory(GsonConverterFactory.create())
            .build()
            .create(ApiService::class.java)
    }
}
```

---

**API được tạo bằng Spring Boot 4.0.6 với Java 21**
