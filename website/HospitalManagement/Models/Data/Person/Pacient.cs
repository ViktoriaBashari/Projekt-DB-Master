using HospitalManagement.Models.Data.Anamneza;

namespace HospitalManagement.Models.Data.Person;

public partial class Pacient
{
    public int PersonId { get; set; }
    public virtual Person Person { get; set; } = null!;

    public string Nid { get; set; } = null!;
    public DateOnly DataRegjistrimit { get; set; }
    public string? GrupiGjakut { get; set; }
    public virtual Adrese? Adrese { get; set; }

    public virtual ICollection<Takim> Takims { get; set; } = new List<Takim>();

    public virtual ICollection<AnamnezaAbuzimit> AnamnezaAbuzimits { get; set; } = new List<AnamnezaAbuzimit>();
    public virtual ICollection<AnamnezaFamiljare> AnamnezaFamiljares { get; set; } = new List<AnamnezaFamiljare>();
    public virtual ICollection<AnamnezaFarmakologjike> AnamnezaFarmakologjikes { get; set; } = new List<AnamnezaFarmakologjike>();
    public virtual ICollection<AnamnezaFiziologjike> AnamnezaFiziologjikes { get; set; } = new List<AnamnezaFiziologjike>();
    public virtual ICollection<AnamnezaSemundje> AnamnezaSemundjes { get; set; } = new List<AnamnezaSemundje>();
}
