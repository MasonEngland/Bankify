using System.Diagnostics;
using System.Text.Json;
using JWT.Algorithms;
using JWT.Builder;
using Bankify.Models;

namespace Bankify.Middleware;

public class AuthToken : IMiddleware
{
    // Middleware to deserialize and authenticate a json web token
    public async Task InvokeAsync(HttpContext context, RequestDelegate next)
    {
        // get the token secret from the environment
        string? secret = Environment.GetEnvironmentVariable("ACCESS_TOKEN_SECRET");

        // check to make sure the secret could be grabbed
        if (secret == null)
        {
            await context.Response.WriteAsync("Environment Variable could not be found");
            return;
        }

        string path = context.Request.Path;

        // skip middleware for certain paths
        if (path.Contains("/Auth/Register") || path.Contains("/Auth/Login")) 
        {
            await next(context);
            return;
        }

        // get the token from the authorization header
        string? authHeader = context.Request.Headers.Authorization;

        if (authHeader == null)
        {
            context.Response.StatusCode = 401;
            await context.Response.WriteAsync("No Token");
            return;
        }

        try
        {
            // deserialize the token
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


            // attach the json data to the request
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

