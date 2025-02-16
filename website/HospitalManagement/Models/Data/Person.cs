namespace HospitalManagement.Models.Data;

public abstract class Person
{
    public int Id { get; set; }

    public string Emri { get; set; } = null!;
    public string Mbiemri { get; set; } = null!;

    public DateTime Datelindja { get; set; }
    public string NrTelefoni { get; set; } = null!;

    public byte GjiniaId { get; set; }
    public string GjiniaEmertimi { get; set; } = null!;
}
