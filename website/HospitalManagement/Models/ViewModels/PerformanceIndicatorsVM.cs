using HospitalManagement.Models.Data.Person;

namespace HospitalManagement.Models.ViewModels;

public class PerformanceIndicatorsVM
{
    public decimal StaffPatientRaport { get; set; }
    public decimal PatientMeetingWaitingTimeNorm { get; set; }
    public decimal CancelledMeetingPercentage { get; set; }



    public IEnumerable<Staf> MostUsedStaff { get; set; } = null!;
    public IEnumerable<Pacient> MostFrequentPatient { get; set; } = null!;

}
