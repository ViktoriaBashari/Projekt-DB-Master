using Dapper;
using HospitalManagement.Common.Enums;
using HospitalManagement.Models.Data;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;

namespace HospitalManagement.Controllers;

[Authorize(Roles = nameof(Roles.Infermier) + "," + nameof(Roles.Doktor))]
public class AppointmentsController : BaseController
{
    public AppointmentsController(IConfiguration configuration) : base(configuration) { }

    public IActionResult Index()
    {
        return View();
    }

    public async Task<IActionResult> Details(int id)
    {
        var connectionString = _configuration.GetConnectionString(_dbConnectionStringName);
        using var connection = new SqlConnection(connectionString);

        var appointment = await connection.QuerySingleOrDefaultAsync<Appointment>(
            """
            EXECUTE AS USER = @Username;

            SELECT * 
            FROM TakimDetajuar
            WHERE Id = @AppointmentId;

            REVERT;
            """,
            new { Username = GetLoggedInUsername(), AppointmentId = id });

        return View(appointment);
    }

    [HttpGet]
    public async Task<IActionResult> AppointmentsBelongingToStaf(DateTime startingDate, DateTime endDate)
    {
        var connectionString = _configuration.GetConnectionString(_dbConnectionStringName);
        using var connection = new SqlConnection(connectionString);

        var appointments = await connection.QueryAsync<AppointmentSummary>(
            """
            EXECUTE AS USER = @Username;
            
            EXEC dbo.SelektoTakimetStafit @StartingDate, @EndDate;

            REVERT;
            """,
            new { Username = GetLoggedInUsername(), StartingDate = startingDate, EndDate = endDate });

        return Ok(appointments.ToList());
    }

}
