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
    public partial class FrmCita : Form
    {
        private bool esNuevo = false;
        public FrmCita()
        {
            InitializeComponent();
        }
        public void listar()
        {
            var lista = CitaCln.listarPa(txtParametro.Text.Trim());
            dgvLista.DataSource = lista;
            dgvLista.Columns["id"].Visible = false;
            dgvLista.Columns["estado"].Visible = false;
            dgvLista.Columns["fecha"].HeaderText = "Fecha Programada";
            dgvLista.Columns["Hora"].HeaderText = "Hora Programada";
            dgvLista.Columns["cedulaIdentidad"].HeaderText = "Cédula de Identidad";
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
            cargarEspecialidades();
            cargarDoctores();
            Size = new Size(862, 539);
            listar();
        }

        private void btnCerrar_Click(object sender, EventArgs e)
        {
            Close();
        }
        public void obtenerNombrePaciente()
        {
            if (txtParametro.Text == string.Empty)
            {
                txtFPaciente.Text = string.Empty;
            }
            else
            {
                if (dgvLista.Rows.Count > 0)
                {
                    var paciente = dgvLista.CurrentRow.Cells["nombreCompletoPaciente"].Value.ToString();
                    txtFPaciente.Text = paciente;
                }
                else
                {
                    txtFPaciente.Text = string.Empty;
                    MessageBox.Show("El paciente no existe", "::: Consultorio Médico - Mensaje :::",
                        MessageBoxButtons.OK, MessageBoxIcon.Information);
                }
            }
        }

        private void btnBuscar_Click(object sender, EventArgs e)
        {
            listar();
            obtenerNombrePaciente();
        }
        private void txtParametro_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar == (char)Keys.Enter) 
            {
                listar();
                obtenerNombrePaciente(); 
            }
        }
        public void listarFecha()
        {
            var lista = CitaCln.listarFecha(dtpFFecha.Value);
            dgvLista.DataSource = lista;
            dgvLista.Columns["id"].Visible = false;
            dgvLista.Columns["estado"].Visible = false;
            dgvLista.Columns["fecha"].HeaderText = "Fecha Programada";
            dgvLista.Columns["Hora"].HeaderText = "Hora Programada";
            dgvLista.Columns["cedulaIdentidad"].HeaderText = "Cédula de Identidad";
            dgvLista.Columns["nombreCompletoPaciente"].HeaderText = "Paciente";
            dgvLista.Columns["nombre"].HeaderText = "Especialidad";
            dgvLista.Columns["nombreCompletoDoctor"].HeaderText = "Doctor";
            dgvLista.Columns["usuarioRegistro"].HeaderText = "Usuario Registro";
            dgvLista.Columns["fechaRegistro"].HeaderText = "Fecha Registro";
            if (lista.Count > 0) dgvLista.CurrentCell = dgvLista.Rows[0].Cells["fecha"];
            btnEditar.Enabled = lista.Count > 0;
            btnEliminar.Enabled = lista.Count > 0;
        }
        private void dtpFFecha_ValueChanged(object sender, EventArgs e)
        {
            listarFecha();
            if (dtpFFecha.Value != DateTime.Now)
            {
                txtParametro.Text = string.Empty;
                txtFPaciente.Text = string.Empty;
            }
        }

        private void btnNuevo_Click(object sender, EventArgs e)
        {
            esNuevo = true;
            Size = new Size(862, 713);
            txtPaciente.Focus();
        }
        private void cargarEspecialidades()
        {
            var especialidades = EspecialidadCln.listar();
            cbxEspecialidad.DataSource = especialidades;
            cbxEspecialidad.DisplayMember = "nombre";
            cbxEspecialidad.ValueMember = "id";
            cbxEspecialidad.SelectedIndex = -1;
        }
        private void cargarDoctores()
        {
            var doctores = DoctorCln.listar();
            cbxDoctor.DataSource = doctores;
            cbxDoctor.DisplayMember = "nombreCompletoDoctor";
            cbxDoctor.ValueMember = "id";
            cbxDoctor.SelectedIndex = -1;
        }

        private void btnEditar_Click(object sender, EventArgs e)
        {
            esNuevo = false;
            Size = new Size(862, 713);

            int index = dgvLista.CurrentCell.RowIndex;
            int id = Convert.ToInt32(dgvLista.Rows[index].Cells["id"].Value);
            var cita = CitaCln.obtenerUno(id);
            var paciente = PacienteCln.obtenerUno(cita.idPaciente);
            txtPaciente.Text = paciente.nombreCompletoPaciente;
            cbxEspecialidad.SelectedValue = cita.idEspecialidad;
            cbxDoctor.SelectedValue = cita.idDoctor;
            dtpFecha.Value = cita.fecha;
            cbxHora.SelectedValue = cita.hora;
            txtPaciente.Focus();
        }
    }
}
