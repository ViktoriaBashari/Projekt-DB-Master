using System;
using System.Collections.Generic;

namespace HospitalManagement.Models.Data.ViewModels;

public partial class InformacionPersonalStafi
{
    public int Id { get; set; }

    public string Emri { get; set; } = null!;

    public string Mbiemri { get; set; } = null!;

    public DateOnly Datelindja { get; set; }

    public string NrTelefoni { get; set; } = null!;

    public string Emertimi { get; set; } = null!;

    public int DepartamentId { get; set; }

    public byte RolId { get; set; }

    public DateOnly DataPunesimit { get; set; }

    public decimal Rroga { get; set; }

    public string? Specialiteti { get; set; }
}
