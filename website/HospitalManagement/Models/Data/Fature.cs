using System;
using System.Collections.Generic;
using HospitalManagement.Models.Data.Enums;

namespace HospitalManagement;

public partial class Fature
{
    public int TakimId { get; set; }

    public decimal Cmimi { get; set; }

    public DateTime? DataPagimit { get; set; }

    public byte? MetodaPagimitId { get; set; }

    public virtual MetodePagimi? MetodaPagimit { get; set; }

    public virtual Takim Takim { get; set; } = null!;
}
