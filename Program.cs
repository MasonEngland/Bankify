using Bankify.Context;
using Microsoft.EntityFrameworkCore;


namespace Bankify;


public class Program
{
    public static void Main(string[] args)
    {
        var builder = WebApplication.CreateBuilder(args);

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

        app.MapControllers();

        app.Run();
    }
}

