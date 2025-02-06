using Dapper;
using HospitalManagement.Common;
using HospitalManagement.Models.Data;
using HospitalManagement.Models.ViewModels;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;

namespace HospitalManagement.Controllers;

public class StaffController : BaseController
{
    public StaffController(IConfiguration configuration) : base(configuration) { }

    [HttpGet]
    public async Task<IActionResult> Index()
    {
        var connectionString = _configuration.GetConnectionString(_dbConnectionStringName);
        using var connection = new SqlConnection(connectionString);

        var staff = await connection.QueryAsync<StaffSummary>(
            """
            EXECUTE AS USER = @Username;
            
            SELECT 
                Id, Emri, Mbiemri,
                PunonjesId, DataPunesimit, Specialiteti,
                RolEmertimi AS Roli, DepartamentEmri
            FROM InformacionDetajuarStafi;

            REVERT;
            """,
            new { Username = GetLoggedInUsername() });

        return View(staff.ToList());
    }

    [HttpGet]
    public async Task<IActionResult> Details(int personId)
    {
        var connectionString = _configuration.GetConnectionString(_dbConnectionStringName);
        using var connection = new SqlConnection(connectionString);

        var staffMember = await connection.QuerySingleOrDefaultAsync<Staff>(
            """
            EXECUTE AS USER = @Username;
            SELECT * FROM InformacionDetajuarStafi WHERE Id = @PersonId;
            REVERT;
            """,
            new { Username = GetLoggedInUsername(), PersonId = personId });

        if (staffMember == null)
            return RedirectToAction(nameof(Index));

        var schedules = await connection.QueryAsync<FullSchedule>(
            """
            EXECUTE AS USER = @Username;
            
            SELECT StafId, TurnId, EmriTurnit, OraFilluese, OraPerfundimtare, DitaId, Dita 
            FROM OrariPloteStafit 
            WHERE StafId = @PersonId;
            
            REVERT;
            """,
            new { Username = GetLoggedInUsername(), PersonId = personId });

        return View(new StaffDetailsVM { Staff = staffMember, Schedule = schedules.ToList()});
    }
}
