using System;
using System.Collections.Generic;

namespace Sis457ConsultorioMedico.Models;

public partial class Cita
{
    public int Id { get; set; }

    public int IdDoctor { get; set; }

    public int IdPaciente { get; set; }

    public int IdEspecialidad { get; set; }

    public DateOnly Fecha { get; set; }

    public TimeOnly Hora { get; set; }

    public string UsuarioRegistro { get; set; } = null!;

    public DateTime FechaRegistro { get; set; }

    public short Estado { get; set; }

    public virtual Doctor IdDoctorNavigation { get; set; } = null!;

    public virtual Especialidad IdEspecialidadNavigation { get; set; } = null!;

    public virtual Paciente IdPacienteNavigation { get; set; } = null!;

    public virtual ICollection<Pago> Pagos { get; set; } = new List<Pago>();
}
