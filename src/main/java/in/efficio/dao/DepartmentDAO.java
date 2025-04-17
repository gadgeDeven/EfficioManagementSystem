package in.efficio.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import in.efficio.dbconnection.DbConnection;
import in.efficio.model.Department;

public class DepartmentDAO 
{

	    public List<Department> getAllDepartments() {
	        List<Department> deptList = new ArrayList<>();
	        Connection con = DbConnection.getConnection();

	        try {
	            String query = "SELECT * FROM department";
	            PreparedStatement ps = con.prepareStatement(query);
	            ResultSet rs = ps.executeQuery();

	            while (rs.next()) {
	                Department dept = new Department();
	                dept.setDepartment_id(rs.getInt("department_id"));
	                dept.setDepartment_name(rs.getString("department_name"));
	                dept.setDescription(rs.getString("description"));
	                deptList.add(dept);
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }

	        return deptList;
	    }
}
