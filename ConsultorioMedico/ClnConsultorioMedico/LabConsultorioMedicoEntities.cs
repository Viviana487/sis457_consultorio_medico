using System;

namespace ClnConsultorioMedico
{
    internal class LabConsultorioMedicoEntities : IDisposable
    {
        public object Pago { get; internal set; }
        public object Especialidad { get; internal set; }

        internal void SaveChanges()
        {
            throw new NotImplementedException();
        }
    }
}