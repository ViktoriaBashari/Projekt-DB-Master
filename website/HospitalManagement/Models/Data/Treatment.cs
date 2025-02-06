using System.ComponentModel.DataAnnotations;

namespace HospitalManagement.Models.Data;

public class Treatment
{
    [Required(ErrorMessage = "Kodi eshte vlere e detyrueshme")]
    [StringLength(5, MinimumLength = 5, ErrorMessage = "Kodi duhet te jete 5-shifror")]
    public string Kodi { get; set; } = null!;

    [Required(ErrorMessage = "Emri eshte vlere e detyrueshme")]
    [StringLength(55, ErrorMessage = "{0} mund te jete maksimalisht {1} karaktere")]
    public string Emri { get; set; } = null!;

    [StringLength(300, ErrorMessage = "{0} mund te jete maksimalisht {1} karaktere")]
    public string? Pershkrimi { get; set; }

    [Required(ErrorMessage = "Cmimi eshte vlere e detyrueshme")]
    [Range(1, 999_999_999_999_999_999.99, ErrorMessage = "Vlera e {0} duhet te jete me e madhe se {1}")]
    public decimal Cmimi { get; set; }
}
