using HospitalManagement.Models.Data.Person;

namespace HospitalManagement.Models.Data.Enums;

public partial class RolStafi
{
    public byte Id { get; set; }

    public string Emertimi { get; set; } = null!;

    public virtual ICollection<Staf> Stafs { get; set; } = new List<Staf>();
}
