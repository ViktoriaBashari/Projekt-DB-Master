using System.Security.Claims;
using Dapper;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;

namespace HospitalManagement.Controllers;

public abstract class BaseController : Controller
{
    protected static readonly string _dbConnectionStringName = "Database";
    protected readonly IConfiguration _configuration;
    
    protected BaseController(IConfiguration configuration)
        => _configuration = configuration;

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

        if (Convert.ToInt32(pacient.Id) > 0)
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

        if (Convert.ToInt32(pacient.Id) == 0)
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

    protected string GetLoggedInUsername()
        => User.FindFirst(ClaimTypes.NameIdentifier)!.Value;
}