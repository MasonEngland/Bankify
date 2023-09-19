using System.Diagnostics;
using JWT.Algorithms;
using JWT.Builder;

namespace Bankify.Middleware;

public class AuthToken : IMiddleware
{
    private static string secret = "ILoveTestingJwTS";


    public async Task InvokeAsync(HttpContext context, RequestDelegate next)
    {

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
            var decoded = JwtBuilder
                .Create()
                .WithAlgorithm(new HMACSHA256Algorithm())
                .WithSecret(secret)
                .Decode(authHeader);

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

