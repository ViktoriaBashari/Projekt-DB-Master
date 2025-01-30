using System;
using System.Collections.Generic;

namespace HospitalManagement.Models.Data.ViewModels;

public partial class InformacionPublikStafi
{
    public int PersonId { get; set; }

    public string Emri { get; set; } = null!;

    public string Mbiemri { get; set; } = null!;

    public byte RolId { get; set; }

    public string? Specialiteti { get; set; }

    public int DepartamentId { get; set; }
}
