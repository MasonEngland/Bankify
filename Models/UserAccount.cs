using System;
namespace Bankify.Models
{
	public class UserAccount
	{
		public Guid Id { get; set; }

		public string Username { get; set; }

		public string Password { get; set; }

		public string Email { get; set; }

		public DateTime Date { get; set; }

		public UserAccount()
		{
			Id = Guid.NewGuid();

			Date = DateTime.Now;
		}
	}
}

