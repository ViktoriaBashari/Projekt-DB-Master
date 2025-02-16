using System.ComponentModel.DataAnnotations;

namespace HospitalManagement.Models.ViewModels;

public class LoginVM
{
    [Required]
    public string Username { get; set; } = null!;

    [Required]
    public string Password { get; set; } = null!;
}