using System.Data;
using System.Text.Json;
using Dapper;
using HospitalManagement.Common.Enums;
using HospitalManagement.Models.Data.Enums;
using HospitalManagement.Models.Data.Person;
using HospitalManagement.Models.ViewModels;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;

namespace HospitalManagement.Controllers;

[Authorize(Roles = nameof(Roles.Administrator))]
public class AdminController : BaseController
{
    public AdminController(IConfiguration configuration) : base(configuration) { }

    [HttpGet]
    public async Task<IActionResult> Index()
    {
        /* 
         * shiko stafin + orarin vetjak
         * shiko departamentet
         * shiko sherbimet
         * shiko turnet
         */

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

    [HttpGet]
    public async Task<IActionResult> Departments()
    {
        var connectionString = _configuration.GetConnectionString(_dbConnectionStringName);
        using var connection = new SqlConnection(connectionString);

        var departaments = await connection.QueryAsync<Departament, Staf, Person, Departament>(
            """
            EXECUTE AS USER = @Username;
            
            SELECT 
            	Departament.Id, Departament.Emri, 
            	Departament.DrejtuesId, PersonStaf.Emri, PersonStaf.Mbiemri
            FROM Departament
            LEFT JOIN Staf ON DrejtuesId = Staf.PersonId
            INNER JOIN PersonStaf ON PersonStaf.Id = Staf.PersonId;
            
            REVERT;
            """,
            (departament, staf, person) =>
            {
                departament.Drejtues = staf;

                if(staf != null)
                    departament.Drejtues.Person = person;

                return departament;
            },
            new { Username = GetLoggedInUsername() });

        return View(departaments.ToList());
    }

    //[HttpGet]
    //public async Task<IActionResult> UpsertDepartment(Departament departament)
    //{


    //    //"""
    //    //SELECT PersonId, PersonStaf.Emri, PersonStaf.Mbiemri
    //    //FROM Staf
    //    //INNER JOIN PersonStaf ON PersonStaf.Id = Staf.PersonId
    //    //INNER JOIN RolStafi ON RolStafi.Id = RolId
    //    //WHERE RolStafi.Emertimi = 'Doktor';
    //    //""";
    //    return View();
    //}

    //[HttpPost]
    //public async Task<IActionResult> UpsertDepartment(Departament departament)
    //{

    //}

    [HttpPost]
    public async Task<decimal> CancelledAppointmentsPercentage(DateOnly? beginningDate = null, DateOnly? endingDate = null)
    {
        var connectionString = _configuration.GetConnectionString(_dbConnectionStringName);

        using var connection = new SqlConnection(connectionString);
        var command = await connection.QueryMultipleAsync(
            """
                EXECUTE AS USER = @Username;
                SELECT dbo.KalkuloPerqindjenTakimeveAnulluara(@BeginningDate, @EndingDate);
                REVERT;
            """,
            new { 
                Username = GetLoggedInUsername(), 
                BeginningDate = beginningDate.HasValue ? new DateTime(beginningDate.Value, TimeOnly.MinValue) : (DateTime?)null, 
                EndingDate = endingDate.HasValue ? new DateTime(endingDate.Value, TimeOnly.MinValue) : (DateTime?)null });

        var result = await command.ReadSingleAsync<decimal>();
        await connection.CloseAsync();

        return result;
    }

    [HttpPost]
    public async Task<string> RegistrationTotals(int? beginningYear = null, int? endingYear = null, bool monthlyDistribution = false)
    {
        var connectionString = _configuration.GetConnectionString(_dbConnectionStringName);

        using var connection = new SqlConnection(connectionString);
        var command = await connection.QueryMultipleAsync(
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

        var result = (await command.ReadAsync<Dictionary<string, object>>()).ToList();
        await connection.CloseAsync();

        return JsonSerializer.Serialize(result);
    }

    [HttpPost]
    public async Task<decimal> YearlyCosts(int year)
    {
        var connectionString = _configuration.GetConnectionString(_dbConnectionStringName);

        using var connection = new SqlConnection(connectionString);
        var command = await connection.QueryMultipleAsync(
            """
                EXECUTE AS USER = @Username;
                SELECT dbo.GjeneroShpenzimetVjetore(@Year);
                REVERT;
            """,
            new { Username = GetLoggedInUsername(), Year = year });

        var result = await command.ReadSingleAsync<decimal>();
        await connection.CloseAsync();

        return result;
    }

    [HttpPost]
    public async Task<string> EarningsReport(int? beginningYear = null, int? endingYear = null, bool monthlyDistribution = false)
    {
        var connectionString = _configuration.GetConnectionString(_dbConnectionStringName);

        using var connection = new SqlConnection(connectionString);
        var command = await connection.QueryMultipleAsync(
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

        var result = (await command.ReadAsync<Dictionary<string, object>>()).ToList();
        await connection.CloseAsync();

        return JsonSerializer.Serialize(result);
    }

    [HttpPost]
    public async Task<decimal> YearlyOperatingMargin(int year)
    {
        var connectionString = _configuration.GetConnectionString(_dbConnectionStringName);

        using var connection = new SqlConnection(connectionString);
        var command = await connection.QueryMultipleAsync(
            """
                EXECUTE AS USER = @Username;
                SELECT dbo.GjeneroOperatingMarginVjetor(@Year);
                REVERT;
            """,
            new { Username = GetLoggedInUsername(), Year = year });

        var result = await command.ReadSingleAsync<decimal>();
        await connection.CloseAsync();

        return result;
    }

    [HttpPost]
    public async Task<decimal> YearlyAverageTreatmentCharge(int? beginningYear = null, int? endingYear = null)
    {
        var connectionString = _configuration.GetConnectionString(_dbConnectionStringName);

        using var connection = new SqlConnection(connectionString);
        var command = await connection.QueryMultipleAsync(
            """
                EXECUTE AS USER = @Username;
                SELECT dbo.KalkuloTarifenMesatareVjetoreTeTrajtimit(@BeginningYear, @EndingYear);
                REVERT;
            """,
            new { Username = GetLoggedInUsername(), BeginningYear = beginningYear, EndingYear = endingYear });

        var result = await command.ReadSingleAsync<decimal>();
        await connection.CloseAsync();

        return result;
    }

    [HttpPost]
    public async Task<string> MonthlyAverageTreatmentCharge(int? beginningYear = null, int? endingYear = null, bool monthlyDistribution = false)
    {
        var connectionString = _configuration.GetConnectionString(_dbConnectionStringName);

        using var connection = new SqlConnection(connectionString);
        var command = await connection.QueryMultipleAsync(
            """
                EXECUTE AS USER = @Username;
                SELECT * FROM dbo.KalkuloTarifenMesatareMujoreTeTrajtimit(@BeginningYear, @EndingYear);
                REVERT;
            """,
            new { Username = GetLoggedInUsername(), BeginningYear = beginningYear, EndingYear = endingYear });

        var result = (await command.ReadAsync<Dictionary<string, object>>()).ToList();
        await connection.CloseAsync();

        return JsonSerializer.Serialize(result);
    }

    [HttpPost]
    public async Task<string> MostUsedStaffMembers(int? year = null, int? roleId = null, bool monthlyDistribution = false)
    {
        var connectionString = _configuration.GetConnectionString(_dbConnectionStringName);

        using var connection = new SqlConnection(connectionString);
        var command = await connection.QueryMultipleAsync(
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

        var result = (await command.ReadAsync<Dictionary<string, object>>()).ToList();
        await connection.CloseAsync();

        return JsonSerializer.Serialize(result);
    }

    [HttpPost]
    public async Task<string> MostPopularTreatments(int? year = null, bool monthlyDistribution = false)
    {
        var connectionString = _configuration.GetConnectionString(_dbConnectionStringName);

        using var connection = new SqlConnection(connectionString);
        var command = await connection.QueryMultipleAsync(
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

        var result = (await command.ReadAsync<Dictionary<string, object>>()).ToList();
        await connection.CloseAsync();

        return JsonSerializer.Serialize(result);
    }

    //public async Task<IEnumerable<Staf>> MedicalStaff(string? filterByRole = null, string? searchByName = null)
    //{
    //    var connectionString = _configuration.GetConnectionString(_dbConnectionStringName);
    //    using var connection = new SqlConnection(connectionString);

    //    //execute as 

    //    string getStaffQuery = """
    //        EXECUTE AS USER = @Username;

    //        SELECT 
    //            Id, Emri, Mbiemri, Datelindja, NrTelefoni, Gjinia,
    //            PunonjesId, 
    //            rol.Id, rol.Emertimi
    //            Departament.Id, Departament.Emri
    //        FROM Staf
    //        INNER JOIN Person ON Staf.PersonId = Person.Id
    //        INNER JOIN Gjinia ON Person.GjiniaId = Gjinia.Id
    //        INNER JOIN Departament ON Departament.Id = Staf.DepartamentId
    //        INNER JOIN RolStafi AS rol ON rol.Id = Staf.RolId;

    //        REVERT;
    //    """;

    //    var staffResult = await connection.QueryAsync<Staf, Person, Gjinia, Departament, RolStafi, Staf>(
    //        getStaffQuery,
    //        (staff, person, gender, dep, role) =>
    //        {
    //            staff.Person = person;
    //            person.Gjinia = gender;
    //            staff.Departament = dep;
    //            staff.Rol = role;

    //            return staff;
    //        },
    //        new { Username = GetLoggedInUsername() });

    //    return staffResult;
    //}
}
