namespace HospitalManagement.Models.Data.Person;

public partial class Adrese
{
    public int PacientId { get; set; }

    public string Rruga { get; set; } = null!;

    public string Qyteti { get; set; } = null!;

    public string? InformacionShtese { get; set; }

    public virtual Pacient Pacient { get; set; } = null!;
}
