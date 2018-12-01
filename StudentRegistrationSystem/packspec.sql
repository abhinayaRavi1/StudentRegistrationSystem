/*
 * PROCEDURE Specifications.
 * Must be executed once before using the application.
 * 
 */
create or replace package student_system as
	
	procedure show_students(ref_cursor out sys_refcursor);
	procedure show_tas(ref_cursor out sys_refcursor);
	procedure show_courses(ref_cursor out sys_refcursor);
	procedure show_classes(ref_cursor out sys_refcursor);
	procedure show_enrollments(ref_cursor out sys_refcursor);
	procedure show_prerequisites(ref_cursor out sys_refcursor);
	procedure show_logs(ref_cursor out sys_refcursor);
	
	procedure get_ta_info(stud_classid in classes.classid%type,error_msg out varchar2,rc out sys_refcursor);

	procedure get_prerequisites(dept_code_in in prerequisites.dept_code%type,course#_in in prerequisites.course#%type,error_msg out varchar2,rc out sys_refcursor);	
		
	procedure enroll_students(b#_in enrollments.b#%type,classid_in in enrollments.classid%type,error_msg out varchar2);

	procedure drop_enrollment(b#_in enrollments.b#%type,classid_in in enrollments.classid%type,error_msg out varchar2);

	procedure delete_students(b#_in students.b#%type,msg out varchar2);

end;
/
show errors
