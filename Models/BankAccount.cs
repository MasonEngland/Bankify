using System;

namespace Bankify.Models
{
	public class BankAccount
	{
		public Guid Id { get; set; }

		public string Username { get; set; }

		public string Email { get; set; }

		public float Balance { get; set; }

		public DateTime Date { get; set; }

		public BankAccount()
		{
			Id = Guid.NewGuid();

			Date = DateTime.Now;
		}
	}
}

