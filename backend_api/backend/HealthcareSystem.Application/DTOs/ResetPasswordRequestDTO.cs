
namespace Application.DTOs
{
    public class ResetPasswordRequestDTO
    {
        public string? Email { get; set; }
        public string? OtpCode { get; set; }
        public string? NewPassword { get; set; }
    }
}
