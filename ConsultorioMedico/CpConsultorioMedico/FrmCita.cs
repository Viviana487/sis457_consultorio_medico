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
using static System.Windows.Forms.VisualStyles.VisualStyleElement;

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
        private void limpiar()
        {
            txtPaciente.Clear();
            cbxEspecialidad.SelectedIndex = -1;
            cbxDoctor.SelectedIndex = -1;
            dtpFecha.Value = DateTime.Now;
            cbxHora.SelectedIndex = -1;
        }
        private void FrmCita_Load(object sender, EventArgs e)
        {
            Size = new Size(862, 539);
            listar();
            cargarEspecialidades();
            cargarDoctores();
            cargarHoras();
            this.txtFPaciente.TextChanged += new System.EventHandler(this.txtFPaciente_TextChanged);
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
                txtParametro.Clear();
                txtFPaciente.Clear();
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
        private void cargarHoras()
        {
            cbxHora.Items.Clear();

            for (int h = 9; h <= 17; h++)
            {
                cbxHora.Items.Add(new TimeSpan(h, 0, 0));
                if (h != 17)
                    cbxHora.Items.Add(new TimeSpan(h, 30, 0));
            }

            cbxHora.SelectedIndex = -1;
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
            cbxHora.SelectedItem = cita.hora;
            txtPaciente.Focus();
        }
        private void btnCancelar_Click(object sender, EventArgs e)
        {
            Size = new Size(862, 539);
            limpiar();
        }
        private void txtFPaciente_TextChanged(object sender, EventArgs e)
        {
            txtPaciente.Text = txtFPaciente.Text;
        }
        private void btnGuardar_Click(object sender, EventArgs e)
        {
            var cita = new Cita();
            cita.idEspecialidad = Convert.ToInt32(cbxEspecialidad.SelectedValue);
            cita.idDoctor = Convert.ToInt32(cbxDoctor.SelectedValue);
            cita.fecha = dtpFecha.Value;
            cita.hora = (TimeSpan)cbxHora.SelectedItem;
            cita.usuarioRegistro = "Vivi";
            if (esNuevo)
            {
                txtPaciente.Text = txtFPaciente.Text;
                var paciente = PacienteCln.buscar(txtPaciente.Text.Trim());
                cita.idPaciente = paciente.id;
                cita.fechaRegistro = DateTime.Now;
                cita.estado = 1;
                CitaCln.insertar(cita);
            }
            else
            {
                int index = dgvLista.CurrentCell.RowIndex;
                cita.id = Convert.ToInt32(dgvLista.Rows[index].Cells["id"].Value);
                var paciente = PacienteCln.buscar(txtPaciente.Text.Trim());
                cita.idPaciente = paciente.id;
                CitaCln.actualizar(cita);
                //DoctorCln.actualizar(doctor, txtUsuario.Text.Trim(), Util.Encrypt("hola123"));
            }
            /*if (validar())
            {
                var cita = new Cita();
                var paciente = PacienteCln.obtenerUno(cita.idPaciente);
                paciente.nombreCompletoPaciente = txtPaciente.Text;
                cita.idEspecialidad = Convert.ToInt32(cbxEspecialidad.SelectedValue);
                cita.idDoctor = Convert.ToInt32(cbxDoctor.SelectedValue);
                cita.fecha = dtpFecha.Value;
                cita.hora = (TimeSpan)cbxHora.SelectedItem;
                //doctor.usuarioRegistro = Util.usuario.usuario1;

                /*Usuario usuario = null;
                if (!string.IsNullOrEmpty(txtUsuario.Text))
                {
                    usuario = new Usuario();
                    usuario.usuario1 = txtUsuario.Text.Trim();
                    usuario.clave = Util.Encrypt("hola123");
                }

                if (esNuevo)
                {
                    doctor.fechaRegistro = DateTime.Now;
                    doctor.estado = 1;
                    //DoctorCln.insertar(doctor, usuario);
                }
                else
                {
                    int index = dgvLista.CurrentCell.RowIndex;
                    doctor.id = Convert.ToInt32(dgvLista.Rows[index].Cells["id"].Value);
                    //DoctorCln.actualizar(doctor, txtUsuario.Text.Trim(), Util.Encrypt("hola123"));
                }*/
            listar();
                btnCancelar.PerformClick();
                MessageBox.Show("Registro guardado correctamente", "::: Consultorio Médico - Mensaje :::",
                    MessageBoxButtons.OK, MessageBoxIcon.Information);
        }

        private void btnEliminar_Click(object sender, EventArgs e)
        {
            int index = dgvLista.CurrentCell.RowIndex;
            int id = Convert.ToInt32(dgvLista.Rows[index].Cells["id"].Value);
            string paciente = dgvLista.Rows[index].Cells["nombreCompletoPaciente"].Value.ToString();
            string fecha = dgvLista.Rows[index].Cells["fecha"].Value.ToString();
            string hora = dgvLista.Rows[index].Cells["hora"].Value.ToString();
            DialogResult dialog = MessageBox.Show($"¿Está seguro que desea eliminar la cita del paciente {paciente} para la fecha {fecha} a horas {hora}?",
                "::: Consultorio Médico - Mensaje ::: ", MessageBoxButtons.YesNo, MessageBoxIcon.Question);
            if (dialog == DialogResult.Yes)
            {
                CitaCln.eliminar(id, "vivi");
                listar();
                MessageBox.Show("Cita dada de baja correctamente", "::: Consutorio Médico - Mensaje ::: ",
                    MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
        }

        private void btnPagar_Click(object sender, EventArgs e)
        {
            new FrmPago().ShowDialog();
        }
    }
}
