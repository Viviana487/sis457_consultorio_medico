using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CadConsultorioMedico;

namespace ClnConsultorioMedico
{
        public class PagoCln
        {
            public static int insertar(Pago pago)
            {
                using (var context = new LabConsultorioMedicoEntities())
                {
                    context.Pago.Add(pago);
                    context.SaveChanges();
                    return pago.id;
                }
            }

            public static int actualizar(Pago pago)
            {
                using (var context = new LabConsultorioMedicoEntities())
                {
                    var existente = context.Pago.Find(pago.id);
                    existente.concepto = pago.concepto;
                    existente.monto = pago.monto;
                    existente.cambio = pago.cambio;
                    existente.fechaRegistro = pago.fechaRegistro;
                    existente.usuarioRegistro = pago.usuarioRegistro;
                    existente.fecha = pago.fecha;
                    existente.estado = pago.estado;
                    return context.SaveChanges();
                }
            }

            public static int eliminar(int id, string usuarioRegistro)
            {
                using (var context = new LabConsultorioMedicoEntities())
                {
                    var existente = context.Pago.Find(id);
                    existente.estado = -1;
                    existente.usuarioRegistro = usuarioRegistro;
                    return context.SaveChanges();
                }
            }

            public static Pago obtenerUno(int id)
            {
                using (var context = new LabConsultorioMedicoEntities())
                {
                    return context.Pago.Find(id);
                }
            }

            public static List<Pago> listar()
            {
                using (var context = new LabConsultorioMedicoEntities())
                {
                    return context.Pago.Where(x => x.estado != -1).ToList();
                }
            }
        }
    }
