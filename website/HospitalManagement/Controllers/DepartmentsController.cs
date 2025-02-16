using Dapper;
using HospitalManagement.Common;
using HospitalManagement.Common.Enums;
using HospitalManagement.Models.Data;
using HospitalManagement.Models.ViewModels;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;

namespace HospitalManagement.Controllers;

[Authorize(Roles = nameof(Roles.Administrator))]
public class DepartmentsController : BaseController
{
    public DepartmentsController(IConfiguration configuration) : base(configuration) { }

    [HttpGet]
    public async Task<IActionResult> Index(int page = 0, int size = 10)
    {
        var connectionString = _configuration.GetConnectionString(_dbConnectionStringName);
        using var connection = new SqlConnection(connectionString);

        var result = await connection.QueryMultipleAsync(
            """
            EXECUTE AS USER = @Username;
            
            SELECT * 
            FROM InformacionDepartament
            ORDER BY Id
            OFFSET @Offset ROWS FETCH NEXT @Limit ROWS ONLY;
            
            SELECT 
            CASE WHEN EXISTS(
            	SELECT 1 
            	FROM InformacionDepartament
            	ORDER BY Id
            	OFFSET (@Offset + @Limit) ROWS)
            THEN 1 
            ELSE 0 END
            AS EkzistonFaqeTjeter;

            REVERT;
            """,
            new { Username = GetLoggedInUsername(), Offset = page * size, Limit = size });

        var departments = await result.ReadAsync<Department>();
        ViewBag.HasNextPage = (await result.ReadSingleAsync<int>()) == 1;

        await connection.CloseAsync();
        return View(departments.ToList());
    }

    [HttpDelete]
    public async Task<IActionResult> DeleteDepartment(DeleteDepartmentVM deleteDepartment)
    {
        if (deleteDepartment.DeletedDepartmentId == deleteDepartment.ReplacementDepartmentId)
            return BadRequest("Departamenti zevendesues duhet te jete i ndryshem nga ai qe po fshihet");

        var connectionString = _configuration.GetConnectionString(_dbConnectionStringName);
        using var connection = new SqlConnection(connectionString);

        // Verifiko qe departamenti per t'u fshire ekziston
        var existingDepartment = await connection.QuerySingleOrDefaultAsync(
                """
                EXECUTE AS USER = @Username;
                SELECT 1 FROM Departament WHERE Id = @DeletedDepartmentId;
                REVERT;
                """,
                new { Username = GetLoggedInUsername(), deleteDepartment.DeletedDepartmentId });

        if (existingDepartment == null)
            return NotFound();

        // Verifiko qe departamenti zevendesues (per stafin) ekziston
        var existingReplacementDepartment = await connection.QuerySingleOrDefaultAsync(
                """
                EXECUTE AS USER = @Username;
                SELECT 1 FROM Departament WHERE Id = @ReplacementDepartmentId;
                REVERT;
                """,
                new { Username = GetLoggedInUsername(), deleteDepartment.ReplacementDepartmentId });

        if (existingReplacementDepartment == null)
            return NotFound();

        // Fshi departamentin
        await connection.ExecuteAsync(
            """
            EXECUTE AS USER = @Username;
            EXEC dbo.FshiDepartament @DeletedDepartmentId, @ReplacementDepartmentId;
            REVERT;
            """,
            new { 
                Username = GetLoggedInUsername(), 
                deleteDepartment.DeletedDepartmentId,
                deleteDepartment.ReplacementDepartmentId
            });

        return NoContent();
    }

    [HttpGet]
    public async Task<IActionResult> Upsert(int? id = null)
    {
        ViewBag.LeaderPossibilities = await GetDepartmentLeaderPossibilities();

        if (id.HasValue && id.Value > 0)
        {
            var connectionString = _configuration.GetConnectionString(_dbConnectionStringName);
            using var connection = new SqlConnection(connectionString);
            
            var existingDepartment = await connection.QuerySingleOrDefaultAsync<Department>(
                """
                EXECUTE AS USER = @Username;
                SELECT * FROM InformacionDepartament WHERE Id = @DepartmentId;
                REVERT;
                """,
                new { Username = GetLoggedInUsername(), DepartmentId = id.Value });

            return View(existingDepartment);
        }

        return View(new Department { Id = 0, Emri = string.Empty });
    }

    [HttpPost]
    public async Task<IActionResult> Upsert(Department department)
    {
        if (!ModelState.IsValid)
        {
            ViewBag.LeaderPossibilities = await GetDepartmentLeaderPossibilities();
            return View(department);
        }

        Department? existingDepartment = null;
        
        var connectionString = _configuration.GetConnectionString(_dbConnectionStringName);
        using var connection = new SqlConnection(connectionString);

        // Valido departamentin nese po perditesohet
        if(department.Id > 0)
        {
            existingDepartment = await connection.QuerySingleOrDefaultAsync<Department>(
                """
                EXECUTE AS USER = @Username;
                SELECT * FROM InformacionDepartament WHERE Id = @DepartmentId
                REVERT;
                """,
                new { Username = GetLoggedInUsername(), DepartmentId = department.Id });

            if (existingDepartment == null)
            {
                ModelState.AddModelError(string.Empty, "Departamenti nuk u gjet, provoni perseri me vone");
                ViewBag.LeaderPossibilities = await GetDepartmentLeaderPossibilities();

                return View(department);
            }

            department.DrejtuesEmri = existingDepartment.DrejtuesEmri;
            department.DrejtuesMbiemri = existingDepartment.DrejtuesMbiemri;
        }

        // Valido emri i departamentit eshte unik
        if(department.Id <= 0 || (existingDepartment != null && existingDepartment.Emri != department.Emri))
        {
            var existingDepartmentName = await connection.QuerySingleOrDefaultAsync(
                """
                EXECUTE AS USER = @Username;
                SELECT Emri FROM Departament WHERE Emri = @DepartmentName
                REVERT;
                """,
                new { Username = GetLoggedInUsername(), DepartmentName = department.Emri });

            if (existingDepartmentName != null)
            {
                ModelState.AddModelError(nameof(Department.Emri), "Emri i departamentit duhet te jete unik");
                ViewBag.LeaderPossibilities = await GetDepartmentLeaderPossibilities();

                return View(department);
            }
        }

        if (department.DrejtuesId.HasValue && department.DrejtuesId > 0 &&
            (existingDepartment == null || existingDepartment.DrejtuesId != department.DrejtuesId))
        {
            var existingNonleaderStaff = await connection.QuerySingleOrDefaultAsync(
                """
                EXECUTE AS USER = @Username;

                SELECT 1
                FROM Staf
                INNER JOIN PersonStaf ON PersonStaf.Id = Staf.PersonId
                LEFT JOIN Departament ON Departament.DrejtuesId = Staf.PersonId
                WHERE Departament.DrejtuesId IS NULL AND Staf.PersonId = @NewLeaderId
            
                REVERT;
                """,
                new { Username = GetLoggedInUsername(), NewLeaderId = department.DrejtuesId });

            if (existingNonleaderStaff == null)
            {
                ModelState.AddModelError(nameof(Department.DrejtuesId), "Drejtuesi nuk u gjet, provoni perseri me vone");
                ViewBag.LeaderPossibilities = await GetDepartmentLeaderPossibilities();

                return View(department);
            }

            department.DrejtuesEmri = existingNonleaderStaff.LeaderName;
            department.DrejtuesMbiemri = existingNonleaderStaff.LeaderSurname;
        }

        // Perditeso ose shto departamentin
        if (department.Id == 0)
        {
            var newDepartmentId = await connection.ExecuteScalarAsync<int>(
                """
                EXECUTE AS USER = @Username;
                
                INSERT INTO Departament (Emri, DrejtuesId)
                VALUES (@DepartmentName, @DrejtuesId);

                SELECT SCOPE_IDENTITY();

                REVERT;
                """,
                new { 
                    Username = GetLoggedInUsername(), 
                    DepartmentName = department.Emri,
                    DrejtuesId = department.DrejtuesId == 0 ? null : department.DrejtuesId
                });

            department.Id = newDepartmentId;
        }
        else
        {
            await connection.ExecuteAsync(
                """
                EXECUTE AS USER = @Username;

                UPDATE Departament 
                SET Emri = @NewName, DrejtuesId = @NewLeaderId
                WHERE Id = @DepartmentId;

                REVERT;
                """,
                new
                {
                    Username = GetLoggedInUsername(),
                    NewName = department.Emri,
                    NewLeaderId = department.DrejtuesId == 0 ? null : department.DrejtuesId,
                    DepartmentId = department.Id
                });
        }

        return RedirectToAction(nameof(Index));
    }

    [HttpGet]
    public async Task<IActionResult> DepartmentPossibilities(int excludeDepartmentId)
    {
        var connectionString = _configuration.GetConnectionString(_dbConnectionStringName);
        using var connection = new SqlConnection(connectionString);

        var departments = await connection.QueryAsync(
            () => new { Id = default(int), Emri = default(string) },
            """
            EXECUTE AS USER = @Username;
            SELECT Id, Emri FROM Departament WHERE Id != @ExcludeDepartmentId
            REVERT;
            """,
            new { Username = GetLoggedInUsername(), ExcludeDepartmentId = excludeDepartmentId });

        await connection.CloseAsync();
        return Ok(departments);
    }

    private async Task<IList<(int PersonId, string Emri, string Mbiemri)>> GetDepartmentLeaderPossibilities()
    {
        var connectionString = _configuration.GetConnectionString(_dbConnectionStringName);
        using var connection = new SqlConnection(connectionString);

        // Merr gjithe doktoret qe nuk jane drejtues te nje departamenti
        var leaders = await connection.QueryAsync<(int PersonId, string Emri, string Mbiemri)>(
            """
            EXECUTE AS USER = @Username;

            SELECT Staf.PersonId, PersonStaf.Emri, PersonStaf.Mbiemri
            FROM Staf
            INNER JOIN PersonStaf ON PersonStaf.Id = staf.PersonId
            LEFT JOIN Departament ON Departament.DrejtuesId = staf.PersonId
            INNER JOIN RolStafi ON RolStafi.Id = Staf.RolId
            WHERE Departament.DrejtuesId IS NULL AND RolStafi.Emertimi = 'Doktor';

            REVERT;
            """,
            new { Username = GetLoggedInUsername() });

        return leaders.ToList();
    }
}
