package in.efficio.dbconnection;

import java.sql.Connection;
import java.sql.DriverManager;

public class DbConnection 
{
	public static Connection getConnection()
	{
		Connection con = null;
		try 
		{
			Class.forName("com.mysql.cj.jdbc.Driver");
			
			String url = "jdbc:mysql://localhost:3306/efficio_management_db1";
			String username = "root";
			String pass = "root";
			
			con = DriverManager.getConnection(url, username, pass);
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		return con;
	}
}
