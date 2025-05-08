using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CadConsultorioMedico;

namespace ClnConsultorioMedico
{
    public class CitaCln
    {
        public static int insertar(Cita cita)
        {
            using (var context = new LabConsultorioMedicoEntities())
            {
                context.Cita.Add(cita);
                context.SaveChanges();
                return cita.id;
            }
        }
        public static int actualizar(Cita cita)
        {
            using (var context = new LabConsultorioMedicoEntities())
            {
                var existente = context.Cita.Find(cita.id);
                existente.fecha = cita.fecha;
                existente.hora = cita.hora;
                existente.fechaRegistro = cita.fechaRegistro;
                existente.estado = cita.estado;
                existente.usuarioRegistro = cita.usuarioRegistro;
                return context.SaveChanges();
            }
        }
        public static int eliminar(int id, string usuario)
        {
            using (var context = new LabConsultorioMedicoEntities())
            {
                var existente = context.Cita.Find(id);
                existente.estado = -1;
                existente.usuarioRegistro = usuario;
                return context.SaveChanges();
            }
        }
        public static Cita obtenerUno(int id)
        {
            using (var context = new LabConsultorioMedicoEntities())
            {
                return context.Cita.Find(id);
            }
        }
        public static List<Cita> Listar()
        {
            using (var context = new LabConsultorioMedicoEntities())
            {
                return context.Cita.Where(x => x.estado != -1).ToList();
            }
        }
    }
}
