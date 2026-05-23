package com.example.ui.features.userprofile

import android.app.Application
import android.widget.Toast
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.NavController
import coil.compose.AsyncImage
import com.example.data.remote.RetrofitClient
import com.example.data.repository.ProfileRepository
import com.example.ui.theme.*

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun PersonalInfoScreen(navController: NavController) {
    val context = LocalContext.current
    val application = context.applicationContext as Application

    val userViewModel: UserViewModel = viewModel(
        factory = remember(application) {
            val apiService = RetrofitClient.getApiService(application)
            val profileRepository = ProfileRepository(apiService)
            UserViewModelFactory(application, profileRepository)
        }
    )

    var name by userViewModel.name
    var email by userViewModel.email
    var phone by userViewModel.phone
    var address by userViewModel.address
    var avatarUrlForm by userViewModel.avatar // Kết nối trực tiếp biến avatar mới của ViewModel

    val isLoading by userViewModel.isLoading
    val isSaving by userViewModel.isSaving
    val errorMessage by userViewModel.errorMessage
    val saveSuccessMsg by userViewModel.saveSuccessMsg

    // Trạng thái quản lý đóng/mở hộp thoại nhập URL ảnh đại diện mới
    var showAvatarDialog by remember { mutableStateOf(false) }
    var tempAvatarUrl by remember { mutableStateOf("") }

    LaunchedEffect(Unit) {
        userViewModel.loadUserProfile()
    }

    LaunchedEffect(saveSuccessMsg, errorMessage) {
        saveSuccessMsg?.let {
            Toast.makeText(context, it, Toast.LENGTH_SHORT).show()
            userViewModel.saveSuccessMsg.value = null
        }
        errorMessage?.let {
            Toast.makeText(context, it, Toast.LENGTH_SHORT).show()
            userViewModel.errorMessage.value = null
        }
    }

    // 🔴 HỘP THOẠI ĐỔI URL AVATAR MỚI
    if (showAvatarDialog) {
        AlertDialog(
            onDismissRequest = { showAvatarDialog = false },
            title = {
                Text(
                    "Thay đổi ảnh đại diện",
                    fontSize = 16.sp,
                    fontWeight = FontWeight.Bold
                )
            },
            text = {
                Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                    Text(
                        "Nhập đường dẫn URL ảnh mới của bạn:",
                        fontSize = 13.sp,
                        color = Color.Gray
                    )
                    OutlinedTextField(
                        value = tempAvatarUrl,
                        onValueChange = { tempAvatarUrl = it },
                        placeholder = { Text("https://example.com/image.png") },
                        modifier = Modifier.fillMaxWidth(),
                        shape = RoundedCornerShape(8.dp)
                    )
                }
            },
            confirmButton = {
                Button(
                    onClick = {
                        avatarUrlForm = tempAvatarUrl // Cập nhật link tạm vào link chính Form
                        showAvatarDialog = false
                    },
                    colors = ButtonDefaults.buttonColors(containerColor = PurpleMain)
                ) {
                    Text("Áp dụng", color = Color.White)
                }
            },
            dismissButton = {
                TextButton(onClick = { showAvatarDialog = false }) {
                    Text("Hủy", color = Color.Gray)
                }
            }
        )
    }

    Scaffold(
        containerColor = Color.White,
        topBar = {
            CenterAlignedTopAppBar(
                title = {
                    Text(
                        text = "Thông Tin Cá Nhân",
                        fontWeight = FontWeight.Bold,
                        fontSize = 20.sp,
                        color = Color.Black
                    )
                },
                navigationIcon = {
                    IconButton(onClick = { navController.popBackStack() }) {
                        Icon(
                            Icons.Default.ArrowBack,
                            contentDescription = "Back",
                            tint = Color.Black
                        )
                    }
                },
                colors = TopAppBarDefaults.centerAlignedTopAppBarColors(containerColor = Color.White)
            )
        }
    ) { paddingValues ->

        if (isLoading) {
            Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                CircularProgressIndicator(color = PurpleMain)
            }
        } else {
            Column(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(paddingValues)
                    .padding(horizontal = 20.dp)
                    .verticalScroll(rememberScrollState()),
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.spacedBy(20.dp)
            ) {

                Spacer(modifier = Modifier.height(10.dp))

                // PHẦN 1: Hiển thị Avatar (Sẽ thay đổi ngay khi bạn nhập URL mới vào hộp thoại)
                Box(
                    contentAlignment = Alignment.BottomEnd,
                    modifier = Modifier.padding(bottom = 8.dp)
                ) {
                    if (avatarUrlForm.isNotBlank()) {
                        AsyncImage(
                            model = avatarUrlForm,
                            contentDescription = "Profile Picture",
                            modifier = Modifier
                                .size(100.dp)
                                .clip(CircleShape)
                                .background(PurpleLightBg),
                            contentScale = ContentScale.Crop
                        )
                    } else {
                        Box(
                            modifier = Modifier
                                .size(100.dp)
                                .clip(CircleShape)
                                .background(PurpleLightBg),
                            contentAlignment = Alignment.Center
                        ) {
                            Icon(
                                Icons.Default.Person,
                                contentDescription = "Default",
                                tint = PurpleMain,
                                modifier = Modifier.size(54.dp)
                            )
                        }
                    }

                    // Nút bấm sửa ảnh đại diện
                    Box(
                        modifier = Modifier
                            .size(30.dp)
                            .clip(CircleShape)
                            .background(PurpleMain)
                            .clickable {
                                tempAvatarUrl =
                                    avatarUrlForm // Gán link hiện tại vào ô nhập mặc định
                                showAvatarDialog = true // Mở hộp thoại nhập link
                            },
                        contentAlignment = Alignment.Center
                    ) {
                        Icon(
                            Icons.Default.Edit,
                            contentDescription = "Edit Photo",
                            tint = Color.White,
                            modifier = Modifier.size(14.dp)
                        )
                    }
                }

                // PHẦN 2: Danh sách các trường thông tin cá nhân
                Card(
                    modifier = Modifier.fillMaxWidth(),
                    shape = RoundedCornerShape(20.dp),
                    colors = CardDefaults.cardColors(containerColor = BgGrayLight.copy(alpha = 0.7f))
                ) {
                    Column(
                        modifier = Modifier.padding(16.dp),
                        verticalArrangement = Arrangement.spacedBy(16.dp)
                    ) {
                        // 1. Trường Họ tên
                        Text(
                            "Họ và Tên",
                            fontSize = 14.sp,
                            fontWeight = FontWeight.Bold,
                            color = Color.Black
                        )
                        OutlinedTextField(
                            value = name,
                            onValueChange = { name = it },
                            leadingIcon = {
                                Icon(
                                    Icons.Default.Person,
                                    contentDescription = null,
                                    tint = PurpleMain
                                )
                            },
                            modifier = Modifier.fillMaxWidth(),
                            singleLine = true,
                            shape = RoundedCornerShape(12.dp),
                            colors = OutlinedTextFieldDefaults.colors(
                                focusedBorderColor = PurpleMain,
                                unfocusedBorderColor = Color.LightGray.copy(alpha = 0.5f),
                                focusedContainerColor = Color.White,
                                unfocusedContainerColor = Color.White
                            )
                        )

                        // 2. Trường Email (Khóa cố định)
                        Text(
                            "Địa chỉ Email",
                            fontSize = 14.sp,
                            fontWeight = FontWeight.Bold,
                            color = Color.Black
                        )
                        OutlinedTextField(
                            value = email,
                            onValueChange = { email = it },
                            leadingIcon = {
                                Icon(
                                    Icons.Default.Email,
                                    contentDescription = null,
                                    tint = PurpleMain
                                )
                            },
                            modifier = Modifier.fillMaxWidth(),
                            singleLine = true,
                            enabled = false,
                            shape = RoundedCornerShape(12.dp),
                            colors = OutlinedTextFieldDefaults.colors(
                                focusedBorderColor = PurpleMain,
                                unfocusedBorderColor = Color.LightGray.copy(alpha = 0.5f),
                                focusedContainerColor = Color.White,
                                unfocusedContainerColor = Color.White,
                                disabledContainerColor = Color(0xFFF1F5F9),
                                disabledBorderColor = Color.LightGray.copy(alpha = 0.3f)
                            )
                        )

                        // 3. Trường Số điện thoại
                        Text(
                            "Số Điện Thoại",
                            fontSize = 14.sp,
                            fontWeight = FontWeight.Bold,
                            color = Color.Black
                        )
                        OutlinedTextField(
                            value = phone,
                            onValueChange = { phone = it },
                            leadingIcon = {
                                Icon(
                                    Icons.Default.Phone,
                                    contentDescription = null,
                                    tint = PurpleMain
                                )
                            },
                            modifier = Modifier.fillMaxWidth(),
                            singleLine = true,
                            shape = RoundedCornerShape(12.dp),
                            colors = OutlinedTextFieldDefaults.colors(
                                focusedBorderColor = PurpleMain,
                                unfocusedBorderColor = Color.LightGray.copy(alpha = 0.5f),
                                focusedContainerColor = Color.White,
                                unfocusedContainerColor = Color.White
                            )
                        )

                        // 4. Trường Địa chỉ mặc định
                        Text(
                            "Địa Chỉ Mặc Định",
                            fontSize = 14.sp,
                            fontWeight = FontWeight.Bold,
                            color = Color.Black
                        )
                        OutlinedTextField(
                            value = address,
                            onValueChange = { address = it },
                            leadingIcon = {
                                Icon(
                                    Icons.Default.Home,
                                    contentDescription = null,
                                    tint = PurpleMain
                                )
                            },
                            modifier = Modifier.fillMaxWidth(),
                            shape = RoundedCornerShape(12.dp),
                            colors = OutlinedTextFieldDefaults.colors(
                                focusedBorderColor = PurpleMain,
                                unfocusedBorderColor = Color.LightGray.copy(alpha = 0.5f),
                                focusedContainerColor = Color.White,
                                unfocusedContainerColor = Color.White
                            )
                        )
                    }
                }

                // PHẦN 3: Nút bấm Lưu thay đổi chính dưới chân trang
                if (isSaving) {
                    CircularProgressIndicator(
                        color = PurpleMain,
                        modifier = Modifier.padding(vertical = 8.dp)
                    )
                } else {
                    Button(
                        onClick = {
                            userViewModel.updateUserProfile(
                                onSuccess = {
                                    Toast.makeText(context, "Đã lưu thay đổi!", Toast.LENGTH_SHORT)
                                        .show()
                                    navController.popBackStack()
                                }
                            )
                        },
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        Text("LƯU THAY ĐỔI")
                    }

                    Spacer(modifier = Modifier.height(24.dp))
                }
            }
        }
    }
}
