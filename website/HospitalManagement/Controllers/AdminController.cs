using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;

namespace HospitalManagement.Controllers;

[Authorize]
public class AdminController : BaseController
{
    public AdminController(IConfiguration configuration): base(configuration) { }

    // Admin
    public async Task<IActionResult> Index()
    {
        /*
         * ndarjet madhor me tabs
         * nenndarjet me scrollspy
         * 
         * shpenzimet + fitimet
         * 
         * performanca spitalit
         * 
         * shiko stafin + orarin vetjak
         * shiko departamentet
         * shiko sherbimet
         * shiko turnet
         */

        var connectionString = _configuration.GetConnectionString(_dbConnectionStringName);
        using var connection = new SqlConnection(connectionString);

        string performanceIndicatersQuery = """
            EXECUTE AS @Username;

            SELECT dbo.GjeneroRaportinStafKerkese();
            SELECT dbo.KalkuloNormenMesatareTePritjesPerTakim();
            SELECT dbo.KalkuloPerqindjenTakimeveAnulluara(@FirstDayCurrentYear, NULL);
            
            SELECT dbo.GjeneroFluksinRegjistrimeveTePacienteve(@CurrentYear, NULL, 1);
            SELECT dbo.GjeneroShpenzimetVjetore(@CurrentYear);
            SELECT dbo.GjeneroRaportFitimesh(@CurrentYear, NULL, 1);
            SELECT dbo.GjeneroOperatingMarginVjetor(@CurrentYear);

            SELECT dbo.KalkuloTarifenMesatareVjetoreTeTrajtimit(@CurrentYear, NULL);
            SELECT dbo.KalkuloTarifenMesatareMujoreTeTrajtimit(@CurrentYear, NULL);

            SELECT dbo.GjeneroStafinMeTePerdorur(0, NULL, @CurrentYear);
            SELECT dbo.GjeneroProceduratMeTePerdorura(1, @CurrentYear);
            SELECT dbo.GjeneroPacientetMeTeShpeshte(@CurrentYear, @CurrentMonth);

            REVERT;
        """;

        //var performanceIndicators = await connection.QueryMultipleAsync(
        //    performanceIndicatersQuery,
        //    new { 
        //        Username = GetLoggedInUsername(), 
        //        FirstDayCurrentYear = $"{DateTime.Today.Year}-01-01",
        //        CurrentYear = DateTime.Today.Year,
        //        CurrentMonth = DateTime.Today.Month,
        //    });

        //PerformanceIndicatorsVM model = new()
        //{
        //    StaffPatientRaport = await performanceIndicators.ReadSingleAsync(),
        //    PatientMeetingWaitingTimeNorm = await performanceIndicators.ReadSingleAsync(),
        //    CancelledMeetingPercentage = await performanceIndicators.ReadSingleAsync(),

        //};

        return View();
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
