namespace HospitalManagement.Models.Data;

public class Appointment
{
    public int Id { get; set; }
    public DateTime DataKrijimit { get; set; }
    public DateTime DataTakimit { get; set; }
    public string SherbimEmri { get; set; } = null!;

    public string? ShqetesimiKryesor { get; set; }
    public string? KohezgjatjaShqetesimit { get; set; }
    public string? SimptomaTeLidhura { get; set; }
    public string? Konkluzioni { get; set; }

    public string DoktorEmri { get; set; } = null!;
    public string DoktorMbiemri { get; set; } = null!;

    public string? InfermierEmri { get; set; }
    public string? InfermierMbiemri { get; set; }

    public int PacientId { get; set; }
    public string PacientEmri { get; set; } = null!;
    public string PacientMbiemri { get; set; } = null!;
}

public class AppointmentSummary
{
    public int Id { get; set; }
    public DateTime DataTakimit { get; set; }
    public string SherbimEmri { get; set; } = null!;
}
