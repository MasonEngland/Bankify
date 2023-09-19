using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using Bankify.Models;
using Bankify.Context;
using static BCrypt.Net.BCrypt;
using JWT.Builder;
using JWT.Algorithms;
using System.Security.Cryptography;


//new RS256Algorithm(certificate[0], certificate[1])

namespace Bankify.Controllers
{
	[Route("[controller]")]
	public class AccountsController : Controller
	{

		private static string secret = "ILoveTestingJwTS";
        // pull database using dependancy injection
        private readonly DatabaseContext _db;

		public AccountsController(DatabaseContext db)
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
					StatusCode(400);
					return new
					{
						success = false,
						msg = "Email already registerd"
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
						msg = "Email not Registered"
					});
				}

				// check if the Password matches the hash in the database
				bool isMatch = Verify(account.Password, dbAccount[0].Password);


				// Check Username and Password are Correct
                if (account.Username != dbAccount[0].Username || !isMatch)
				{
					StatusCode(401);
					return Unauthorized(new
					{
						success = false,
						msg = "incorrect username or password"
					});
				}

				string token = JwtBuilder
					.Create()
					.WithAlgorithm(new HMACSHA256Algorithm())
					.WithSecret(secret)
					.AddClaim("Id", account.Id)
					.AddClaim("Username", account.Username)
					.AddClaim("Password", dbAccount[0].Password)
					.AddClaim("Email", account.Email)
					.Encode();

				// If Username as Email passed 
				return new
				{
					Success = true,
					Username = account.Username,
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

		[HttpGet("test")]
		public object Test()
		{
			object? items = HttpContext.Items["tokenData"];

			if (items != null)
			{
				return items;
			}

			return "items was null";


		}
	}
}

