using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using C1.Framework;
using CadConsultorioMedico;
using ClnConsultorioMedico;

namespace CpConsultorioMedico
{
    public partial class FrmPago : Form
    {
        private int idCita;
        private bool esNuevo = true;
        private FrmCita formCita;
        public FrmPago(FrmCita frmCita, int id ,string paciente, string especialidad)
        {
            InitializeComponent();
            txtPaciente.Text = paciente;
            txtEspecialidad.Text = especialidad;
            formCita = frmCita;
            idCita = id;
        }
        private void FrmPago_Load(object sender, EventArgs e)
        {
            nudCosto.Maximum = 1000000;
            nudCosto.DecimalPlaces = 2;
            nudEfectivo.Maximum = 1000000;
            nudEfectivo.DecimalPlaces = 2;
            nudCambio.Maximum = 1000000;
            nudCambio.DecimalPlaces = 2;
            txtPaciente.ReadOnly = true;
            txtEspecialidad.ReadOnly = true;
            cargarConceptos();
            cbxConcepto.Focus();
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
                var pago = PagoCln.obtenerCosto(idConcepto);

                if (pago != null)
                {
                    nudCosto.Value = pago.costo;
                }
                else
                {
                    nudEfectivo.Value = 0;
                }
            }
        }
        private void calcularCambio()
        {
            decimal cambio = nudEfectivo.Value - nudCosto.Value;
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
        private bool validar()
        {
            bool esValido = true;
            erpConcepto.SetError(cbxConcepto, "");
            erpEfectivo.SetError(nudEfectivo, "");
            if (string.IsNullOrEmpty(cbxConcepto.Text))
            {
                erpConcepto.SetError(cbxConcepto, "El campo Concepto es obligatorio");
                esValido = false;
            }
            if (nudEfectivo.Value <= 0 || nudEfectivo.Value < nudCosto.Value)
            {
                erpEfectivo.SetError(nudEfectivo, "El campo Efectivo es obligatorio o debe ser igual o mayor al costo");
                esValido = false;
            }
            return esValido;
        }
        private void btnGuardar_Click(object sender, EventArgs e)
        {
            if (validar())
            {
                var pago = new Pago();
                pago.idCita = idCita;
                pago.idConcepto = Convert.ToInt32(cbxConcepto.SelectedValue);
                pago.costo = nudCosto.Value;
                pago.fecha = DateTime.Now;
                //doctor.usuarioRegistro = Util.usuario.usuario1;

                /*Usuario usuario = null;
                if (!string.IsNullOrEmpty(txtUsuario.Text))
                {
                    usuario = new Usuario();
                    usuario.usuario1 = txtUsuario.Text.Trim();
                    usuario.clave = Util.Encrypt("hola123");
                }*/

                if (esNuevo)
                {
                    pago.fechaRegistro = DateTime.Now;
                    pago.estado = 1;
                    pago.usuarioRegistro = "Vivi";
                    PagoCln.insertar(pago);
                }
                formCita.refrescar();
                btnCancelar.PerformClick();
                MessageBox.Show("Pago guardado correctamente", "::: Consultorio Médico - Mensaje :::",
                    MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
        }
    }
}
