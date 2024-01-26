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
        UserAccount? decoded = JsonSerializer.Deserialize<UserAccount>(data);

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

	[HttpPatch("Balance/{id}")]
	public object Patch(string id, [FromBody] float balance, [FromBody] string accountFrom, [FromBody] string description)
	{
		try
		{
			//TODO possibly refactor into seperate method
			string? data = Convert.ToString(HttpContext.Items["tokenData"]);
			UserAccount? decoded = JsonSerializer.Deserialize<UserAccount>(data);

			if (decoded == null)
			{
				return Unauthorized("token could not be deserialized");
			}

			BankAccount gotAccount = _db.bankAccounts.Where(item => Convert.ToString(item.Id) == id).ToArray()[0];
			BankAccount fromAccount = _db.bankAccounts.Where(item => Convert.ToString(item.Id) == accountFrom).ToArray()[0];

			if (gotAccount == null || fromAccount == null) 
			{
				return NotFound("Could not transfer funds");
			}

			if (fromAccount.Balance < balance) 
			{
				return Unauthorized("Transaction Failed");
			}

			_db.bankAccounts
				.Where(item => Convert.ToString(item.Id) == accountFrom)
				.ExecuteUpdate(u => u.SetProperty(p => p.Balance, fromAccount.Balance - balance));

            //ExecuteUpdate() doesn't require a _db.SaveChanges()
            _db.bankAccounts
				.Where(item => Convert.ToString(item.Id) == id)
				.ExecuteUpdate(u => u.SetProperty(p => p.Balance, gotAccount.Balance + balance));

			Transaction action = new Transaction() { AccountFrom = accountFrom, AccountTo = id, Balance = balance, Description = description };


			_db.transactions.Add(action);
			_db.SaveChanges();

            return Ok();
        } catch (Exception err)
		{
			Debug.WriteLine(err.Message);
			return StatusCode(500);
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

