using System.Diagnostics;
using System.Text.Json;
using JWT.Algorithms;
using JWT.Builder;
using Bankify.Models;

namespace Bankify.Middleware;

public class AuthToken : IMiddleware
{
    private static string secret = "ILoveTestingJwTS";


    public async Task InvokeAsync(HttpContext context, RequestDelegate next)
    {

        string path = context.Request.Path;

        if (path.Contains("/Auth")) 
        {
            await next(context);
            return;
        }

        string? authHeader = context.Request.Headers.Authorization;

        if (authHeader == null)
        {
            context.Response.StatusCode = 401;
            await context.Response.WriteAsync("No Token");
            return;
        }

        try
        {
            authHeader = authHeader.Split(" ")[1];
            string? decoded = JwtBuilder
                .Create()
                .WithAlgorithm(new HMACSHA256Algorithm())
                .WithSecret(secret)
                .Decode(authHeader);
            if (decoded == null)
            {
                context.Response.StatusCode = 401;
                await context.Response.WriteAsync("invalid token");
                return;
            }

            IDictionary<object, object?> item = new Dictionary<object, object?>
            {
                { "tokenData", decoded }
            };



            context.Items = item;
            await next(context);
        } catch(Exception err)
        {
            Debug.WriteLine(err.Message);
            await context.Response.WriteAsync("Token Invalid");
        }
    }
}

public static class AuthTokenExtension
{
    public static IApplicationBuilder UseAuthToken(this IApplicationBuilder app)
    {
        return app.UseMiddleware<AuthToken>();
    }
}

