using System;
using System.Collections.Generic;
using HospitalManagement.Models.Data.Person;

namespace HospitalManagement.Models.Data.Anamneza;

public partial class AnamnezaSemundje
{
    public int Id { get; set; }

    public int PacientId { get; set; }

    public int StafiPergjegjesId { get; set; }

    public string Semundja { get; set; } = null!;

    public DateOnly DataDiagnozes { get; set; }

    public bool EshteKronike { get; set; }

    public virtual Pacient Pacient { get; set; } = null!;

    public virtual Staf StafiPergjegjes { get; set; } = null!;
}
