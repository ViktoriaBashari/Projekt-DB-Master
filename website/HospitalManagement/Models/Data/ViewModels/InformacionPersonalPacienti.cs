using System;
using System.Collections.Generic;

namespace HospitalManagement.Models.Data.ViewModels;

public partial class InformacionPersonalPacienti
{
    public int Id { get; set; }

    public string Emri { get; set; } = null!;

    public string Mbiemri { get; set; } = null!;

    public DateOnly Datelindja { get; set; }

    public string NrTelefoni { get; set; } = null!;

    public string Emertimi { get; set; } = null!;

    public string Nid { get; set; } = null!;

    public DateOnly DataRegjistrimit { get; set; }

    public string? GrupiGjakut { get; set; }

    public string Rruga { get; set; } = null!;

    public string Qyteti { get; set; } = null!;

    public string? InformacionShtese { get; set; }
}
