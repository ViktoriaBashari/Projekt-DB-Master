namespace HospitalManagement.Models.Data.Enums;

public partial class DiteJave
{
    public byte Id { get; set; }

    public string Emertimi { get; set; } = null!;

    public virtual ICollection<TurnOrari> TurnOrars { get; set; } = new List<TurnOrari>();
}
