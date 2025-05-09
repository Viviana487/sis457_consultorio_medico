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
    public partial class FrmDoctor : Form
    {
        public DataGridView DgvLista => dgvLista;
        public FrmDoctor()
        {
            InitializeComponent();
        }

        public void listar()
        {
            var lista = DoctorCln.listarPa(txtParametro.Text.Trim());
            dgvLista.DataSource = lista;
            dgvLista.Columns["id"].Visible = false;
            dgvLista.Columns["idEspecialidad"].Visible = false;
            dgvLista.Columns["estado"].Visible = false;
            dgvLista.Columns["usuario"].HeaderText = "Usuario";
            dgvLista.Columns["cedulaIdentidad"].HeaderText = "Cédula de Identidad";
            dgvLista.Columns["nombres"].HeaderText = "Nombres";
            dgvLista.Columns["primerApellido"].HeaderText = "Apellido Paterno";
            dgvLista.Columns["segundoApellido"].HeaderText = "Apellido Materno";
            dgvLista.Columns["direccion"].HeaderText = "Dirección";
            dgvLista.Columns["celular"].HeaderText = "Celular";
            dgvLista.Columns["nombre"].HeaderText = "Especialidad";
            dgvLista.Columns["usuarioRegistro"].HeaderText = "Usuario Registro";
            dgvLista.Columns["fechaRegistro"].HeaderText = "Fecha Registro";
            if (lista.Count > 0) dgvLista.CurrentCell = dgvLista.Rows[0].Cells["cedulaIdentidad"];
            btnEditar.Enabled = lista.Count > 0;
            btnEliminar.Enabled = lista.Count > 0;
        }
        private void FrmDoctor_Load(object sender, EventArgs e)
        {
            listar();
        }

        private void btnNuevo_Click(object sender, EventArgs e)
        {
            new FrmAgregarEditarDoctor(this, true).ShowDialog();
        }

        private void btnCerrar_Click(object sender, EventArgs e)
        {
            Close();
        }

        private void btnBuscar_Click(object sender, EventArgs e)
        {
            listar();
        }
        private void txtParametro_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar == (char)Keys.Enter) listar();
        }
        private void btnEliminar_Click(object sender, EventArgs e)
        {
            int index = dgvLista.CurrentCell.RowIndex;
            int id = Convert.ToInt32(dgvLista.Rows[index].Cells["id"].Value);
            string ci = dgvLista.Rows[index].Cells["cedulaIdentidad"].Value.ToString();
            DialogResult dialog = MessageBox.Show($"¿Está seguro de eliminar al doctor {ci}?",
                "::: Consultorio Médico - Mensaje :::", MessageBoxButtons.YesNo, MessageBoxIcon.Question);
            if (dialog == DialogResult.Yes)
            {
                DoctorCln.eliminar(id, "");
                listar();
                MessageBox.Show("Doctor dado de baja correctamente", "::: Consultorio Médico - Mensaje :::",
                    MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
        }

        private void btnEditar_Click(object sender, EventArgs e)
        {
            new FrmAgregarEditarDoctor(this).ShowDialog();
        }
    }
}
