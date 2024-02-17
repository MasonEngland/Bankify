using System.Diagnostics;
using System.Text.Json;
using Microsoft.AspNetCore.Mvc;
using Bankify.Models;
using Bankify.Context;
using Microsoft.EntityFrameworkCore;

namespace Bankify.Controllers;

[Route("[controller]")]
public class BankController : Controller
{
	private readonly DatabaseContext _db;

	public BankController(DatabaseContext db)
	{
		_db = db;
	}

	// create a bank account thats is seperate from but still tied to the user account
	[HttpPost("Create")]
	public object OpenAccount([FromBody] BankAccount account)
	{
		try
		{
			if (account == null)
			{
				return BadRequest("Request body does not fallow the schema");
			}

			_db.bankAccounts.Add(account);
			_db.SaveChanges();


			return Created(Request.Path, "Account Saved");

	    } catch (Exception err) {
			Debug.WriteLine(err.Message);
			return StatusCode(500);
		}

	}

	// grabs all bank accounts tied to the token bearer
	[HttpGet("GetAll")]
	public object GetAllAccounts()
	{
		try
		{
            // get the items decoded from the jwt that were passed through the pipeline in the  http context
    	    string? data = Convert.ToString(HttpContext.Items["tokenData"]);
            UserAccount? decoded = JsonSerializer.Deserialize<UserAccount>(data!);

            if (decoded == null)
		    {
			    return Unauthorized("token could not be deserialized");
		    }

			// Check if the ID from the token is matched up with the id attached the requested accounts
			BankAccount[] bankAccounts = _db.bankAccounts.Where(item => item.AccountID == Convert.ToString(decoded.Id)).ToArray();

			return Ok(bankAccounts);
		} catch (Exception err)
		{
			Debug.WriteLine(err);
			return StatusCode(500);
		}
	}

	[HttpPatch("Balance")]
	public object Patch([FromBody] Transaction body)
	{
		try
		{
			//TODO possibly refactor into seperate method
			string? data = Convert.ToString(HttpContext.Items["tokenData"]);
			UserAccount? decoded = JsonSerializer.Deserialize<UserAccount>(data!);

			if (decoded == null)
			{
				return Unauthorized("token could not be deserialized");
			}

			BankAccount[] gotAccount = _db.bankAccounts.Where(item => Convert.ToString(item.Id) == body.AccountTo).ToArray();
			BankAccount[] fromAccount = _db.bankAccounts.Where(item => Convert.ToString(item.Id) == body.AccountFrom).ToArray();

			if (gotAccount.Length < 1 || fromAccount.Length < 1) 
			{
				return NotFound(new {body.AccountTo, body.Description});
			}

			if (fromAccount[0].Balance < body.Balance) 
			{
				return Unauthorized("Transaction Failed");
			}

			_db.bankAccounts
				.Where(item => Convert.ToString(item.Id) == body.AccountFrom)
				.ExecuteUpdate(u => u.SetProperty(p => p.Balance, fromAccount[0].Balance - body.Balance));

            //ExecuteUpdate() doesn't require a _db.SaveChanges()
            _db.bankAccounts
				.Where(item => Convert.ToString(item.Id) == body.AccountTo)
				.ExecuteUpdate(u => u.SetProperty(p => p.Balance, gotAccount[0].Balance + body.Balance));


			_db.transactions.Add(body);
			_db.SaveChanges();

            return Ok();
        } catch (Exception err)
		{
			Debug.WriteLine(err.Message);
			HttpContext.Response.StatusCode = 500;
            return err.Message;
		}
	}
	[HttpDelete("Remove/{id}")]
	public object Delete(string id)
	{
		try
		{
            string? data = Convert.ToString(HttpContext.Items["tokenData"]);
            UserAccount? decoded = JsonSerializer.Deserialize<UserAccount>(data);

            if (decoded == null)
            {
                return Unauthorized("token could not be deserialized");
            }

			_db.bankAccounts
				.Where(item => Convert.ToString(item.Id) == id && item.AccountID == Convert.ToString(decoded.Id))
				.ExecuteDelete();
            return Ok();
    } catch (Exception err)
		{
			Debug.WriteLine(err.Message);
			return StatusCode(500);
		}
	}
}

