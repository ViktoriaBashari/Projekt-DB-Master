using HospitalManagement.Models.Data.Enums;
using HospitalManagement.Models.Data.Person;

namespace HospitalManagement.Models.Data;

public partial class TurnOrari
{
    public int Id { get; set; }

    public string Emri { get; set; } = null!;

    public TimeOnly OraFilluese { get; set; }

    public TimeOnly OraPerfundimtare { get; set; }

    public virtual ICollection<DiteJave> DiteJaves { get; set; } = new List<DiteJave>();

    public virtual ICollection<Staf> Stafs { get; set; } = new List<Staf>();
}
