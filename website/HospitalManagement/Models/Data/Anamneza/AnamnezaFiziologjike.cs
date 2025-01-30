using System;
using System.Collections.Generic;
using HospitalManagement.Models.Data.Person;

namespace HospitalManagement.Models.Data.Anamneza;

public partial class AnamnezaFiziologjike
{
    public int Id { get; set; }

    public int PacientId { get; set; }

    public int StafiPergjegjesId { get; set; }

    public DateTime DataKrijimit { get; set; }

    public string? SistemiFrymemarrjes { get; set; }

    public string? SistemiGjenitourinar { get; set; }

    public string? SistemiTretes { get; set; }

    public string? SistemiOkular { get; set; }

    public string? SistemiNeurologjik { get; set; }

    public string? SistemiOrl { get; set; }

    public string? SistemiPsikiatrik { get; set; }

    public string? SistemiKardiovaskular { get; set; }

    public virtual Pacient Pacient { get; set; } = null!;

    public virtual Staf StafiPergjegjes { get; set; } = null!;
}
