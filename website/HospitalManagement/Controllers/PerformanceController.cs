using Dapper;
using HospitalManagement.Common;
using HospitalManagement.Common.Enums;
using HospitalManagement.Models.Data.Enums;
using HospitalManagement.Models.ViewModels;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
namespace HospitalManagement.Controllers;

[Authorize(Roles = nameof(Roles.Administrator))]
public class PerformanceController : BaseController
{
    public PerformanceController(IConfiguration configuration) : base(configuration) { }

    [HttpGet]
    public async Task<IActionResult> Index()
    {
        var connectionString = _configuration.GetConnectionString(_dbConnectionStringName);
        using var connection = new SqlConnection(connectionString);

        var performanceIndicators = await connection.QueryMultipleAsync(
            """
            EXECUTE AS USER = @Username;

            SELECT * FROM RolStafi;
            SELECT dbo.GjeneroRaportinStafKerkese();
            SELECT dbo.KalkuloNormenMesatareTePritjesPerTakim();

            REVERT;
            """,
            new
            {
                Username = GetLoggedInUsername(),
                FirstDayCurrentYear = $"{DateTime.Today.Year}-01-01",
                CurrentYear = DateTime.Today.Year,
                CurrentMonth = DateTime.Today.Month,
            });

        ViewBag.StaffRoles = (await performanceIndicators.ReadAsync<RolStafi>()).ToArray();

        var model = new PerformanceIndicatorsVM()
        {
            StaffPatientRaport = await performanceIndicators.ReadSingleAsync<decimal>(),
            PatientMeetingWaitingTimeNorm = await performanceIndicators.ReadSingleAsync<decimal>(),
        };

        await connection.CloseAsync();
        return View(model);
    }

    [HttpPost]
    public async Task<IActionResult> CancelledAppointmentsPercentage(DateOnly? beginningDate = null, DateOnly? endingDate = null)
    {
        var connectionString = _configuration.GetConnectionString(_dbConnectionStringName);
        using var connection = new SqlConnection(connectionString);

        var result = await connection.ExecuteScalarAsync<decimal>(
            """
                EXECUTE AS USER = @Username;
                SELECT dbo.KalkuloPerqindjenTakimeveAnulluara(@BeginningDate, @EndingDate);
                REVERT;
            """,
            new
            {
                Username = GetLoggedInUsername(),
                BeginningDate = beginningDate.HasValue ? new DateTime(beginningDate.Value, TimeOnly.MinValue) : (DateTime?)null,
                EndingDate = endingDate.HasValue ? new DateTime(endingDate.Value, TimeOnly.MinValue) : (DateTime?)null
            });

        await connection.CloseAsync();
        return Ok(result);
    }

    [HttpPost]
    public async Task<IActionResult> RegistrationTotals(int? beginningYear = null, int? endingYear = null, bool monthlyDistribution = false)
    {
        var connectionString = _configuration.GetConnectionString(_dbConnectionStringName);
        using var connection = new SqlConnection(connectionString);

        var result = await connection.QueryAsync(
            () => new { Viti = default(int), Muaji = default(int), NrPacienteve = default(int) },
            """
                EXECUTE AS USER = @Username;
                EXEC dbo.GjeneroFluksinRegjistrimeveTePacienteve @BeginningYear, @EndingYear, @MonthlyDistribution;
                REVERT;
            """,
            new
            {
                Username = GetLoggedInUsername(),
                BeginningYear = beginningYear,
                EndingYear = endingYear,
                MonthlyDistribution = monthlyDistribution ? 1 : 0
            });

        await connection.CloseAsync();
        return Ok(result);
    }

    [HttpPost]
    public async Task<IActionResult> YearlyCosts(int year)
    {
        var connectionString = _configuration.GetConnectionString(_dbConnectionStringName);
        using var connection = new SqlConnection(connectionString);

        var result = await connection.ExecuteScalarAsync<decimal>(
            """
                EXECUTE AS USER = @Username;
                SELECT dbo.GjeneroShpenzimetVjetore(@Year);
                REVERT;
            """,
            new { Username = GetLoggedInUsername(), Year = year });

        await connection.CloseAsync();
        return Ok(result);
    }

    [HttpPost]
    public async Task<IActionResult> EarningsReport(int? beginningYear = null, int? endingYear = null, bool monthlyDistribution = false)
    {
        var connectionString = _configuration.GetConnectionString(_dbConnectionStringName);
        using var connection = new SqlConnection(connectionString);

        var result = await connection.QueryAsync(
            () => new { Viti = default(int), Muaji = default(int), FitimeFature = default(decimal) },
            """
                EXECUTE AS USER = @Username;
                SELECT * FROM dbo.GjeneroRaportFitimesh(@BeginningYear, @EndingYear, @MonthlyDistribution);
                REVERT;
            """,
            new
            {
                Username = GetLoggedInUsername(),
                BeginningYear = beginningYear,
                EndingYear = endingYear,
                MonthlyDistribution = monthlyDistribution ? 1 : 0
            });

        await connection.CloseAsync();
        return Ok(result);
    }

    [HttpPost]
    public async Task<IActionResult> YearlyOperatingMargin(int year)
    {
        var connectionString = _configuration.GetConnectionString(_dbConnectionStringName);
        using var connection = new SqlConnection(connectionString);

        var result = await connection.ExecuteScalarAsync<decimal>(
            """
                EXECUTE AS USER = @Username;
                SELECT dbo.GjeneroOperatingMarginVjetor(@Year);
                REVERT;
            """,
            new { Username = GetLoggedInUsername(), Year = year });

        await connection.CloseAsync();
        return Ok(result);
    }

    [HttpPost]
    public async Task<IActionResult> YearlyAverageTreatmentCharge(int? beginningYear = null, int? endingYear = null)
    {
        var connectionString = _configuration.GetConnectionString(_dbConnectionStringName);
        using var connection = new SqlConnection(connectionString);

        var result = await connection.ExecuteScalarAsync<decimal>(
            """
                EXECUTE AS USER = @Username;
                SELECT dbo.KalkuloTarifenMesatareVjetoreTeTrajtimit(@BeginningYear, @EndingYear);
                REVERT;
            """,
            new { Username = GetLoggedInUsername(), BeginningYear = beginningYear, EndingYear = endingYear });

        await connection.CloseAsync();
        return Ok(result);
    }

    [HttpPost]
    public async Task<IActionResult> MonthlyAverageTreatmentCharge(int? beginningYear = null, int? endingYear = null)
    {
        var connectionString = _configuration.GetConnectionString(_dbConnectionStringName);
        using var connection = new SqlConnection(connectionString);

        var result = await connection.QueryAsync(
            () => new { Viti = default(int), Muaji = default(int), TarifaMesatareTrajtimit = default(decimal) },
            """
                EXECUTE AS USER = @Username;
                SELECT * FROM dbo.KalkuloTarifenMesatareMujoreTeTrajtimit(@BeginningYear, @EndingYear);
                REVERT;
            """,
            new { Username = GetLoggedInUsername(), BeginningYear = beginningYear, EndingYear = endingYear });

        await connection.CloseAsync();
        return Ok(result);
    }

    [HttpPost]
    public async Task<IActionResult> MostUsedStaffMembers(int roleId, int? year = null, bool monthlyDistribution = false)
    {
        var connectionString = _configuration.GetConnectionString(_dbConnectionStringName);
        using var connection = new SqlConnection(connectionString);

        var result = await connection.QueryAsync(
            () => new { Id = default(int), Emri = default(string), Mbiemri = default(string), NrTakimeve = default(int) },
            """
                EXECUTE AS USER = @Username;
                EXEC dbo.GjeneroStafinMeTePerdorur @MonthlyDistribution, @RoleId, @Year;
                REVERT;
            """,
            new
            {
                Username = GetLoggedInUsername(),
                Year = year,
                RoleId = roleId,
                MonthlyDistribution = monthlyDistribution ? 1 : 0
            });

        await connection.CloseAsync();
        return Ok(result);
    }

    [HttpPost]
    public async Task<IActionResult> MostPopularTreatments(int? year = null, bool monthlyDistribution = false)
    {
        var connectionString = _configuration.GetConnectionString(_dbConnectionStringName);
        using var connection = new SqlConnection(connectionString);

        var result = await connection.QueryAsync(
            () => new
            {
                Viti = default(int),
                Muaji = default(int),
                Kodi = default(string),
                Emri = default(string),
                NrTakimeve = default(int)
            },
            """
                EXECUTE AS USER = @Username;
                EXEC dbo.GjeneroProceduratMeTePerdorura @MonthlyDistribution, @Year;
                REVERT;
            """,
            new
            {
                Username = GetLoggedInUsername(),
                Year = year,
                MonthlyDistribution = monthlyDistribution ? 1 : 0
            });

        await connection.CloseAsync();
        return Ok(result);
    }
}
