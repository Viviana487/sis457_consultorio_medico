using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using CadConsultorioMedico;
using ClnConsultorioMedico;

namespace CpConsultorioMedico
{
    public partial class FrmPago : Form
    {
        public FrmPago(string paciente, string especialidad)
        {
            InitializeComponent();
            txtPaciente.Text = paciente;
            txtEspecialidad.Text = especialidad;
        }
        private void FrmPago_Load(object sender, EventArgs e)
        {
            nudCosto.Maximum = 1000000;
            nudCosto.DecimalPlaces = 2;
            nudMonto.Maximum = 1000000;
            nudMonto.DecimalPlaces = 2;
            nudCambio.Maximum = 1000000;
            nudCambio.DecimalPlaces = 2;
            nudCosto.Enabled = false;
            nudCambio.Enabled = false;
            txtPaciente.ReadOnly = true;
            txtEspecialidad.ReadOnly = true;
            cargarConceptos();
        }
        private void cargarConceptos()
        {
            var conceptos = ConceptoCln.listar();
            cbxConcepto.DataSource = conceptos;
            cbxConcepto.DisplayMember = "descripcion";
            cbxConcepto.ValueMember = "id";
            cbxConcepto.SelectedIndex = -1;
        }
        private void cbxConcepto_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (cbxConcepto.SelectedIndex != -1 && cbxConcepto.SelectedValue is int idConcepto)
            {
                var pago = PagoCln.obtenerMonto(idConcepto);

                if (pago != null)
                {
                    nudCosto.Value = pago.monto;
                }
                else
                {
                    nudMonto.Value = 0;
                }
            }
        }
        private void calcularCambio()
        {
            decimal cambio = nudMonto.Value - nudCosto.Value;
            nudCambio.Value = cambio;
        }
        private void btnCancelar_Click(object sender, EventArgs e)
        {
            Close();
        }

        private void nudMonto_ValueChanged(object sender, EventArgs e)
        {
            calcularCambio();
        }
    }
}
