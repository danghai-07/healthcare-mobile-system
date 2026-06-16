# healthcare-mobile-system

Hệ thống chăm sóc sức khỏe gồm **Backend API** (.NET 9) và **Mobile App** (Flutter).

## Yêu cầu

- [.NET 9 SDK](https://dotnet.microsoft.com/download/dotnet/9.0)
- SQL Server hoặc SQL Server LocalDB
- [dotnet-ef](https://learn.microsoft.com/en-us/ef/core/cli/dotnet) (công cụ EF Core CLI)

```powershell
dotnet tool install --global dotnet-ef
```

## Chạy Backend

### 1. Cấu hình môi trường

Secrets được lưu local tại:

`backend_api/backend/HealthcareSystem.API/appsettings.Development.json`

File này **không được commit** lên Git. Sao chép và điền các giá trị cần thiết:

- `ConnectionStrings:DefaultConnection` — chuỗi kết nối SQL Server
- `Jwt:Secret`
- `Authentication:Google` — nếu dùng Google Login
- `PayPal`, `EmailSettings` — nếu dùng thanh toán / gửi email

**Ví dụ connection string (LocalDB):**

```text
Server=(localdb)\MSSQLLocalDB;Database=HealthcareSystemDb;Trusted_Connection=True;TrustServerCertificate=True;
```

**Ví dụ connection string (SQL Server Express):**

```text
Server=localhost;Database=HealthcareSystemDb;User Id=SA;Password=YOUR_PASSWORD;TrustServerCertificate=True;
```

### 2. Tạo database

Chạy migration từ thư mục Infrastructure:

```powershell
cd backend_api/backend/HealthcareSystem.Infrastructure
dotnet ef database update --startup-project ..\HealthcareSystem.API
```

Hoặc import dữ liệu mẫu bằng script SQL:

`backend_api/docs/HealthcareSystemDb.sql`

### 3. Chạy API

```powershell
cd backend_api/backend/HealthcareSystem.API
dotnet restore
dotnet run
```

Hoặc mở solution `backend_api/HealthcareSystem.sln` trong Visual Studio và nhấn **F5**.

### 4. Kiểm tra

| Môi trường | URL |
| HTTP       | http://localhost:5011 |
| HTTPS      | https://localhost:7165 |
| Swagger UI | https://localhost:7165/swagger |

Nếu trình duyệt báo lỗi chứng chỉ HTTPS, chạy:

```powershell
dotnet dev-certs https --trust
```

## Xử lý lỗi thường gặp

| Lỗi | Cách xử lý |
|---|---|
| `Unable to retrieve project metadata` | Chạy `dotnet ef` từ đúng thư mục `HealthcareSystem.Infrastructure` và dùng `--startup-project ..\HealthcareSystem.API` |
| `ConnectionString property has not been initialized` | Điền connection string trong `appsettings.Development.json` |
| Không kết nối được SQL Server | Kiểm tra SQL Server đang chạy và connection string đúng loại (LocalDB vs Express) |
