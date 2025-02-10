using System.Diagnostics;
using System.Security.Claims;
using Dapper;
using HospitalManagement.Common.Enums;
using HospitalManagement.Models;
using HospitalManagement.Models.ViewModels;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;

namespace HospitalManagement.Controllers
{
    public class HomeController : BaseController
    {
        public HomeController(IConfiguration configuration) : base(configuration) { }

        [HttpGet]
        public IActionResult Login()
        {
            return View(new LoginVM());
        }

        [HttpPost]
        public async Task<IActionResult> Login(LoginVM loginCredentials)
        {
            if (!ModelState.IsValid)
                return View(loginCredentials);

            var connectionString = _configuration.GetConnectionString(_dbConnectionStringName);
            using var connection = new SqlConnection(connectionString);

            // Verify credentials
            var areCredentialsCorrect = await connection.ExecuteScalarAsync<bool>(
                "SELECT dbo.VerifikoFjalekaliminPerdoruesit(@Username, @Password)", 
                new { loginCredentials.Username, loginCredentials.Password });

            if (!areCredentialsCorrect) 
            {
                ModelState.AddModelError(string.Empty, "Emer dhe/ose fjalekalim i pasakte");
                return View(loginCredentials);
            }

            // Create auth cookie
            var userRole = await connection.ExecuteScalarAsync<string>(
                "SELECT dbo.MerrRolinPerdoruesit(@Username)", 
                new { loginCredentials.Username });

            var claims = new List<Claim>
            {
                new Claim(ClaimTypes.NameIdentifier, loginCredentials.Username),
                new Claim(ClaimTypes.Role, userRole)
            };

            var claimsIdentity = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme);

            await HttpContext.SignInAsync(
                CookieAuthenticationDefaults.AuthenticationScheme,
                new ClaimsPrincipal(claimsIdentity),
                new AuthenticationProperties());

            return RedirectToAction(nameof(Index));
        }

        [Authorize]
        public async Task<IActionResult> Logout()
        {
            await HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);
            return RedirectToAction(nameof(Login));
        }

        public IActionResult Index()
        {
            if (!User.Identity.IsAuthenticated)
                return RedirectToAction(nameof(Login));

            // If user has auth cookie, show different dashboard based on role
            switch(User.FindFirst(ClaimTypes.Role)!.Value)
            {
                case nameof(Roles.Administrator): 
                    return RedirectToAction(nameof(PerformanceController.Index), "Performance");
                default:
                    return RedirectToAction(nameof(Logout));
            }
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
