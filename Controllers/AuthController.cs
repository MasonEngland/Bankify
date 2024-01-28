using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Bankify.Models;
using Bankify.Context;
using static BCrypt.Net.BCrypt;
using JWT.Builder;
using JWT.Algorithms;


//new RS256Algorithm(certificate[0], certificate[1])

namespace Bankify.Controllers;

[Route("[controller]")]
public class AuthController : Controller
{

    // pull database using dependancy injection
    private readonly DatabaseContext _db;

	public AuthController(DatabaseContext db)
	{
		_db = db;
	}

	// create an account
	[HttpPost("Register")]
	public object Register([FromBody] UserAccount account)
	{
		try
		{
			// check if email is already taken
			UserAccount[] takenemail = _db.userAccounts
				.Where(item => item.Email == account.Email)
				.ToArray();
			if (takenemail.Length > 0)
			{
				HttpContext.Response.StatusCode = 400;
				return new
				{
					success = false,
					msg = "Attempt Failed"
				};
			}

			// db can error at any time
            _db.userAccounts.Add(new UserAccount()
            {
                Username = account.Username,
                Password = HashPassword(account.Password),
                Email = account.Email
            });
            _db.SaveChanges();

            StatusCode(201);
            return new 
            {
                success = true,
                msg = "account created"
            };
        } catch(Exception err)
		{
			Debug.WriteLine(err.Message);
			return StatusCode(500);
		}
		
	}

	[HttpPost("Login")]
	public object Login([FromBody] UserAccount account)
	{

        string? secret = Environment.GetEnvironmentVariable("ACCESS_TOKEN_SECRET");
		// just here for saftey
		if (secret == null)
		{
			Debug.WriteLine("problem with token secret");
			return StatusCode(500);
		}

		try
		{
			// find account in the database with matching Email
			UserAccount[] dbAccount = _db.userAccounts
				.Where(item => item.Email == account.Email)
				.ToArray();

			if (dbAccount.Length != 1)
			{
				StatusCode(404);
				return NotFound(new
				{
					success = false,
					msg = "Login Failed"
				});
			}

			// check if the Password matches the hash in the database
			bool isMatch = Verify(account.Password, dbAccount[0].Password);

			// Check Username and Password are Correct
            if (!isMatch)
			{
				StatusCode(401);


				return Unauthorized(new
			    {
				  success = false,
				  msg = "incorrect username or password"
                });
            }

			// build a jwt and sign it with a token secret
			string token = JwtBuilder
				.Create()
				.WithAlgorithm(new HMACSHA256Algorithm())
				.WithSecret(secret)
				.AddClaim("Id", dbAccount[0].Id)
				.AddClaim("Username", account.Username)
				.AddClaim("Password", dbAccount[0].Password)
				.AddClaim("Email", account.Email)
				.Encode();

			// If the email is not already registered, they email in account and dbAccont are the same 
			return new
			{
				Success = true,
				Username = dbAccount[0].Username,
				Email = account.Email,
				Id = dbAccount[0].Id,
				token
			};
		} catch (Exception err) // catch any errors out of my control
		{
			Debug.WriteLine(err.Message);
			return StatusCode(500);
		}
	}

	// TODO implement a form of authorization
	[HttpDelete("Remove/{id}")]
	public object DeleteAccount(string id)
	{
		try
		{
			_db.userAccounts
				.Where(item => Convert.ToString(item.Id) == id)
				.ExecuteDelete();

		} catch(Exception err)
		{
			Debug.WriteLine(err.Message);
			return StatusCode(500);
		}
		return Ok();
	}
}

