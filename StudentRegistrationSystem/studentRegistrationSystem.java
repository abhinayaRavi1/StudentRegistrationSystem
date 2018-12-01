import java.sql.*;
import oracle.jdbc.*;
import java.util.Scanner;
import java.math.*;
import java.io.*;
import java.awt.*;
import oracle.jdbc.pool.OracleDataSource;


public class studentRegistrationSystem {

	static Scanner sc = new Scanner(System.in);
	static studentRegistrationSystem studRegisterObject = new studentRegistrationSystem();
	public static void main(String args[]) throws SQLException {
		try
		{
			OracleDataSource ds = new oracle.jdbc.pool.OracleDataSource();
			ds.setURL("jdbc:oracle:thin:@castor.cc.binghamton.edu:1521:acad111");
			Connection conn = ds.getConnection(username, password); 
			studentRegisterObject.main_menu(conn);
			conn.close();
		}	
		catch(SQLException studentRegistrationObject) {System.out.println ("\n*** SQLException caught ***\n"+studentRegistrationSystem.getMessage());}
		catch(Exception e) {System.out.println("\n*** Other exception caught **\n");}
	}
	//Main menu method
	void main_menu(Connection conn) throws SQLException{
		int choice=-1;
		while(choice != 0) {
			System.out.println("Student Registration System Menu");
			System.out.println("==================================================");
			System.out.println("1.Display tables");
			System.out.println("2.Show TA Info");
			System.out.println("3.Show Prerequisite for a given course");
			System.out.println("4.Enroll a student to a class");
			System.out.println("5.Drop a student from a class");
			System.out.println("6.Delete a student");
			System.out.println("0.Exit");
			System.out.println("==================================================");
			System.out.println("Enter your option: ");
			choice = sc.nextInt();
			switch(choice){
			case 1:studRegisterObject.display_tables(conn); break;
			case 2:studRegisterObject.display_ta_info(conn);break;
			case 3:studRegisterObject.display_prereq(conn);break;
			case 4:studRegisterObject.enroll_student_class(conn);break;
			case 5:studRegisterObject.drop_student_class(conn);break;
			case 6:studRegisterObject.delete_student(conn);break;
			case 0:System.out.println("Student Registration System exited.");break;
			default: System.out.println("Please enter valid option.");
			}
		}
	} 

	//Display tables
	void display_tables(Connection conn) throws SQLException{
		System.out.println("1.Students");
		System.out.println("2.TAs");
		System.out.println("3.Courses");
		System.out.println("4.Classes");
		System.out.println("5.Enrollments");
		System.out.println("6.Prerequisites");
		System.out.println("7.Logs");
		int choice = sc.nextInt();
		switch(choice){
		case 1:studentRegisterObject.student_details(conn);break;
		case 2:studentRegisterObject.tas_details(conn);break;
		case 3:studentRegisterObject.courses_details(conn);break;
		case 4:studentRegisterObject.classes_details(conn);break;
		case 5:studentRegisterObject.enrollments_details(conn);break;
		case 6:studentRegisterObject.prerequisites_details(conn);break;
		case 7:studentRegisterObject.logs_details(conn);break;
		}	
	}

	//Method to display student table
	void student_details(Connection conn) throws SQLException{
		String showStudProc = "{call student_system.show_students(?)}" ;	
		CallableStatement cs = conn.prepareCall(showStudProc);
		cs.registerOutParameter(1,OracleTypes.CURSOR);
		cs.execute();
		ResultSet rs = (ResultSet)cs.getObject(1);
		System.out.println("Student Tuples");
		System.out.println("B#\tFirst Name\tLast Name\tStatus\t\t\tGpa\tEmail\t\tBdate\t\tDeptname");
		
System.out.println("-----------------------------------------------------------------------------------------------------------------------------");
		while(rs.next()){

			
System.out.println(rs.getString(1)+"\t"+rs.getString(2)+"\t\t"+rs.getString(3)+"\t\t"+rs.getString(4)+"\t\t\t"+rs.getString(5)+"\t"+rs.getString(6)+"\t"+rs.getString(7).substring(0,10)+"\t"+rs.getString(8));
		}	
		cs.close();
	}

	//Method to display tas table
	void tas_details(Connection conn) throws SQLException{
		String showTAProc = "{call student_system.show_tas(?)}";
		CallableStatement cs = conn.prepareCall(showTAProc);
		cs.registerOutParameter(1,OracleTypes.CURSOR);
		cs.execute();
		ResultSet rs = (ResultSet)cs.getObject(1);
		System.out.println("TA Tuples");
		System.out.println("B#\tTa_Level\tOffice");
		System.out.println("--------------------------------------------------------------------------");
		while(rs.next())
		{
			System.out.println(rs.getString(1)+"\t"+rs.getString(2)+"\t\t"+rs.getString(3));
		}
		cs.close();
	}
	//Method to display courses table
	void courses_details(Connection conn) throws SQLException{
		String showCoursesProc = "{call student_system.show_courses(?)}";
		CallableStatement cs = conn.prepareCall(showCoursesProc);
		cs.registerOutParameter(1,OracleTypes.CURSOR);
		cs.execute();
		ResultSet rs = (ResultSet)cs.getObject(1);
		System.out.println("Courses Tuples");
		System.out.println("Dept_Code\tCourse#\t\tTitle");
		System.out.println("----------------------------------------------------------------");
		while(rs.next())
		{
			System.out.println(rs.getString(1)+"\t\t"+rs.getString(2)+"\t\t"+rs.getString(3));
		}
		cs.close();
	}
	//Method to display classes table
	void classes_details(Connection conn) throws SQLException{
		String showClassesProc = "{call student_system.show_classes(?)}";
		CallableStatement cs = conn.prepareCall(showClassesProc);
		cs.registerOutParameter(1,OracleTypes.CURSOR);
		cs.execute();
		ResultSet rs = (ResultSet)cs.getObject(1);
		System.out.println("Class Tuples");
		System.out.println("Classid\tDept_Code\tCourse#\t\tSect#\tYear\tSemester\t\tLimit\tClass_Size\tRoom\tTA_B#");
		
System.out.println("---------------------------------------------------------------------------------------------------------------------------------------------------");
		while(rs.next())
		{

			
System.out.println(rs.getString(1)+"\t"+rs.getString(2)+"\t"+rs.getString(3)+"\t\t"+rs.getString(4)+"\t"+rs.getString(5)+"\t"+rs.getString(6)+"\t\t"+rs.getString(7)+"\t"+rs.getString(8)+"\t"+rs.getString(9)+"\t"+rs.getString(10));
		}
		cs.close();
	}
	//Method to display enrollments table
	void enrollments_details(Connection conn) throws SQLException{
		String showEnrollmentProc = "{call student_system.show_enrollments(?)}";
		CallableStatement cs = conn.prepareCall(showEnrollmentProc);
		cs.registerOutParameter(1,OracleTypes.CURSOR);
		cs.execute();
		ResultSet rs = (ResultSet)cs.getObject(1);
		System.out.println("Enrollment Tuples");
		System.out.println("B#\tClassid\tLgrade");
		System.out.println("-----------------------------------------------------------------------");
		while(rs.next())
		{
			System.out.println(rs.getString(1)+"\t"+rs.getString(2)+"\t"+rs.getString(3));
		}
		cs.close();
	}
	//Method to display prerequisites table
	void prerequisites_details(Connection conn) throws SQLException{
		String showPreReqDetails = "{call student_system.show_prerequisites(?)}";
		CallableStatement cs = conn.prepareCall(showPreReqDetails);
		cs.registerOutParameter(1,OracleTypes.CURSOR);
		cs.execute();
		ResultSet rs = (ResultSet)cs.getObject(1);
		System.out.println("Prerequisites Tuples");
		System.out.println("DeptCode\tCourse#\tPreDeptCode\tPreCourse#");
		System.out.println("-----------------------------------------------------------------------------------------");
		while(rs.next())
		{
			System.out.println(rs.getString(1)+"\t\t"+rs.getString(2)+"\t\t"+rs.getString(3)+"\t\t"+rs.getString(4));
		}
		cs.close();
	}
	//Method to display logs table
	void logs_details(Connection conn) throws SQLException{
		String showLogProc = "{call student_system.show_logs(?)}";
		CallableStatement cs = conn.prepareCall(showLogProc);
		cs.registerOutParameter(1,OracleTypes.CURSOR);
		cs.execute();
		ResultSet rs = (ResultSet)cs.getObject(1);
		System.out.println("Logs Tuples");
		System.out.println("Log#\tOperation_name\t\tOperation_time\t\tTable_name\t\tOperation\t\tKey_value");
		
System.out.println("------------------------------------------------------------------------------------------------------------------------------------------");
		while(rs.next())
		{

			
System.out.println(rs.getString(1)+"\t"+rs.getString(2)+"\t\t"+rs.getString(3)+"\t\t"+rs.getString(4)+"\t\t"+rs.getString(5)+"\t\t"+rs.getString(6));
		}
		cs.close();
	}
	/*Method to display the TA info for a given classId*/
	void display_ta_info(Connection conn) throws SQLException{	
		String msg = null;
		System.out.println("Enter classid");
		String classidIn = sc.next();
		String getTAProc = "{call student_system.get_ta_info(?,?,?)}";
		CallableStatement cs1 = conn.prepareCall(getTAProc);
		cs1.setString(1,classidIn);
		cs1.registerOutParameter(2,OracleTypes.VARCHAR);
		cs1.registerOutParameter(3,OracleTypes.CURSOR);
		cs1.execute();
		msg = cs1.getString(2);
		if(msg!=null){System.out.println(msg);}
		else{
			ResultSet rs1 = (ResultSet)cs1.getObject(3);
			System.out.println("B#\t\tFirstName\t\tLastName");
			System.out.println("------------------------------------------------");
			while(rs1.next()){

				System.out.println(rs1.getString(1)+"\t\t"+rs1.getString(2)+"\t\t"+rs1.getString(3));
			}
		}	
		cs1.close();
	}

	//Method to display prerequisite courses
	void display_prereq(Connection conn) throws SQLException{
		String msg = null;
		System.out.println("Enter Dept code");
		String deptCodeIn = sc.next();
		System.out.println("Enter Course#");
		int courseNoIn = sc.nextInt();
		String getPrereqProc = "{call student_system.get_prerequisites(?,?,?,?)}";
		CallableStatement cs1 = conn.prepareCall(getPrereqProc);
		cs1.setString(1,deptCodeIn);
		cs1.setInt(2,courseNoIn);
		cs1.registerOutParameter(3,OracleTypes.VARCHAR);
		cs1.registerOutParameter(4,OracleTypes.CURSOR);
		cs1.execute();
		msg = cs1.getString(3);
		if(msg!=null){System.out.println(msg);}
		else{
			ResultSet rs1 = (ResultSet)cs1.getObject(4);
			System.out.println("CourseList is");
			while(rs1.next()){
				System.out.println(rs1.getString(1));
			}
		}
		cs1.close();
	}
	//Method to enroll students to class
	void enroll_student_class(Connection conn) throws SQLException{
		String msg = null;
		System.out.println("Enter B#");
		String bNumberIn = sc.next();
		System.out.println("Enter classid");
		String classIdIn = sc.next();
		String getEnrollStudProc = "{call student_system.enroll_students(?,?,?)}";
		CallableStatement cs1 = conn.prepareCall(getEnrollStudProc);
		cs1.setString(1,bNumberIn);
		cs1.setString(2,classIdIn);
		cs1.registerOutParameter(3,OracleTypes.VARCHAR);
		cs1.execute();
		msg = cs1.getString(3);
		if(msg!=null){System.out.println(msg);}
		else{System.out.println("Enrolled "+ bNumberIn +" in " +classIdIn +" successfully");}
		cs1.close();
	}
	//Method to drop a student class from enrollments table
	void drop_student_class(Connection conn) throws SQLException{
		String msg = null;
		System.out.println("Enter B#");
		String bNumberIn = sc.next();
		System.out.println("Enter classid");
		String classIdIn = sc.next();
		String getDropStudentClass = "{call student_system.drop_enrollment(?,?,?)}";
		CallableStatement cs1 = conn.prepareCall(getDropStudentClass);
		cs1.setString(1,bNumberIn);
		cs1.setString(2,classIdIn);
		cs1.registerOutParameter(3,OracleTypes.VARCHAR);
		cs1.execute();
		msg = cs1.getString(3);
		if(msg!=null){System.out.println(msg);}
		else{System.out.println("The given "+ bNumberIn +" has been deleted from enrollments successfully");}
		cs1.close();
	}

	//Method to delete
	void delete_student(Connection conn) throws SQLException{
		String msg = null;
		System.out.println("Enter B#");
		String bNumberIn = sc.next();

		String getDeleteStudent = "{call student_system.delete_students(?,?)}";
		CallableStatement cs1 = conn.prepareCall(getDeleteStudent);
		cs1.setString(1,bNumberIn);
		cs1.registerOutParameter(2,OracleTypes.VARCHAR);
		cs1.execute();
		msg = cs1.getString(2);
		if(msg!=null){System.out.println(msg);}
		cs1.close();
	}

}
