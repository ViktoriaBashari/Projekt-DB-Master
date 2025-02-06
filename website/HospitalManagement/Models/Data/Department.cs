using System.ComponentModel.DataAnnotations;

namespace HospitalManagement.Models.Data;

public class Department
{
    public int Id { get; set; }

    [Required(ErrorMessage = "Emri eshte vlere e detyrueshme")]
    [StringLength(50, ErrorMessage = "{0} mund te jete maksimalisht {1} karaktere")]
    public string Emri { get; set; } = null!;

    public int? DrejtuesId { get; set; }
    public string? DrejtuesEmri { get; set; }
    public string? DrejtuesMbiemri { get; set; }
}
