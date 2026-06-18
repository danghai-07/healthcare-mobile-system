# CareWell — Mobile App (Flutter)

Ứng dụng di động **CareWell** kết nối với [Backend API](../backend_api/README.md) (.NET 9). Dành cho thành viên đặt lịch tư vấn, xét nghiệm, đọc bài viết sức khỏe và quản lý hồ sơ cá nhân.

## Công nghệ

| Thành phần | Thư viện |
|------------|----------|
| Framework | Flutter 3.12+ |
| State management | Provider |
| Navigation | GoRouter (shell + auth guard) |
| HTTP | Dio (interceptors, error mapping) |
| Local storage | SharedPreferences (JWT session) |
| UI | Material 3, Google Fonts (Inter) |

## Kiến trúc

Ứng dụng theo **MVP (Model–View–Presenter)** kết hợp clean architecture theo feature:

```
lib/
├── app/                    # Bootstrap, DI (AppDependencyScope)
├── core/                   # Theme, network, widgets, utils
├── routes/                 # GoRouter, auth guard
└── features/
    ├── auth/               # Đăng nhập, đăng ký, quên mật khẩu
    ├── consultant/         # Danh sách & chi tiết tư vấn viên
    ├── appointment/        # Lịch hẹn tư vấn, chọn slot
    ├── service/            # Xét nghiệm, đặt lịch, kết quả
    ├── blog/               # Bài viết sức khỏe
    ├── profile/            # Hồ sơ, đổi mật khẩu
    ├── home/               # Trang chủ (dashboard)
    └── shell/              # Bottom navigation (6 tab)
```

Mỗi feature gồm:

- `data/` — API service, repository impl, DTO, model
- `domain/` — entity, repository interface
- `presentation/` — presenter (`ChangeNotifier`), view, `*RouteScope`

## Yêu cầu

- [Flutter SDK](https://docs.flutter.dev/get-started/install) 3.12+
- Backend API đang chạy tại `http://localhost:5011`
- Chrome (web), Android emulator, hoặc thiết bị thật

## Cài đặt và chạy

### 1. Cài dependencies

```powershell
cd mobile_app
flutter pub get
```

### 2. Cấu hình API URL

Mặc định trong `lib/core/constants/app_constants.dart`:

```dart
static const String defaultBaseUrl = 'http://localhost:5011';
```

| Môi trường | Base URL |
|------------|----------|
| Flutter Web / Windows | `http://localhost:5011` |
| Android Emulator | `http://10.0.2.2:5011` |
| Thiết bị thật (cùng WiFi) | `http://<IP-máy-chạy-API>:5011` |

### 3. Chạy ứng dụng

```powershell
# Web (khuyến nghị khi dev)
flutter run -d chrome

# Android
flutter run -d android

# Liệt kê thiết bị
flutter devices
```

### 4. Tài khoản thử nghiệm

Sau khi chạy `HealthcareSystemDb.sql` (xem [backend_api/README.md](../backend_api/README.md)):

| Email | Mật khẩu | Vai trò |
|-------|----------|---------|
| `hieubmk2210@gmail.com` | `123456` | Thành viên (đăng nhập mobile) |
| `mb1@gmail.com` | `123456` | Thành viên |

## Điều hướng chính

Bottom navigation gồm **6 tab**:

| Tab | Route | Màn hình |
|-----|-------|----------|
| Trang chủ | `/home` | Dashboard, shortcut dịch vụ |
| Tư vấn | `/consultants` | Danh sách tư vấn viên, lọc chuyên khoa |
| Xét nghiệm | `/medical-tests` | Catalog dịch vụ xét nghiệm |
| Lịch hẹn | `/appointments` | Tư vấn + xét nghiệm (tab con, bộ lọc) |
| Bài viết | `/blogs` | Danh sách & chi tiết bài viết |
| Hồ sơ | `/profile` | Thông tin cá nhân, đổi mật khẩu |

## Tính năng đã hoàn thành

### Xác thực (`auth`)

- [x] Splash → redirect theo session
- [x] Đăng nhập (`POST /api/login`)
- [x] Đăng ký (`POST /api/register`)
- [x] Quên mật khẩu — OTP email + đặt lại mật khẩu (`/api/otp/sendOtpByEmail`, `/api/user/reset-password`)
- [x] Auth guard — bảo vệ route, redirect 401
- [x] Lưu JWT qua SharedPreferences

### Tư vấn (`consultant` + `appointment`)

- [x] Danh sách tư vấn viên, tìm kiếm, lọc chuyên khoa, lọc "có lịch trống"
- [x] Chi tiết tư vấn viên (avatar theo giới tính)
- [x] Chọn ngày / khung giờ / dịch vụ / triệu chứng
- [x] Đặt lịch tư vấn (`POST /api/Appointment/create`)
- [x] Màn hình xác nhận đặt lịch
- [x] Lịch sử lịch hẹn tư vấn — danh sách cơ bản, chi tiết đầy đủ
- [x] Bộ lọc: Tất cả / Sắp tới / Đã qua

### Xét nghiệm (`service`)

- [x] Danh sách dịch vụ xét nghiệm
- [x] Chi tiết dịch vụ
- [x] Đặt lịch xét nghiệm (ca làm, nhân viên khả dụng)
- [x] Lịch sử & chi tiết phiếu xét nghiệm
- [x] Hủy phiếu xét nghiệm
- [x] Tab "Xét nghiệm" trong màn Lịch hẹn

### Bài viết (`blog`)

- [x] Danh sách bài viết (`GET /api/blogs`)
- [x] Tìm kiếm & lọc theo chủ đề (client-side)
- [x] Chi tiết bài viết kèm hình ảnh (`GET /api/blogs/{id}`)

### Hồ sơ (`profile`)

- [x] Xem hồ sơ (`GET /api/user/get/{userId}`)
- [x] Cập nhật thông tin (`PUT /api/user/update/{userId}`)
- [x] Đổi mật khẩu (`POST /api/user/change-password/{userId}`)
- [x] Đăng xuất

### UI / UX

- [x] Design system thống nhất (màu xanh `#54AA7F`, logo, banner)
- [x] Responsive cơ bản (max-width form trên web/tablet)
- [x] Loading, error, empty state
- [x] Pull-to-refresh trên các danh sách

## API đã tích hợp

| Nhóm | Endpoint | Trạng thái mobile |
|------|----------|-------------------|
| Auth | login, register, OTP, reset-password | ✅ |
| Auth | google-login | ⚠️ Data layer có, chưa có UI |
| User | get, update, change-password | ✅ |
| Consultant | list, available, detail, slots | ✅ |
| Specialty | getAll | ✅ (filter) |
| Appointment | create, member, detail | ✅ |
| Appointment | update-status, update-meetlink | ❌ Chưa dùng |
| Service | list, detail | ✅ |
| TestRecord | book, member, detail, cancel, work-shifts, available-staff | ✅ |
| Blog | list, detail | ✅ |
| Blog | popular, topic, title | ❌ Chưa dùng (có thể thêm tab "Phổ biến") |

## Hướng phát triển thêm (dựa trên API sẵn có)

Các module backend **đã có API** nhưng mobile **chưa triển khai** — có thể mở rộng:

### Ưu tiên cao (giá trị người dùng lớn)

| Tính năng | API liên quan | Gợi ý triển khai |
|-----------|---------------|------------------|
| **Đăng nhập Google** | `POST /api/google-login` | Nút Google trên màn Login, dùng `google_sign_in` |
| **Thông báo in-app** | `GET /api/Noti/getNoti/{userId}`, `PUT markAsRead` | Tab hoặc icon chuông trên AppBar, badge số chưa đọc |
| **Đánh giá dịch vụ** | `POST /api/feedback`, `GET feedback/appointment/{id}` | Form đánh giá sau khi hoàn thành tư vấn / xét nghiệm |
| **Hỏi đáp cộng đồng** | `/api/Question/*`, `/api/QuestionThreadItem/*` | Tab mới: đặt câu hỏi, xem thread, like câu trả lời |
| **Theo dõi chu kỳ sinh sản** | `/api/ReproductiveCycle/*` | Màn hình calendar, nhắc nhở (backend đã có job email) |

### Ưu tiên trung bình

| Tính năng | API liên quan | Gợi ý triển khai |
|-----------|---------------|------------------|
| **Bài viết phổ biến** | `GET /api/blogs/popular` | Section trên Home hoặc tab "Nổi bật" |
| **Lọc blog theo topic API** | `GET /api/blogs/topic/{topic}` | Thay filter client-side bằng gọi API |
| **Thanh toán PayPal** | `POST /api/Payment/create-paypal-url` | Thanh toán sau đặt xét nghiệm / tư vấn trả phí |
| **Tra cứu hóa đơn** | `POST /api/Invoice/search-by-date` | Màn "Lịch sử thanh toán" trong Hồ sơ |
| **Hủy / đổi trạng thái lịch hẹn** | `PATCH /api/Appointment/update-status/{id}` | Nút hủy lịch tư vấn (member) |
| **Upload avatar** | `PUT /api/user/update` (field `avatar`) | Image picker + upload URL/base64 |

### Cải thiện kỹ thuật

| Hạng mục | Mô tả |
|----------|--------|
| Cấu hình môi trường | `--dart-define=API_URL=...` thay vì hardcode localhost |
| Cache hình ảnh | `cached_network_image` cho avatar blog/consultant |
| Debounce tìm kiếm | Giảm rebuild khi gõ trên blog/consultant list |
| Unit / widget tests | Auth, booking, profile flows |
| Push notification | FCM + backend `Noti/createNoti` |
| Offline mode | Hive/SQLite cache danh sách đã xem |

## Design system

Widgets dùng chung trong `lib/core/widgets/`:

- `AppScaffold`, `AppCard`, `AppTextField`
- `PrimaryButton`, `SecondaryButton`
- `SectionHeader`, `AppSearchBar`, `FilterChipBar`
- `LoadingWidget`, `AppErrorWidget`, `EmptyStateWidget`
- `DoctorAvatar`, `BrandLogo`, `HomeBanner`

Theme: `lib/core/theme/app_colors.dart` — primary `#54AA7F`.

## Assets

```
assets/images/
├── logo.png
├── banner.png
├── doctor_female.png
└── doctor_male.png
```

## Phân tích code

```powershell
flutter analyze
```

## Xử lý lỗi thường gặp

| Lỗi | Cách xử lý |
|-----|------------|
| `Connection refused` / timeout | Kiểm tra backend đang chạy; đúng base URL theo platform |
| 401 sau đăng nhập | Xóa app data / SharedPreferences; đăng nhập lại |
| Danh sách tư vấn viên trống slot | Đã chạy `HealthcareSystemDb.sql` sau EF? (file đã gồm `WeeklySchedules`) |
| OTP / email không gửi được | Cấu hình `EmailSettings` trên backend |
| CORS trên web | Backend Development policy đã cho phép localhost |

## Liên kết

- Backend API: [`../backend_api/README.md`](../backend_api/README.md)
- README tổng quan: [`../README.md`](../README.md)
