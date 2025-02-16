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
    public async Task<IActionResult> Index(int page = 0, int size = 10)
    {
        var connectionString = _configuration.GetConnectionString(_dbConnectionStringName);
        using var connection = new SqlConnection(connectionString);

        var result = await connection.QueryMultipleAsync(
            """
            EXECUTE AS USER = @Username;
            
            SELECT 
                Id, Emri, Mbiemri,
                PunonjesId, DataPunesimit, Specialiteti,
                RolEmertimi AS Roli, DepartamentEmri
            FROM InformacionDetajuarStafi
            ORDER BY Id
            OFFSET @Offset ROWS FETCH NEXT @Limit ROWS ONLY;

            SELECT 
            CASE WHEN EXISTS(
            	SELECT 1 
            	FROM InformacionDetajuarStafi
            	ORDER BY Id
            	OFFSET (@Offset + @Limit) ROWS)
            THEN 1 
            ELSE 0 END
            AS EkzistonFaqeTjeter;

            REVERT;
            """,
            new { Username = GetLoggedInUsername(), Offset = page * size, Limit = size });

        var staff = await result.ReadAsync<StaffSummary>();
        ViewBag.HasNextPage = (await result.ReadSingleAsync<int>()) == 1;

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
            
            SELECT TurnId, EmriTurnit, OraFilluese, OraPerfundimtare, DitaId
            FROM OrariPloteStafit 
            WHERE StafId = @PersonId;
            
            REVERT;
            """,
            new { Username = GetLoggedInUsername(), PersonId = personId });

        return View(new StaffDetailsVM { Staff = staffMember, Schedule = schedules.ToList()});
    }
}
