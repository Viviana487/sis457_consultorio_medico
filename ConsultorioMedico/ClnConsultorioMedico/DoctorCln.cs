﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.Entity;
using System.Text;
using System.Threading.Tasks;
using CadConsultorioMedico;

namespace ClnConsultorioMedico
{
    public class DoctorCln
    {
        public static int insertar(Doctor doctor, Usuario usuario)
        {
            using (var context = new LabConsultorioMedicoEntities())
            {
                context.Doctor.Add(doctor);
                context.SaveChanges();

                if (usuario != null && UsuarioCln.obtenerUnoPorDoctor(doctor.id) == null)
                {
                    usuario.idDoctor = doctor.id;
                    usuario.usuarioRegistro = doctor.usuarioRegistro;
                    usuario.fechaRegistro = doctor.fechaRegistro;
                    usuario.estado = doctor.estado;
                    UsuarioCln.insertar(usuario);
                }

                return doctor.id;
            }
        }

        public static int actualizar(Doctor doctor, string nombreUsuario, string clave)
        {
            using (var context = new LabConsultorioMedicoEntities())
            {
                var existente = context.Doctor.Find(doctor.id);
                existente.idEspecialidad = doctor.idEspecialidad;
                existente.cedulaIdentidad = doctor.cedulaIdentidad;
                existente.nombres = doctor.nombres;
                existente.primerApellido = doctor.primerApellido;
                existente.segundoApellido = doctor.segundoApellido;
                existente.direccion = doctor.direccion;
                existente.celular = doctor.celular;
                var especialidad = context.Especialidad.FirstOrDefault(e => e.id == doctor.idEspecialidad);
                if (especialidad != null)
                {
                    existente.Especialidad = especialidad;
                }
                existente.usuarioRegistro = doctor.usuarioRegistro;
                return context.SaveChanges();
            }
        }

        public static int eliminar(int id, string usuarioRegistro)
        {
            using (var context = new LabConsultorioMedicoEntities())
            {
                var existente = context.Doctor.Find(id);
                existente.estado = -1;
                existente.usuarioRegistro = usuarioRegistro;
                return context.SaveChanges();
            }
        }

        public static Doctor obtenerUno(int id)
        {
            using (var context = new LabConsultorioMedicoEntities())
            {
                return context.Doctor.Include(x => x.Usuario).Include(x => x.Especialidad).Where(x => x.id == id).FirstOrDefault();
            }
        }

        public static List<paDoctorListar_Result> listarPa(string parametro)
        {
            using (var context = new LabConsultorioMedicoEntities())
            {
                return context.paDoctorListar(parametro).ToList();
            }
        }
    }
}