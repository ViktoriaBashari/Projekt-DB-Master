using System;
using System.Collections.Generic;

namespace HospitalManagement;

public partial class Sherbim
{
    public string Kodi { get; set; } = null!;

    public string Emri { get; set; } = null!;

    public string? Pershkrimi { get; set; }

    public decimal Cmimi { get; set; }

    public virtual ICollection<Takim> Takims { get; set; } = new List<Takim>();
}
