using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using ClnConsultorioMedico;

namespace CpConsultorioMedico
{
    public partial class FrmCita : Form
    {
        public FrmCita()
        {
            InitializeComponent();
        }
        public void listar()
        {
            var lista = CitaCln.listarPa(txtParametro.Text.Trim());
            dgvLista.DataSource = lista;
            dgvLista.Columns["id"].Visible = false;
           // dgvLista.Columns["idDoctor"].Visible = false;
            //dgvLista.Columns["idPaciente"].Visible = false;
            dgvLista.Columns["estado"].Visible = false;
            dgvLista.Columns["fecha"].HeaderText = "Fecha Programada";
            dgvLista.Columns["Hora"].HeaderText = "Hora Programada";
            dgvLista.Columns["nombreCompletoPaciente"].HeaderText = "Paciente";
            dgvLista.Columns["nombre"].HeaderText = "Especialidad";
            dgvLista.Columns["nombreCompletoDoctor"].HeaderText = "Doctor";
            dgvLista.Columns["usuarioRegistro"].HeaderText = "Usuario Registro";
            dgvLista.Columns["fechaRegistro"].HeaderText = "Fecha Registro";
            if (lista.Count > 0) dgvLista.CurrentCell = dgvLista.Rows[0].Cells["fecha"];
            btnEditar.Enabled = lista.Count > 0;
            btnEliminar.Enabled = lista.Count > 0;
        }

        private void FrmCita_Load(object sender, EventArgs e)
        {
            Size = new Size(862, 539);
            listar();
        }

        private void btnCerrar_Click(object sender, EventArgs e)
        {
            Close();
        }
    }
}
