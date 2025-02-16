using HospitalManagement.Models.Data.Enums;

namespace HospitalManagement.Models.Data;

public class StaffSummary
{
    public int Id { get; set; }

    public string Emri { get; set; } = null!;
    public string Mbiemri { get; set; } = null!;

    public string PunonjesId { get; set; } = null!;
    public DateTime DataPunesimit { get; set; }

    public string Roli { get; set; } = null!;
    public string? Specialiteti { get; set; }

    public string DepartamentEmri { get; set; } = null!;

}

public class Staff : Person
{
    public string PunonjesId { get; set; } = null!;
    public DateTime DataPunesimit { get; set; }
    public decimal Rroga { get; set; }
    public string? Specialiteti { get; set; }

    public int RolId { get; set; }
    public string RolEmertimi { get; set; } = null!;

    public int DepartamentId { get; set; }
    public string DepartamentEmri { get; set; } = null!;
}