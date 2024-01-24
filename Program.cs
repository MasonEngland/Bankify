using Bankify.Context;
using Microsoft.EntityFrameworkCore;
using Bankify.Middleware;


namespace Bankify;


public class Program
{
    public static void Main(string[] args)
    {
        var root = Directory.GetCurrentDirectory();
        var dotenv = Path.Combine(root, ".env");
        DotEnv.Config(dotenv);

        var builder = WebApplication.CreateBuilder(args);

        builder.Services.AddTransient<AuthToken>();

        // Add services to the container.

        builder.Services.AddControllers();
        // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
        builder.Services.AddEndpointsApiExplorer();
        builder.Services.AddDbContext<DatabaseContext>(options =>
        {
            options.UseMySQL(builder.Configuration.GetConnectionString("Default"));
        });

        var app = builder.Build();

        // Configure the HTTP request pipeline.
        app.UseAuthorization();

        app.UseCors();

        app.UseAuthToken();

        app.MapControllers();

        app.Run();
    }
}

