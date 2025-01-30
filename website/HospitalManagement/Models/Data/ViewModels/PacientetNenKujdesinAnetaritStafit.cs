namespace HospitalManagement.Models.Data.ViewModels;

public partial class PacientetNenKujdesinAnetaritStafit
{
    public int Id { get; set; }

    public string Emri { get; set; } = null!;

    public string Mbiemri { get; set; } = null!;

    public DateOnly Datelindja { get; set; }

    public byte GjiniaId { get; set; }

    public string? GrupiGjakut { get; set; }
}
