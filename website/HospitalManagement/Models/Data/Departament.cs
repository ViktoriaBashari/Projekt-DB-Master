using HospitalManagement.Models.Data.Person;

namespace HospitalManagement;

public partial class Departament
{
    public int Id { get; set; }

    public int DrejtuesId { get; set; }

    public string Emri { get; set; } = null!;

    public virtual Staf? Drejtues { get; set; }
}