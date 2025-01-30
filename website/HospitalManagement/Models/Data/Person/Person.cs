using HospitalManagement.Models.Data.Enums;

namespace HospitalManagement.Models.Data.Person;

public partial class Person
{
    public int Id { get; set; }

    public string Emri { get; set; } = null!;

    public string Mbiemri { get; set; } = null!;

    public DateOnly Datelindja { get; set; }

    public string NrTelefoni { get; set; } = null!;

    public byte GjiniaId { get; set; }

    public virtual Gjinia Gjinia { get; set; } = null!;

    public virtual Pacient? Pacient { get; set; }

    public virtual Staf? Staf { get; set; }
}
