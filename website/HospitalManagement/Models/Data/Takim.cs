using System;
using System.Collections.Generic;
using HospitalManagement.Models.Data.Person;

namespace HospitalManagement;

public partial class Takim
{
    public int Id { get; set; }

    public DateTime DataKrijimit { get; set; }

    public DateTime DataTakimit { get; set; }

    public int DoktorId { get; set; }

    public int? InfermierId { get; set; }

    public int PacientId { get; set; }

    public string SherbimId { get; set; } = null!;

    public string? ShqetesimiKryesor { get; set; }

    public string? KohezgjatjaShqetesimit { get; set; }

    public string? SimptomaTeLidhura { get; set; }

    public string? Konkluzioni { get; set; }

    public bool EshteAnulluar { get; set; }

    public virtual Staf Doktor { get; set; } = null!;

    public virtual Fature? Fature { get; set; }

    public virtual Staf? Infermier { get; set; }

    public virtual Pacient Pacient { get; set; } = null!;

    public virtual Sherbim Sherbim { get; set; } = null!;
}
