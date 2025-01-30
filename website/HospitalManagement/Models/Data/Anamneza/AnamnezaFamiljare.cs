using System;
using System.Collections.Generic;
using HospitalManagement.Models.Data.Person;

namespace HospitalManagement.Models.Data.Anamneza;

public partial class AnamnezaFamiljare
{
    public int Id { get; set; }

    public int PacientId { get; set; }

    public int StafiPergjegjesId { get; set; }

    public string LidhjaFamiljare { get; set; } = null!;

    public DateOnly Datelindja { get; set; }

    public string Semundja { get; set; } = null!;

    public byte? MoshaDiagnozes { get; set; }

    public string? ShkakuVdekjes { get; set; }

    public DateOnly? DataVdekjes { get; set; }

    public virtual Pacient Pacient { get; set; } = null!;

    public virtual Staf StafiPergjegjes { get; set; } = null!;
}
