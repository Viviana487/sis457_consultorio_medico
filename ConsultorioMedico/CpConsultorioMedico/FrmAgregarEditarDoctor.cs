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
    public partial class FrmAgregarEditarDoctor : Form
    {
        private FrmDoctor _frmDoctor;

        private bool esNuevo = false;
        public FrmAgregarEditarDoctor()
        {
            InitializeComponent();
        }
        public FrmAgregarEditarDoctor(FrmDoctor frmDoctor, bool nuevo) : this(frmDoctor)
        {
            esNuevo = nuevo;
        }
        public FrmAgregarEditarDoctor(FrmDoctor frmDoctor): this()
        {
            _frmDoctor = frmDoctor; 
        }
        private bool validar()
        {
            bool esValido = true;
            erpCedulaIdentidad.SetError(txtCedulaIdentidad, "");
            erpNombres.SetError(txtNombres, "");
            erpApellidos.SetError(txtPrimerApellido, "");
            erpDireccion.SetError(txtDireccion, "");
            erpCelular.SetError(txtCelular, "");
            erpEspecialidad.SetError(cbxEspecialidad, "");

            if (string.IsNullOrEmpty(txtCedulaIdentidad.Text))
            {
                erpCedulaIdentidad.SetError(txtCedulaIdentidad, "El campo CI es obligatorio");
                esValido = false;
            }
            if (string.IsNullOrEmpty(txtNombres.Text))
            {
                erpNombres.SetError(txtNombres, "El campo Nombres es obligatorio");
                esValido = false;
            }
            if (string.IsNullOrEmpty(txtPrimerApellido.Text) && string.IsNullOrEmpty(txtSegundoApellido.Text))
            {
                erpApellidos.SetError(txtPrimerApellido, "Debe introducir al menos un apellido");
                erpApellidos.SetError(txtSegundoApellido, "Debe introducir al menos un apellido");
                esValido = false;
            }
            if (string.IsNullOrEmpty(txtDireccion.Text))
            {
                erpDireccion.SetError(txtDireccion, "El campo Dirección es obligatorio");
                esValido = false;
            }
            if (string.IsNullOrEmpty(txtCelular.Text) || txtCelular.Text.Length != 8)
            {
                erpCelular.SetError(txtCelular, "El campo Celular es obligatorio o no tiene la longitud correcta");
                esValido = false;
            }
            if (string.IsNullOrEmpty(cbxEspecialidad.Text))
            {
                erpEspecialidad.SetError(cbxEspecialidad, "El campo Especilalidad es obligatorio");
                esValido = false;
            }
            if (string.IsNullOrEmpty(txtUsuario.Text))
            {
                erpEspecialidad.SetError(txtUsuario, "El campo Usuario es obligatorio");
                esValido = false;
            }

            return esValido;
        }

        public FrmAgregarEditarDoctor(FrmDoctor frmDoctor, DataRow filaDoctor): this(frmDoctor)
        {
            esNuevo = false;
        }

        private void FrmAgregarEditarDoctor_Load(object sender, EventArgs e)
        {
            using (var context = new LabConsultorioMedicoEntities())
            {
                var especialidad = context.Especialidad
                    .Select(x => new { x.id, x.nombre })
                    .ToList();

                cbxEspecialidad.DataSource = especialidad;
                cbxEspecialidad.DisplayMember = "nombre"; 
                cbxEspecialidad.ValueMember = "id";
                cbxEspecialidad.SelectedIndex = -1;
            }
            if (esNuevo == false)
            {
                int index = _frmDoctor.DgvLista.CurrentCell.RowIndex;
                int id = Convert.ToInt32(_frmDoctor.DgvLista.Rows[index].Cells["id"].Value);
                var doctor = DoctorCln.obtenerUno(id);
                var usuario = doctor.Usuario.Count > 0 ? doctor.Usuario.First().usuario1 : "";
                txtCedulaIdentidad.Text = doctor.cedulaIdentidad;
                txtNombres.Text = doctor.nombres;
                txtPrimerApellido.Text = doctor.primerApellido;
                txtSegundoApellido.Text = doctor.segundoApellido;
                txtDireccion.Text = doctor.direccion;
                txtCelular.Text = doctor.celular.ToString();
                txtUsuario.Text = usuario;
                cbxEspecialidad.Text = doctor.Especialidad.nombre;
                txtCedulaIdentidad.Focus();
            }
        }

        private void btnGuardar_Click(object sender, EventArgs e)
        {
            if (validar())
            {
                var doctor = new Doctor();
                doctor.cedulaIdentidad = txtCedulaIdentidad.Text.Trim();
                doctor.nombres = txtNombres.Text.Trim();
                doctor.primerApellido = txtPrimerApellido.Text.Trim();
                doctor.segundoApellido = txtSegundoApellido.Text.Trim();
                doctor.direccion = txtDireccion.Text.Trim();
                doctor.celular = Convert.ToInt64(txtCelular.Text);
                doctor.idEspecialidad = Convert.ToInt32(cbxEspecialidad.SelectedValue);
                doctor.usuarioRegistro = "admin";

                Usuario usuario = null;
                if (!string.IsNullOrEmpty(txtUsuario.Text))
                {
                    usuario = new Usuario();
                    usuario.usuario1 = txtUsuario.Text.Trim();
                    usuario.clave = "hola123";
                }

                if (esNuevo)
                {
                    doctor.fechaRegistro = DateTime.Now;
                    doctor.estado = 1;
                    DoctorCln.insertar(doctor, usuario);
                }
                else
                {
                    int index = _frmDoctor.DgvLista.CurrentCell.RowIndex;
                    doctor.id = Convert.ToInt32(_frmDoctor.DgvLista.Rows[index].Cells["id"].Value);
                    DoctorCln.actualizar(doctor, txtUsuario.Text.Trim(), "hola123");
                }
                _frmDoctor.listar();
                btnCancelar.PerformClick();
                MessageBox.Show("Registro guardado correctamente", "::: Consultorio Médico - Mensaje :::",
                    MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
        }
        private void btnCancelar_Click(object sender, EventArgs e)
        {
            Close();
        }
    }
}
