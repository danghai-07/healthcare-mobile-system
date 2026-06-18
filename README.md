# Healthcare Mobile System (CareWell)

Hệ thống chăm sóc sức khỏe giới tính gồm **Backend API** (.NET 9) và **Mobile App** (Flutter).

```
healthcare-mobile-system/
├── backend_api/     # ASP.NET Core REST API + SQL Server
├── mobile_app/      # Flutter app (CareWell)
└── README.md        # File này
```

## Tài liệu chi tiết

| Thành phần | README |
|------------|--------|
| Backend API | [backend_api/README.md](backend_api/README.md) |
| Mobile App | [mobile_app/README.md](mobile_app/README.md) |

## Yêu cầu chung

- [.NET 9 SDK](https://dotnet.microsoft.com/download/dotnet/9.0)
- SQL Server hoặc LocalDB
- [Flutter SDK](https://docs.flutter.dev/get-started/install) 3.12+

## Quick start

### 1. Backend

**Bước A — Cấu hình:** tạo `backend_api/backend/HealthcareSystem.API/appsettings.Development.json` với `ConnectionStrings:DefaultConnection` (xem [backend_api/README.md](backend_api/README.md)).

**Bước B — Tạo schema (bảng, không có dữ liệu):**

```powershell
cd backend_api/backend/HealthcareSystem.Infrastructure
dotnet ef database update --startup-project ..\HealthcareSystem.API
```

**Bước C — Nạp dữ liệu mẫu (chỉ 1 file SQL):**

Chạy `backend_api/docs/HealthcareSystemDb.sql` bằng SSMS, Azure Data Studio, hoặc:

```powershell
sqlcmd -S "(localdb)\MSSQLLocalDB" -d HealthcareSystemDb -i "backend_api\docs\HealthcareSystemDb.sql"
```

**Bước D — Chạy API:**

```powershell
cd ..\HealthcareSystem.API
dotnet run
```

API: **http://localhost:5011** · Swagger: **http://localhost:5011/swagger**

### 2. Mobile

```powershell
cd mobile_app
flutter pub get
flutter run -d chrome
```

> Android emulator dùng `http://10.0.2.2:5011` — sửa `defaultBaseUrl` trong `mobile_app/lib/core/constants/app_constants.dart`.

## Tính năng hệ thống (tóm tắt)

| Module | Backend | Mobile |
|--------|---------|--------|
| Đăng nhập / đăng ký / OTP | ✅ | ✅ |
| Quên mật khẩu | ✅ | ✅ |
| Tư vấn viên & đặt lịch | ✅ | ✅ |
| Xét nghiệm & kết quả | ✅ | ✅ |
| Bài viết sức khỏe | ✅ | ✅ |
| Hồ sơ & đổi mật khẩu | ✅ | ✅ |
| Hỏi đáp cộng đồng | ✅ | 🔜 |
| Chu kỳ sinh sản | ✅ | 🔜 |
| Thông báo | ✅ | 🔜 |
| Thanh toán PayPal | ✅ | 🔜 |
| Google Sign-In | ✅ | 🔜 (API sẵn, chưa UI) |

Chi tiết tính năng mobile và roadmap: [mobile_app/README.md](mobile_app/README.md).

## Cấu hình secrets

File `backend_api/backend/HealthcareSystem.API/appsettings.Development.json` **không được commit**. Cần điền:

- `ConnectionStrings:DefaultConnection`
- `Jwt:Secret`
- `EmailSettings` (OTP, email xác nhận)
- `Authentication:Google` (tùy chọn)
- `PayPal` (tùy chọn)

## Xử lý lỗi thường gặp

| Lỗi | Cách xử lý |
|-----|------------|
| Mobile không gọi được API | Backend đang chạy? Đúng base URL theo platform? |
| `ConnectionString not initialized` | Tạo `appsettings.Development.json` |
| EF migration lỗi | Chạy từ `HealthcareSystem.Infrastructure` với `--startup-project` |
| HTTPS certificate | `dotnet dev-certs https --trust` |
