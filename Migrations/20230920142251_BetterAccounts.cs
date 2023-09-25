using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Bankify.Migrations
{
    /// <inheritdoc />
    public partial class BetterAccounts : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "AccountID",
                table: "bankAccounts",
                type: "longtext",
                nullable: false);

            migrationBuilder.AddColumn<string>(
                name: "Name",
                table: "bankAccounts",
                type: "longtext",
                nullable: false);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "AccountID",
                table: "bankAccounts");

            migrationBuilder.DropColumn(
                name: "Name",
                table: "bankAccounts");
        }
    }
}
