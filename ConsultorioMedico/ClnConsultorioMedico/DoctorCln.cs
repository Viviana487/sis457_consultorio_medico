using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CadConsultorioMedico;

namespace ClnConsultorioMedico
{
    public class DoctorCln
    {
        public static int insertar(Doctor doctor)
        {
            using (var context = new LabConsultorioMedicoEntities())
            {
                context.Doctor.Add(doctor);
                context.SaveChanges();
                return doctor.id;
            }
        }

        public static int actualizar(Doctor doctor)
        {
            using (var context = new LabConsultorioMedicoEntities())
            {
                var existente = context.Doctor.Find(doctor.id);
                existente.cedulaIdentidad = doctor.cedulaIdentidad;
                existente.nombres = doctor.nombres;
                existente.primerApellido = doctor.primerApellido;
                existente.segundoApellido = doctor.segundoApellido;
                existente.direccion = doctor.direccion;
                existente.celular = doctor.celular;
                existente.cargo = doctor.cargo;
                existente.usuarioRegistro = doctor.usuarioRegistro;
                existente.fechaRegistro = doctor.fechaRegistro;
                existente.estado = doctor.estado;
                return context.SaveChanges();
            }
        }

        public static int eliminar(int id, string usuarioRegistro)
        {
            using (var context = new LabConsultorioMedicoEntities())
            {
                var existente = context.Doctor.Find(id);
                existente.estado = -1;
                existente.usuarioRegistro = usuarioRegistro;
                return context.SaveChanges();
            }
        }

        public static Doctor obtenerUno(int id)
        {
            using (var context = new LabConsultorioMedicoEntities())
            {
                return context.Doctor.Find(id);
            }
        }

        public static List<Doctor> listar()
        {
            using (var context = new LabConsultorioMedicoEntities())
            {
                return context.Doctor.Where(x => x.estado != -1).ToList();
            }
        }
    }
}