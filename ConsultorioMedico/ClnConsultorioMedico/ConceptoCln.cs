using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CadConsultorioMedico;

namespace ClnConsultorioMedico
{
    public class ConceptoCln
    {
        public static List<Concepto> listar()
        {
            using (var context = new LabConsultorioMedicoEntities())
            {
                return context.Concepto.ToList();
            }
        }
    }
}
