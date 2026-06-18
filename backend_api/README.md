# Healthcare System — Backend API

ASP.NET Core Web API phục vụ hệ thống chăm sóc sức khỏe giới tính (CareWell). Cung cấp REST API cho ứng dụng mobile Flutter và các client khác.

## Công nghệ

| Thành phần | Phiên bản / Công nghệ |
|------------|------------------------|
| Runtime | .NET 9 |
| ORM | Entity Framework Core |
| Database | SQL Server / LocalDB |
| Validation | FluentValidation |
| Auth | JWT Bearer, Google OAuth, OTP email |
| Thanh toán | PayPal Sandbox |
| Email | MailKit (SMTP) |
| Tài liệu API | Swagger / OpenAPI |

## Cấu trúc solution

```
backend_api/
├── HealthcareSystem.sln
├── backend/
│   ├── HealthcareSystem.API/          # Controllers, Program.cs, Swagger
│   ├── HealthcareSystem.Application/  # DTOs, Interfaces, Validators
│   ├── HealthcareSystem.Domain/       # Entities
│   └── HealthcareSystem.Infrastructure/ # DbContext, Services, Migrations
└── docs/
    ├── HealthcareSystemDb.sql         # Seed dữ liệu mẫu (chạy sau EF migration)
    └── swagger.json                   # OpenAPI spec
```

## Yêu cầu hệ thống

- [.NET 9 SDK](https://dotnet.microsoft.com/download/dotnet/9.0)
- SQL Server hoặc SQL Server LocalDB
- [dotnet-ef](https://learn.microsoft.com/ef/core/cli/dotnet) (tùy chọn, dùng migration)

```powershell
dotnet tool install --global dotnet-ef
```

## Cài đặt và chạy

### 1. Cấu hình môi trường

Tạo file `backend/HealthcareSystem.API/appsettings.Development.json` (không commit lên Git) với các giá trị:

| Key | Mô tả |
|-----|--------|
| `ConnectionStrings:DefaultConnection` | Chuỗi kết nối SQL Server |
| `Jwt:Secret` | Secret ký JWT |
| `Authentication:Google:ClientId` / `ClientSecret` | Google Sign-In |
| `EmailSettings:*` | SMTP gửi OTP, xác nhận lịch hẹn |
| `PayPal:*` | PayPal Sandbox (thanh toán) |

**Ví dụ LocalDB:**

```text
Server=(localdb)\MSSQLLocalDB;Database=HealthcareSystemDb;Trusted_Connection=True;TrustServerCertificate=True;
```

**Ví dụ SQL Server Express:**

```text
Server=localhost;Database=HealthcareSystemDb;User Id=SA;Password=YOUR_PASSWORD;TrustServerCertificate=True;
```

### 2. Tạo database

Quy trình **2 bước** — EF tạo schema, một file SQL duy nhất nạp dữ liệu mẫu.

#### Bước 1 — Schema (EF Core Migration)

Lệnh này tạo database `HealthcareSystemDb` (nếu chưa có) và toàn bộ bảng. **Không có dữ liệu mẫu.**

```powershell
cd backend/HealthcareSystem.Infrastructure
dotnet ef database update --startup-project ..\HealthcareSystem.API
```

Cần cài công cụ EF (một lần):

```powershell
dotnet tool install --global dotnet-ef
```

#### Bước 2 — Dữ liệu mẫu (một file SQL)

Chạy **duy nhất** file:

`docs/HealthcareSystemDb.sql`

File này chỉ `INSERT` dữ liệu (user, dịch vụ, blog, lịch hẹn, `WeeklySchedules`, …). Đã gồm lịch tuần cho tư vấn viên — **không cần** chạy thêm file SQL khác.

**SQL Server Management Studio:** Mở file → Execute.

**sqlcmd (LocalDB):**

```powershell
sqlcmd -S "(localdb)\MSSQLLocalDB" -d HealthcareSystemDb -i "docs\HealthcareSystemDb.sql"
```

**sqlcmd (SQL Server Express):**

```powershell
sqlcmd -S localhost -d HealthcareSystemDb -U SA -P YOUR_PASSWORD -i "docs\HealthcareSystemDb.sql"
```

> Chỉ chạy seed **một lần** sau bước 1. Chạy lại trên DB đã có dữ liệu sẽ lỗi trùng khóa. Muốn nạp lại: xóa database → bước 1 → bước 2.

#### Tài khoản thử (sau khi seed)

| Email | Vai trò | Ghi chú |
|-------|---------|---------|
| `hieubmk2210@gmail.com` | Member (MB) | Dùng test mobile app |
| `mb1@gmail.com` | Member (MB) | Thành viên mẫu |
| `cs1@gmail.com` | Consultant (CS) | Tư vấn viên |
| `admin@gmail.com` | Admin (AD) | Quản trị |

Mật khẩu mẫu trong DB thường là `123456` (BCrypt hash trong script).

### 3. Chạy API

```powershell
cd backend/HealthcareSystem.API
dotnet restore
dotnet run
```

Hoặc mở `HealthcareSystem.sln` trong Visual Studio và nhấn **F5**.

### 4. URL và Swagger

| Môi trường | URL |
|------------|-----|
| HTTP | http://localhost:5011 |
| HTTPS | https://localhost:7165 |
| Swagger UI | https://localhost:7165/swagger hoặc http://localhost:5011/swagger |

Tin cậy chứng chỉ HTTPS (lần đầu):

```powershell
dotnet dev-certs https --trust
```

## CORS

Trong môi trường Development, API cho phép mọi origin từ `localhost` / `127.0.0.1` (phục vụ Flutter Web chạy trên port ngẫu nhiên).

## Danh sách API theo module

### Xác thực & người dùng

| Method | Endpoint | Mô tả |
|--------|----------|--------|
| POST | `/api/login` | Đăng nhập, trả JWT |
| POST | `/api/register` | Đăng ký tài khoản |
| POST | `/api/google-login` | Đăng nhập Google |
| POST | `/api/otp/sendOtpByUserId/{userId}` | Gửi OTP theo userId |
| POST | `/api/otp/sendOtpByEmail` | Gửi OTP theo email |
| POST | `/api/otp/verify` | Xác thực OTP |
| GET | `/api/user/get/{userId}` | Lấy thông tin hồ sơ |
| PUT | `/api/user/update/{userId}` | Cập nhật hồ sơ |
| POST | `/api/user/change-password/{userId}` | Đổi mật khẩu (cần mật khẩu cũ) |
| POST | `/api/user/reset-password` | Đặt lại mật khẩu qua OTP email |

### Tư vấn viên & chuyên khoa

| Method | Endpoint | Mô tả |
|--------|----------|--------|
| GET | `/api/consultants` | Danh sách tư vấn viên |
| GET | `/api/consultants/available` | Tư vấn viên rảnh theo ngày |
| GET | `/api/consultants/{id}` | Chi tiết tư vấn viên |
| GET | `/api/consultants/{id}/available-slots` | Khung giờ trống |
| GET | `/api/specialty/getAll` | Danh sách chuyên khoa |
| GET | `/api/schedule/week/{userId}` | Lịch tuần |

### Lịch hẹn tư vấn

| Method | Endpoint | Mô tả |
|--------|----------|--------|
| POST | `/api/Appointment/create` | Tạo lịch hẹn |
| GET | `/api/Appointment/list` | Danh sách (admin) |
| GET | `/api/Appointment/detail/{id}` | Chi tiết lịch hẹn |
| GET | `/api/Appointment/member/{memberId}` | Lịch hẹn theo thành viên |
| GET | `/api/Appointment/consultant/{consultantId}` | Lịch hẹn theo tư vấn viên |
| PATCH | `/api/Appointment/update-status/{id}` | Cập nhật trạng thái |
| PATCH | `/api/Appointment/update-meetlink/{id}` | Cập nhật link họp |

### Dịch vụ xét nghiệm

| Method | Endpoint | Mô tả |
|--------|----------|--------|
| GET | `/api/Service` | Danh sách dịch vụ |
| GET | `/api/Service/{serviceId}` | Chi tiết dịch vụ |
| POST | `/api/TestServiceRecord/book` | Đặt lịch xét nghiệm |
| GET | `/api/TestServiceRecord/member/{memberId}` | Lịch sử xét nghiệm |
| GET | `/api/TestServiceRecord/{recordId}/{memberId}` | Chi tiết phiếu xét nghiệm |
| PUT | `/api/TestServiceRecord/cancel` | Hủy phiếu |
| GET | `/api/TestServiceRecord/work-shifts` | Ca làm việc |
| GET | `/api/TestServiceRecord/available-staff` | Nhân viên khả dụng |

### Bài viết sức khỏe

| Method | Endpoint | Mô tả |
|--------|----------|--------|
| GET | `/api/blogs` | Tất cả bài viết |
| GET | `/api/blogs/{id}` | Chi tiết bài viết |
| GET | `/api/blogs/popular` | Bài viết phổ biến |
| GET | `/api/blogs/topic/{topic}` | Lọc theo chủ đề |
| GET | `/api/blogs/title/{title}` | Tìm theo tiêu đề |

### Các module khác (chưa tích hợp mobile)

| Module | Endpoint gốc | Mô tả |
|--------|--------------|--------|
| Hỏi đáp | `/api/Question/*` | Câu hỏi cộng đồng, thread trả lời |
| Chu kỳ sinh sản | `/api/ReproductiveCycle/*` | Theo dõi chu kỳ, nhắc nhở |
| Phản hồi | `/api/feedback/*` | Đánh giá sau tư vấn / xét nghiệm |
| Thông báo | `/api/Noti/*` | Push notification trong app |
| Thanh toán | `/api/Payment/*` | PayPal checkout |
| Hóa đơn | `/api/Invoice/*` | Tra cứu hóa đơn |
| Dashboard | `/api/Dashboard/*` | Thống kê (admin) |
| Quản lý user | `/api/ManageUser/*` | CRUD user (admin/staff) |

## Background jobs

- `ReproductiveReminderJob` — gửi nhắc nhở chu kỳ sinh sản qua email (chạy nền).

## Xử lý lỗi thường gặp

| Lỗi | Cách xử lý |
|-----|------------|
| `Unable to retrieve project metadata` | Chạy `dotnet ef` từ `HealthcareSystem.Infrastructure` với `--startup-project ..\HealthcareSystem.API` |
| `ConnectionString property has not been initialized` | Kiểm tra `appsettings.Development.json` |
| Không kết nối SQL Server | Xác nhận service SQL đang chạy, đúng loại LocalDB vs Express |
| Gửi email / OTP thất bại | Kiểm tra `EmailSettings` trong cấu hình |
| Lỗi 500 khi tạo lịch hẹn | API vẫn lưu DB; email xác nhận có thể fail nếu SMTP chưa cấu hình |

## Liên kết

- Mobile app: [`../mobile_app/README.md`](../mobile_app/README.md)
- README tổng quan: [`../README.md`](../README.md)
