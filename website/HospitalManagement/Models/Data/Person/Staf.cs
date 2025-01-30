using HospitalManagement.Models.Data.Anamneza;
using HospitalManagement.Models.Data.Enums;

namespace HospitalManagement.Models.Data.Person;

public partial class Staf
{
    public int PersonId { get; set; }
    public virtual Person Person { get; set; } = null!;

    public string PunonjesId { get; set; } = null!;
    public DateOnly DataPunesimit { get; set; }
    public decimal Rroga { get; set; }
    public string? Specialiteti { get; set; }
    
    public byte RolId { get; set; }
    public virtual RolStafi Rol { get; set; } = null!;

    public int DepartamentId { get; set; }
    public virtual Departament Departament { get; set; } = null!;


    public virtual ICollection<AnamnezaAbuzimit> AnamnezaAbuzimits { get; set; } = new List<AnamnezaAbuzimit>();
    public virtual ICollection<AnamnezaFamiljare> AnamnezaFamiljares { get; set; } = new List<AnamnezaFamiljare>();
    public virtual ICollection<AnamnezaFarmakologjike> AnamnezaFarmakologjikes { get; set; } = new List<AnamnezaFarmakologjike>();
    public virtual ICollection<AnamnezaFiziologjike> AnamnezaFiziologjikes { get; set; } = new List<AnamnezaFiziologjike>();
    public virtual ICollection<AnamnezaSemundje> AnamnezaSemundjes { get; set; } = new List<AnamnezaSemundje>();


    //public virtual ICollection<Departament> Departaments { get; set; } = new List<Departament>();



    public virtual ICollection<Takim> TakimDoktors { get; set; } = new List<Takim>();
    public virtual ICollection<Takim> TakimInfermiers { get; set; } = new List<Takim>();
    public virtual ICollection<TurnOrari> TurnOrars { get; set; } = new List<TurnOrari>();
}
