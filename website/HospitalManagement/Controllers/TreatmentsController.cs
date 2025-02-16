using Dapper;
using HospitalManagement.Models.Data;
using HospitalManagement.Models.ViewModels;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;

namespace HospitalManagement.Controllers;

public class TreatmentsController : BaseController
{
    public TreatmentsController(IConfiguration configuration) : base(configuration) { }

    public async Task<IActionResult> Index(int page = 0, int size = 10)
    {
        var connectionString = _configuration.GetConnectionString(_dbConnectionStringName);
        using var connection = new SqlConnection(connectionString);

        var result = await connection.QueryMultipleAsync(
            """
            EXECUTE AS USER = @Username;
            
            SELECT * 
            FROM Sherbim
            ORDER BY Kodi
            OFFSET @Offset ROWS FETCH NEXT @Limit ROWS ONLY;
            
            SELECT 
            CASE WHEN EXISTS(
            	SELECT 1 
            	FROM Sherbim
            	ORDER BY Kodi
            	OFFSET (@Offset + @Limit) ROWS)
            THEN 1 
            ELSE 0 END
            AS EkzistonFaqeTjeter;
            
            REVERT;
            """,
            new { Username = GetLoggedInUsername(), Offset = page * size, Limit = size });

        var treatments = await result.ReadAsync<Treatment>();
        ViewBag.HasNextPage = (await result.ReadSingleAsync<int>()) == 1;

        return View(treatments.ToList());
    }

    [HttpGet]
    public async Task<IActionResult> Upsert(string? code = null)
    {
        var treatment = new UpsertTreatmentVM { Treatment = new() };

        if (code != null)
        {
            var connectionString = _configuration.GetConnectionString(_dbConnectionStringName);
            using var connection = new SqlConnection(connectionString);

            var existingTreatment = await connection.QueryFirstOrDefaultAsync<Treatment>(
                """
                EXECUTE AS USER = @Username;
                SELECT * FROM Sherbim WHERE Kodi = @ExistingTreatmentId;
                REVERT;
                """,
                new { Username = GetLoggedInUsername(), ExistingTreatmentId = code });

            if (existingTreatment == null)
                return RedirectToAction(nameof(Index));

            treatment.TreatmentToBeUpdatedCode = code;
            treatment.Treatment = existingTreatment;
        }

        return View(treatment);
    }

    [HttpDelete]
    public async Task<IActionResult> Delete(string code)
    {
        var connectionString = _configuration.GetConnectionString(_dbConnectionStringName);
        using var connection = new SqlConnection(connectionString);

        // Verifiko qe sherbimi ekziston
        var existingTreatment = await connection.QueryFirstOrDefaultAsync(
            """
            EXECUTE AS USER = @Username;
            SELECT 1 FROM Sherbim WHERE Kodi = @Code;
            REVERT;
            """,
            new { Username = GetLoggedInUsername(), Code = code });

        if(existingTreatment == null) 
            return NotFound();

        // Kontrollo qe sherbimi nuk eshte perdour
        var existingAppointmentRelation = await connection.QueryFirstOrDefaultAsync(
            """
            EXECUTE AS USER = @Username;
            SELECT 1 FROM Takim WHERE SherbimId = @Code;
            REVERT;
            """,
            new { Username = GetLoggedInUsername(), Code = code });

        if (existingAppointmentRelation != null)
            return BadRequest("Sherbimi eshte i perdour ne takime te regjistruara");

        // Fshi sherbimin
        await connection.ExecuteAsync(
            """
            EXECUTE AS USER = @Username;
            DELETE FROM Sherbim WHERE Kodi = @Code;
            REVERT;
            """,
            new { Username = GetLoggedInUsername(), Code = code });

        return NoContent();
    }

    [HttpPost]
    public async Task<IActionResult> Upsert(UpsertTreatmentVM upsertTreatment)
    {
        if (!ModelState.IsValid)
            return View(upsertTreatment);

        var connectionString = _configuration.GetConnectionString(_dbConnectionStringName);
        using var connection = new SqlConnection(connectionString);

        // Valido sherbimi ekziston ne rast perditesimi
        if (upsertTreatment.TreatmentToBeUpdatedCode != null)
        {
            var existingTreatmentCode = await connection.QuerySingleOrDefaultAsync(
                """
                EXECUTE AS USER = @Username;
                SELECT 1 FROM Sherbim WHERE Kodi = @ExistingTreatmentId;
                REVERT;
                """,
                new { Username = GetLoggedInUsername(), ExistingTreatmentId = upsertTreatment.TreatmentToBeUpdatedCode });

            if (existingTreatmentCode == null)
                return RedirectToAction(nameof(Index));
        }

        // Valido kodi i ri eshte unik
        if (upsertTreatment.TreatmentToBeUpdatedCode == null || upsertTreatment.TreatmentToBeUpdatedCode != upsertTreatment.Treatment.Kodi)
        {
            var existingTreatment = await connection.QuerySingleOrDefaultAsync(
                """
                EXECUTE AS USER = @Username;
                SELECT 1 FROM Sherbim WHERE Kodi = @TreatmentId;
                REVERT;
                """,
                new { Username = GetLoggedInUsername(), TreatmentId = upsertTreatment.Treatment.Kodi });

            if (existingTreatment != null)
            {
                ModelState.AddModelError(nameof(UpsertTreatmentVM.Treatment.Kodi), "Kodi duhet te jete unik");
                return View(upsertTreatment);
            }
        }

        // Valido emri eshte unik
        var existingName = await connection.QuerySingleOrDefaultAsync(
            $$"""
            EXECUTE AS USER = @Username;
            SELECT 1 FROM Sherbim WHERE Emri = @TreatmentName {{(upsertTreatment.TreatmentToBeUpdatedCode != null ? "AND Kodi != @TreatmentId" : "")}};
            REVERT;
            """,
            new { 
                Username = GetLoggedInUsername(), 
                TreatmentName = upsertTreatment.Treatment.Emri, 
                TreatmentId = upsertTreatment.TreatmentToBeUpdatedCode 
            });

        if (existingName != null)
        {
            ModelState.AddModelError(nameof(UpsertTreatmentVM.Treatment.Emri), "Emri duhet te jete unik");
            return View(upsertTreatment);
        }

        // Shto / perditeso
        if (upsertTreatment.TreatmentToBeUpdatedCode == null)
            await connection.ExecuteAsync(
                """
                EXECUTE AS USER = @Username;
                INSERT INTO Sherbim (Kodi, Emri, Pershkrimi, Cmimi) VALUES (@Code, @Name, @Description, @Price);
                REVERT;
                """,
                new
                {
                    Username = GetLoggedInUsername(),
                    Code = upsertTreatment.Treatment.Kodi,
                    Name = upsertTreatment.Treatment.Emri,
                    Description = upsertTreatment.Treatment.Pershkrimi,
                    Price = upsertTreatment.Treatment.Cmimi
                });
        else
            await connection.ExecuteAsync(
                """
                EXECUTE AS USER = @Username;

                UPDATE Sherbim 
                SET Kodi = @Code, Emri = @Name, Pershkrimi = @Description, Cmimi = @Price
                WHERE Kodi = @ExistingId;
                
                REVERT;
                """,
                new
                {
                    Username = GetLoggedInUsername(),
                    Code = upsertTreatment.Treatment.Kodi,
                    Name = upsertTreatment.Treatment.Emri,
                    Description = upsertTreatment.Treatment.Pershkrimi,
                    Price = upsertTreatment.Treatment.Cmimi,
                    ExistingId = upsertTreatment.TreatmentToBeUpdatedCode
                });

        return RedirectToAction(nameof(Index));
    }
}
