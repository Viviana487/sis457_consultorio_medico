using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace CpConsultorioMedico
{
    public partial class FrmMenu : Form
    {
        public FrmMenu()
        {
            InitializeComponent();
        }

        private void ribbonGroup3_DialogLauncherClick(object sender, EventArgs e)
        {

        }

        private void btnPaPacientes_Click(object sender, EventArgs e)
        {
            new FrmPaciente().ShowDialog();
        }

        private void btnPaAgregarPaciente_Click(object sender, EventArgs e)
        {
            new FrmAgregarEditarPaciente().ShowDialog();
        }

        private void btnDoDoctores_Click(object sender, EventArgs e)
        {
            new FrmDoctor().ShowDialog();
        }

        private void btnDoAgregarDoctor_Click(object sender, EventArgs e)
        {
            new FrmAgregarEditarDoctor().ShowDialog();
        }

        private void btnEsEspecialidades_Click(object sender, EventArgs e)
        {
            new FrmEspecialidad().ShowDialog();
        }

        private void btnHCHistoriales_Click(object sender, EventArgs e)
        {
            new FrmHistorial().ShowDialog();
        }

        private void btnCiCitas_Click(object sender, EventArgs e)
        {
            new FrmCita().ShowDialog();
        }

        private void btnCiAgendarCita_Click(object sender, EventArgs e)
        {
            new FrmAgregarEditarCita().ShowDialog();
        }

        private void btnHCAgregarHistorial_Click(object sender, EventArgs e)
        {
            new FrmAgregarEditarHistorial().ShowDialog();
        }
    }
}
