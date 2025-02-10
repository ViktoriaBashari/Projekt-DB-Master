namespace HospitalManagement.Models.Data;

public class FullSchedule
{
    public string EmriTurnit { get; set; } = null!;
    
    public TimeSpan OraFilluese { get; set; }
    public TimeSpan OraPerfundimtare { get; set; }
    
    public int DitaId { get; set; }
}
