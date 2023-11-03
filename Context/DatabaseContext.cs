using System;
using Bankify.Models;
using Microsoft.EntityFrameworkCore;

namespace Bankify.Context
{
	public class DatabaseContext : DbContext
	{
		public DbSet<UserAccount> userAccounts { get; set; }

		public DbSet<BankAccount> bankAccounts { get; set; }

		public DbSet<Transaction> transactions { get; set; }

		public DatabaseContext(DbContextOptions options) : base(options) 
		{
		}
	}
}

