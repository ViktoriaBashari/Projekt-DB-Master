using HospitalManagement.Models.Data;

namespace HospitalManagement.Models.ViewModels;

public class StaffDetailsVM
{
    public Staff Staff { get; set; } = null!;
    public IList<FullSchedule> Schedule { get; set; } = [];
}
