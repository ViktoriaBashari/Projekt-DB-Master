using HospitalManagement.Models.Data.Person;

namespace HospitalManagement.Models.Data.Anamneza;

public partial class AnamnezaAbuzimit
{
    public int Id { get; set; }

    public int PacientId { get; set; }

    public int StafiPergjegjesId { get; set; }

    public string Substanca { get; set; } = null!;

    public string? Pershkrimi { get; set; }

    public DateOnly DataFillimit { get; set; }

    public DateOnly? DataPerfundimit { get; set; }

    public virtual Pacient Pacient { get; set; } = null!;

    public virtual Staf StafiPergjegjes { get; set; } = null!;
}
