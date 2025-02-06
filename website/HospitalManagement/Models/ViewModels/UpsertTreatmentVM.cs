using HospitalManagement.Models.Data;

namespace HospitalManagement.Models.ViewModels;

public class UpsertTreatmentVM
{
    public string? TreatmentToBeUpdatedCode { get; set; }
    public Treatment Treatment { get; set; } = null!;
}
