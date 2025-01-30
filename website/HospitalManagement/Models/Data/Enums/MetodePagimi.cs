namespace HospitalManagement.Models.Data.Enums;

public partial class MetodePagimi
{
    public byte Id { get; set; }

    public string Emertimi { get; set; } = null!;

    public virtual ICollection<Fature> Fatures { get; set; } = new List<Fature>();
}
