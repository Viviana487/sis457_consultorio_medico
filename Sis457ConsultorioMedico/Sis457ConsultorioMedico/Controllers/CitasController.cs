using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using Sis457ConsultorioMedico.Models;

namespace Sis457ConsultorioMedico.Controllers
{
    public class CitasController : Controller
    {
        private readonly FinalConsultorioMedicoContext _context;

        public CitasController(FinalConsultorioMedicoContext context)
        {
            _context = context;
        }

        // GET: Citas
        public async Task<IActionResult> Index()
        {
            var finalConsultorioMedicoContext = _context.Cita.Include(c => c.IdDoctorNavigation).Include(c => c.IdEspecialidadNavigation).Include(c => c.IdPacienteNavigation);
            return View(await finalConsultorioMedicoContext.ToListAsync());
        }

        // GET: Citas/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var cita = await _context.Cita
                .Include(c => c.IdDoctorNavigation)
                .Include(c => c.IdEspecialidadNavigation)
                .Include(c => c.IdPacienteNavigation)
                .FirstOrDefaultAsync(m => m.Id == id);
            if (cita == null)
            {
                return NotFound();
            }

            return View(cita);
        }

        // GET: Citas/Create
        public IActionResult Create()
        {
            ViewData["IdDoctor"] = new SelectList(
             _context.Doctores
                 .Select(d => new { d.Id, NombreCompleto = d.Nombres + " " + d.PrimerApellido + " " + d.SegundoApellido }),
             "Id",
             "NombreCompleto"
            );

            ViewData["IdPaciente"] = new SelectList(
                _context.Pacientes
                    .Select(p => new { p.Id, NombreCompleto = p.Nombres + " " + p.PrimerApellido + " " + p.SegundoApellido }),
                "Id",
                "NombreCompleto"
            );
            ViewData["IdEspecialidad"] = new SelectList(_context.Especialidades, "Id", "Nombre");
            return View();
        }

        // POST: Citas/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("Id,IdDoctor,IdPaciente,IdEspecialidad,Fecha,Hora,UsuarioRegistro,FechaRegistro,Estado")] Cita cita)
        {
            if (ModelState.IsValid)
            {
                _context.Add(cita);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            ViewData["IdDoctor"] = new SelectList(
             _context.Doctores
                 .Select(d => new { d.Id, NombreCompleto = d.Nombres + " " + d.PrimerApellido + " " + d.SegundoApellido }),
             "Id",
             "NombreCompleto"
            );

            ViewData["IdPaciente"] = new SelectList(
                _context.Pacientes
                    .Select(p => new { p.Id, NombreCompleto = p.Nombres + " " + p.PrimerApellido + " " + p.SegundoApellido }),
                "Id",
                "NombreCompleto"
            );
            ViewData["IdEspecialidad"] = new SelectList(_context.Especialidades, "Id", "Nombre");
            return View();
            return View(cita);
        }

        // GET: Citas/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var cita = await _context.Cita.FindAsync(id);
            if (cita == null)
            {
                return NotFound();
            }
            ViewData["IdDoctor"] = new SelectList(_context.Doctores, "Id", "Id", cita.IdDoctor);
            ViewData["IdEspecialidad"] = new SelectList(_context.Especialidades, "Id", "Id", cita.IdEspecialidad);
            ViewData["IdPaciente"] = new SelectList(_context.Pacientes, "Id", "Id", cita.IdPaciente);
            return View(cita);
        }

        // POST: Citas/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("Id,IdDoctor,IdPaciente,IdEspecialidad,Fecha,Hora,UsuarioRegistro,FechaRegistro,Estado")] Cita cita)
        {
            if (id != cita.Id)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(cita);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!CitaExists(cita.Id))
                    {
                        return NotFound();
                    }
                    else
                    {
                        throw;
                    }
                }
                return RedirectToAction(nameof(Index));
            }
            ViewData["IdDoctor"] = new SelectList(_context.Doctores, "Id", "Id", cita.IdDoctor);
            ViewData["IdEspecialidad"] = new SelectList(_context.Especialidades, "Id", "Id", cita.IdEspecialidad);
            ViewData["IdPaciente"] = new SelectList(_context.Pacientes, "Id", "Id", cita.IdPaciente);
            return View(cita);
        }

        // GET: Citas/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var cita = await _context.Cita
                .Include(c => c.IdDoctorNavigation)
                .Include(c => c.IdEspecialidadNavigation)
                .Include(c => c.IdPacienteNavigation)
                .FirstOrDefaultAsync(m => m.Id == id);
            if (cita == null)
            {
                return NotFound();
            }

            return View(cita);
        }

        // POST: Citas/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var cita = await _context.Cita.FindAsync(id);
            if (cita != null)
            {
                _context.Cita.Remove(cita);
            }

            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool CitaExists(int id)
        {
            return _context.Cita.Any(e => e.Id == id);
        }
    }
}
