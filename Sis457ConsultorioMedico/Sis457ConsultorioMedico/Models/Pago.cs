using System;
using System.Collections.Generic;

namespace Sis457ConsultorioMedico.Models;

public partial class Pago
{
    public int Id { get; set; }

    public int IdCita { get; set; }

    public int IdConcepto { get; set; }

    public DateOnly Fecha { get; set; }

    public string UsuarioRegistro { get; set; } = null!;

    public DateTime FechaRegistro { get; set; }

    public short Estado { get; set; }

    public virtual Cita IdCitaNavigation { get; set; } = null!;

    public virtual Concepto IdConceptoNavigation { get; set; } = null!;
}
