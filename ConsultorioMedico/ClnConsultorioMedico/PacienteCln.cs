using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CadConsultorioMedico;

namespace ClnConsultorioMedico
{
    public class PacienteCln
    {
        public static int insertar(Paciente paciente)
        {
            using (var context = new LabConsultorioMedicoEntities())
            {
                context.Paciente.Add(paciente);
                context.SaveChanges();
                return paciente.id;
            }
        }

        public static int actualizar(Paciente paciente)
        {
            using (var context = new LabConsultorioMedicoEntities())
            {
                var existente = context.Paciente.Find(paciente.id);
                existente.nombres = paciente.nombres;
                existente.cedulaIdentidad = paciente.cedulaIdentidad;
                existente.primerApellido = paciente.primerApellido;
                existente.segundoApellido = paciente.segundoApellido;
                existente.fechaNacimiento = paciente.fechaNacimiento;
                existente.direccion = paciente.direccion;
                existente.celular = paciente.celular;
                existente.usuarioRegistro = paciente.usuarioRegistro;
                existente.fechaRegistro = paciente.fechaRegistro;
                existente.estado = paciente.estado;
                return context.SaveChanges();
            }
        }

        public static int eliminar(int id, string usuarioRegistro)
        {
            using (var context = new LabConsultorioMedicoEntities())
            {
                var existente = context.Paciente.Find(id);
                existente.estado = -1;
                existente.usuarioRegistro = usuarioRegistro;
                return context.SaveChanges();
            }
        }

        public static Paciente obtenerUno(int id)
        {
            using (var context = new LabConsultorioMedicoEntities())
            {
                return context.Paciente.Find(id);
            }
        }

        public static List<Paciente> listar()
        {
            using (var context = new LabConsultorioMedicoEntities())
            {
                return context.Paciente.Where(x => x.estado != -1).ToList();
            }
        }
    }
}
