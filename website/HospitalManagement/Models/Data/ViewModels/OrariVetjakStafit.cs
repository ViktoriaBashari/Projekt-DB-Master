using System;
using System.Collections.Generic;

namespace HospitalManagement.Models.Data.ViewModels;

public partial class OrariVetjakStafit
{
    public int Id { get; set; }

    public string Emri { get; set; } = null!;

    public TimeOnly OraFilluese { get; set; }

    public TimeOnly OraPerfundimtare { get; set; }

    public string Emertimi { get; set; } = null!;
}
