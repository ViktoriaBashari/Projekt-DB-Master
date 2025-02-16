﻿using Dapper;
using HospitalManagement.Common;
using HospitalManagement.Common.Enums;
using HospitalManagement.Models.Data;
using HospitalManagement.Models.ViewModels;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;

namespace HospitalManagement.Controllers;

[Authorize(Roles = nameof(Roles.Administrator))]
public class PatientsController : BaseController
{
    public PatientsController(IConfiguration configuration) : base(configuration) { }

    [HttpGet]
    public async Task<IActionResult> Index()
    {
        var connectionString = _configuration.GetConnectionString(_dbConnectionStringName);
        using var connection = new SqlConnection(connectionString);

        var paciente = await connection.QueryAsync<Pacient>(
            """
            EXECUTE AS USER = @Username;
            SELECT * FROM InformacionPacient;
            REVERT;
            """,
            new { Username = GetLoggedInUsername() });

        await connection.CloseAsync();
        return View(paciente.ToList());
    }

    [HttpGet]
    public async Task<IActionResult> GetNurseAppointments(int nurseId)
    {
        var connectionString = _configuration.GetConnectionString(_dbConnectionStringName);
        using var connection = new SqlConnection(connectionString);

        var appointments = await connection.QueryAsync<Appointment>(
            """
            EXECUTE AS USER = @Username;
            SELECT * FROM Takime WHERE InfermierId = @NurseId;
            REVERT;
            """,
            new { Username = GetLoggedInUsername(), NurseId = nurseId });

        await connection.CloseAsync();
        return Ok(appointments);
    }

    [HttpDelete]
    public async Task<IActionResult> DeletePatient(int id)
    {
        var connectionString = _configuration.GetConnectionString(_dbConnectionStringName);
        using var connection = new SqlConnection(connectionString);

        var existingPacient = await connection.QuerySingleOrDefaultAsync(
            """
            EXECUTE AS USER = @Username;
            SELECT 1 FROM Pacient WHERE Id = @PacientId;
            REVERT;
            """,
            new { Username = GetLoggedInUsername(), PacientId = id });

        if (existingPacient == null)
            return NotFound();

        await connection.ExecuteAsync(
            """
            EXECUTE AS USER = @Username;
            EXEC dbo.FshiPacient @PacientId;
            REVERT;
            """,
            new { Username = GetLoggedInUsername(), PacientId = id });

        return NoContent();
    }

    [HttpGet]
    public async Task<IActionResult> Upsert(int? id = null)
    {
        if (id.HasValue && id.Value > 0)
        {
            var connectionString = _configuration.GetConnectionString(_dbConnectionStringName);
            using var connection = new SqlConnection(connectionString);

            var existingPacient = await connection.QuerySingleOrDefaultAsync<Pacient>(
                """
                EXECUTE AS USER = @Username;
                SELECT * FROM InformacionPacient WHERE Id = @PacientId;
                REVERT;
                """,
                new { Username = GetLoggedInUsername(), PacientId = id.Value });

            return View(existingPacient);
        }

        return View(new Pacient { Id = 0, Emri = string.Empty, Mbiemri = string.Empty, Mosha = 0, Gjinia = "" });
    }

    [HttpPost]
    public async Task<IActionResult> Upsert(Pacient pacient)
    {
        if (!ModelState.IsValid)
        {
            return View(pacient);
        }

        Pacient? existingPacient = null;

        var connectionString = _configuration.GetConnectionString(_dbConnectionStringName);
        using var connection = new SqlConnection(connectionString);

        if (pacient.Id > 0)
        {
            existingPacient = await connection.QuerySingleOrDefaultAsync<Pacient>(
                """
                EXECUTE AS USER = @Username;
                SELECT * FROM InformacionPacient WHERE Id = @PacientId;
                REVERT;
                """,
                new { Username = GetLoggedInUsername(), PacientId = pacient.Id });

            if (existingPacient == null)
            {
                ModelState.AddModelError(string.Empty, "Pacienti nuk u gjet, provoni përsëri më vonë");
                return View(pacient);
            }
        }

        if (pacient.Id == 0)
        {
            var newPacientId = await connection.ExecuteScalarAsync<int>(
                """
                EXECUTE AS USER = @Username;
                INSERT INTO Pacient (Emri, Mbiemri, Mosha, Gjinia)
                VALUES (@Emri, @Mbiemri, @Mosha, @Gjinia);
                SELECT SCOPE_IDENTITY();
                REVERT;
                """,
                new
                {
                    Username = GetLoggedInUsername(),
                    pacient.Emri,
                    pacient.Mbiemri,
                    pacient.Mosha,
                    pacient.Gjinia
                });

            pacient.Id = newPacientId;
        }
        else
        {
            await connection.ExecuteAsync(
                """
                EXECUTE AS USER = @Username;
                UPDATE Pacient 
                SET Emri = @Emri, Mbiemri = @Mbiemri, Mosha = @Mosha, Gjinia = @Gjinia
                WHERE Id = @PacientId;
                REVERT;
                """,
                new
                {
                    Username = GetLoggedInUsername(),
                    pacient.Emri,
                    pacient.Mbiemri,
                    pacient.Mosha,
                    pacient.Gjinia,
                    PacientId = pacient.Id
                });
        }

        return RedirectToAction(nameof(Index));
    }
}

public class Appointment
{
    public int Id { get; set; }
    public int PacientId { get; set; }
    public int InfermierId { get; set; }
    public DateTime DataTakimit { get; set; }
}
