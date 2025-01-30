using System;
using System.Collections.Generic;
using HospitalManagement.Models.Data.Person;

namespace HospitalManagement.Models.Data.Anamneza;

public partial class AnamnezaFarmakologjike
{
    public int Id { get; set; }

    public int PacientId { get; set; }

    public int StafiPergjegjesId { get; set; }

    public string Ilaci { get; set; } = null!;

    public string Doza { get; set; } = null!;

    public string Arsyeja { get; set; } = null!;

    public DateOnly DataFillimit { get; set; }

    public DateOnly? DataPerfundimit { get; set; }

    public bool MarrePaRecete { get; set; }

    public virtual Pacient Pacient { get; set; } = null!;

    public virtual Staf StafiPergjegjes { get; set; } = null!;
}
