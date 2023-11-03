using System;
namespace Bankify.Models
{
	public class Transaction
	{
		public string AccountFrom { get; set; }

		public string AccountTo { get; set; }

		public float Balance { get; set;  }

		public string Description { get; set; }

		public Guid Id { get; set; }

		public Transaction()
		{
			Id = Guid.NewGuid();
		}
	}
}

