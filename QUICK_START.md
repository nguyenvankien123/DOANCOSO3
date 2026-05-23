# 🚀 Quick Start Guide

Hướng dẫn nhanh để chạy Web API Shopping.

## ⚡ 5 Bước Khởi Động Nhanh

### Bước 1: Chuẩn Bị Database (1 phút)

```bash
# Kết nối MySQL
mysql -u root -p

# Chạy file database.sql
source database.sql
```

Hoặc:
```bash
mysql -u root -p < database.sql
```

### Bước 2: Cấu Hình Application (2 phút)

Edit file `springboot-backend/src/main/resources/application.properties`:

```properties
# Thay đổi thông tin kết nối database
spring.datasource.url=jdbc:mysql://localhost:3306/finalterm
spring.datasource.username=root
spring.datasource.password=YOUR_PASSWORD
```

### Bước 3: Build Project (3-5 phút)

```bash
cd springboot-backend
mvn clean install
```

### Bước 4: Chạy Application (1 phút)

```bash
mvn spring-boot:run
```

✅ API sẽ chạy trên: `http://localhost:8080`

### Bước 5: Test API (2 phút)

Sử dụng Postman hoặc cURL:

```bash
# Login
curl -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user1@example.com",
    "password": "password"
  }'

# Lấy token từ response
# Sử dụng token này cho các request khác

# Lấy danh sách sản phẩm
curl -X GET http://localhost:8080/api/v1/products
```

---

## 📝 Sample Accounts

| Email | Password | Role |
|-------|----------|------|
| user1@example.com | password | User |
| user2@example.com | password | User |
| admin@example.com | password | Admin |

---

## 🎯 Các Endpoint Chính

### Authentication
```
POST   /api/v1/auth/register       Đăng ký
POST   /api/v1/auth/login          Đăng nhập
```

### Products
```
GET    /api/v1/products            Danh sách sản phẩm
GET    /api/v1/products/{id}       Chi tiết sản phẩm
GET    /api/v1/products/search     Tìm kiếm
```

### Cart
```
POST   /api/v1/cart/{userId}/add            Thêm vào giỏ
GET    /api/v1/cart/{userId}                Xem giỏ hàng
DELETE /api/v1/cart/{userId}/remove        Xóa khỏi giỏ
```

### Orders
```
POST   /api/v1/orders/{userId}/create  Tạo đơn hàng
GET    /api/v1/orders/{id}             Xem đơn hàng
```

---

## 🔍 Troubleshooting Nhanh

### ❌ Database Connection Error
```
Error: Cannot connect to database
```
**✅ Giải pháp:**
1. Kiểm tra MySQL đang chạy: `mysql -u root -p`
2. Kiểm tra database: `SHOW DATABASES;`
3. Kiểm tra thông tin connection trong `application.properties`

### ❌ Port 8080 Already in Use
```
Error: Address already in use
```
**✅ Giải pháp:**
1. Đổi port: `server.port=8081` (trong application.properties)
2. Hoặc kill process cũ: `lsof -i :8080`

### ❌ Build Failed
```
Error: [ERROR] COMPILATION ERROR
```
**✅ Giải pháp:**
1. Kiểm tra Java 21 được cài: `java -version`
2. Clear Maven cache: `mvn clean`
3. Update dependencies: `mvn dependency:resolve`

### ❌ JWT Token Invalid
```
Error: Unauthorized
```
**✅ Giải pháp:**
1. Kiểm tra token format: `Bearer {token}`
2. Kiểm tra token chưa hết hạn
3. Gửi request login mới để lấy token mới

---

## 📱 Android Integration (Quick Setup)

### 1. Add Dependencies
```gradle
implementation("com.squareup.retrofit2:retrofit:2.10.0")
implementation("com.squareup.retrofit2:converter-gson:2.10.0")
implementation("com.squareup.okhttp3:okhttp:4.11.0")
```

### 2. Create Retrofit Instance
```kotlin
object RetrofitClient {
    private const val BASE_URL = "http://192.168.1.100:8080/api/v1/"
    
    val apiService: ApiService by lazy {
        Retrofit.Builder()
            .baseUrl(BASE_URL)
            .addConverterFactory(GsonConverterFactory.create())
            .build()
            .create(ApiService::class.java)
    }
}
```

### 3. Create API Service
```kotlin
interface ApiService {
    @GET("products")
    suspend fun getProducts(): Response<ApiResponse<List<ProductResponse>>>
    
    @POST("auth/login")
    suspend fun login(@Body request: LoginRequest): Response<ApiResponse<AuthResponse>>
}
```

### 4. Use in ViewModel
```kotlin
viewModelScope.launch {
    val response = RetrofitClient.apiService.getProducts()
    if (response.isSuccessful) {
        val products = response.body()?.data
    }
}
```

---

## 📚 Documentation Files

| File | Nội dung |
|------|---------|
| [README.md](./README.md) | Tổng quan dự án, cấu trúc, thiết lập |
| [API_DOCUMENTATION.md](./API_DOCUMENTATION.md) | Chi tiết tất cả endpoints, examples |
| [ANDROID_RETROFIT_GUIDE.md](./ANDROID_RETROFIT_GUIDE.md) | Hướng dẫn tích hợp Android Retrofit |

---

## 🔗 Useful Links

- [Spring Boot Docs](https://spring.io/projects/spring-boot)
- [MySQL Documentation](https://dev.mysql.com/doc/)
- [Retrofit Guide](https://square.github.io/retrofit/)
- [Jetpack Compose](https://developer.android.com/jetpack/compose)
- [Kotlin Coroutines](https://kotlinlang.org/docs/coroutines-overview.html)

---

## 💡 Tips

1. **Sử dụng Postman** để test API trước khi integrate vào Android
2. **Lưu token** sau khi login, dùng cho các request tiếp theo
3. **Kiểm tra response** trong Postman để hiểu cấu trúc dữ liệu
4. **Dùng ngrok** nếu muốn test từ device vật lý (không chỉ emulator)

---

## ✨ Next Steps

1. ✅ Setup và chạy API
2. ✅ Test endpoints bằng Postman
3. ✅ Integrate vào Android app
4. ✅ Deploy lên server

---

## 📞 Support

Nếu gặp vấn đề:
1. Xem file documentation tương ứng
2. Kiểm tra error message trong console
3. Xem phần Troubleshooting ở trên

---

**Ready to go? Let's build! 🚀**
