using System.Security.Claims;
using Microsoft.AspNetCore.Mvc;

namespace HospitalManagement.Controllers;

public abstract class BaseController : Controller
{
    protected static readonly string _dbConnectionStringName = "Database";
    protected readonly IConfiguration _configuration;
    
    protected BaseController(IConfiguration configuration)
        => _configuration = configuration;

    protected string GetLoggedInUsername()
        => User.FindFirst(ClaimTypes.NameIdentifier)!.Value;
}