/*
PACKAGE name - student_system 
Package which contains procedures to enroll a student to class,
display TA info,delete a student,drop from an enrollment
*/

create or replace package body student_system as 

/*list students table tuples
OUTPUT parameter - SYS_REFCURSOR
*/ 
procedure show_students(ref_cursor out sys_refcursor) as
begin
open ref_cursor for
select * from students;
end;

/*list courses table tuples
OUTPUT parameter - SYS_REFCURSOR
*/
procedure show_tas(ref_cursor out sys_refcursor) as
begin
open ref_cursor for
select * from tas;
end;

/*list courses table tuples
OUTPUT parameter - SYS_REFCURSOR
*/
procedure show_courses(ref_cursor out sys_refcursor) as
begin 
open ref_cursor for 
select * from courses;  
end;

/*list classes table tuples
OUTPUT parameter - SYS_REFCURSOR
*/
procedure show_classes(ref_cursor out sys_refcursor) as
begin
open ref_cursor for
select * from classes;
end;

/*list enrollments table tuples
OUTPUT parameter - SYS_REFCURSOR
*/
procedure show_enrollments(ref_cursor out sys_refcursor) as
begin
open ref_cursor for
select * from enrollments;
end;

/*list prerequisites table tuples
OUTPUT parameter - SYS_REFCURSOR
*/
procedure show_prerequisites(ref_cursor out sys_refcursor) as
begin
open ref_cursor for
select * from prerequisites;
end;

/*list logs table tuples
OUTPUT parameter - SYS_REFCURSOR
*/
procedure show_logs(ref_cursor out sys_refcursor) as
begin
open ref_cursor for
select * from logs;
end;


/*display TA info given a specific classid
INPUT PARAMETER - classid 
OUTPUT PARAMETER - error_msg
OUTPUT parameter - SYS_REFCURSOR
*/
procedure get_ta_info(stud_classid in classes.classid%type,error_msg out varchar2,rc out sys_refcursor) is 
	classid_exists classes.classid%type;
	ta_exists classes.ta_b#%type;	
begin
	begin
	select classid into classid_exists from classes where classid=stud_classid;
	exception 
	when no_data_found then error_msg := 'The classid is invalid';
	end;
	if(classid_exists=stud_classid) then
			select ta_b# into ta_exists from classes where classid=stud_classid;
			if (ta_exists is null) then
                        	error_msg := 'The class has no TA';
                	else
                		open rc for
			select c.ta_b#,s.first_name,s.last_name from classes c,students s where c.ta_b#=s.b# and classid=stud_classid;
			end if; 
	end if;
end;

/*display prerequisite courses
INPUT PARAMETER -  department code
OUTPUT PARAMETER - course number
OUTPUT parameter - SYS_REFCURSOR
OUTPUT parameter - error message
*/
procedure get_prerequisites(dept_code_in in prerequisites.dept_code%type,course#_in in prerequisites.course#%type,error_msg out varchar2,rc out sys_refcursor)is
	dept_code_exists prerequisites.dept_code%type;
	course#_exists prerequisites.course#%type;
begin
	begin
		select dept_code,course# into dept_code_exists,course#_exists from prerequisites where dept_code=dept_code_in and course#=course#_in;
		exception 
		when no_data_found then error_msg := 'The details'||' '|| dept_code_in||to_char(course#_in) ||' '||'does not exist';
	end;
	if (dept_code_exists=dept_code_in AND course#_exists=course#_in) then
		open rc for
		select (pre_dept_code||pre_course#)
		from prerequisites
		start with dept_code = dept_code_in and course#=course#_in
		connect by prior pre_dept_code=dept_code and prior pre_course#=course#;
	end if;	
end;

/*enroll students
INPUT PARAMETER - bNumber
INPUT PARAMETER - classid
OUTPUT PARAMETER - message 
*/
procedure enroll_students(b#_in enrollments.b#%type,classid_in in enrollments.classid%type,error_msg out varchar2) is
	b#_exists number;
	classid_exists number;
	sem_year number;
	enroll_limit classes.limit%type;
	enroll_size classes.class_size%type;
	enrolled_in_class number;
	enroll_year classes.year%type;
	enroll_sem classes.semester%type;
	count_courses number;
	needs_prereq number;
	prereq_count number;
begin
	select count(*) into b#_exists from students where students.b#=b#_in;
	select count(*) into classid_exists from classes where classes.classid=classid_in;
	if b#_exists=0 
	then
		error_msg := 'The b# is invalid';
	else 
		if classid_exists=0
		then
			error_msg:= 'Classid does not exists';
		else
		select count(*) into sem_year from classes c,enrollments e where classid_in=c.classid and year=2018 and semester='Fall';
			if sem_year=0
			then 
				error_msg:= 'Cannot enroll into a class from a previous semester';
			else
				select limit,class_size into enroll_limit,enroll_size from classes where classes.classid=classid_in;
				if enroll_size+1 > enroll_limit then
					error_msg := 'The class is already full';
				else
				select count(*) into enrolled_in_class from enrollments where classid=classid_in and b#_in=b#;
					if enrolled_in_class > 0 then 
						error_msg := 'The student is already in the class';
					else
					 	select year,semester into enroll_year,enroll_sem from classes where classid = classid_in;
						select count(*) into count_courses from enrollments where b#=b#_in and classid in (select 
classid from classes where year=enroll_year and semester=enroll_sem and classid<>classid_in);
						if count_courses>=5 then
							error_msg := 'Students cannot be enrolled in more than 5 classes in a semester';  
						else
select count(*) into needs_prereq from prerequisites p,classes c where c.dept_code=p.dept_code and c.course#=p.course# and c.classid=classid_in;
							if needs_prereq=0 then
								 if count_courses=4 then
                                                                    error_msg := 'The student will be overloaded with the new enrollment';
                                                                    insert into enrollments values(b#_in,classid_in,null);
                                                                else
                                                                    insert into enrollments values(b#_in,classid_in,null);
                                                                end if;

							else
select count(b#) into prereq_count from enrollments e,classes c where e.classid=c.classid and e.b#=b#_in and lgrade not in ('C-','D','I') and (dept_code,course#)= all(select pre_dept_code,pre_course# from prerequisites p, classes c1 where p.dept_code=c1.dept_code and p.course#=c1.course# and c1.classid=classid_in);  
								if prereq_count=0 then
									error_msg:='Prerequisites not satisfied';
								else
									if count_courses=4 then
							                   error_msg:='The student will be overloaded with the new enrollment';
                                                        	           insert into enrollments values(b#_in,classid_in,null);	
							               else
								           insert into enrollments values(b#_in,classid_in,null);
								       end if;
								end if;
							end if;
						end if;
					end if;
				end if; 
			end if;
		end if;
	end if;
end;

/*Procedure to drop students from enrollments
INPUT PARAMETER - bNumber
INPUT PARAMETER - classid
OUTPUT PARAMETER - error message
*/
procedure drop_enrollment(b#_in enrollments.b#%type,classid_in in enrollments.classid%type,error_msg out varchar2)is 
	bnumber_exists number;
	classid_exists number;
	enroll_exists number;
	sem_year_exists number;
	prereq_count number;
	class_enroll_count number;
	clsize number;
	class_count number;
begin 
	select count(*) into bnumber_exists from students where students.b#=b#_in;
        select count(*) into classid_exists from classes  where classes.classid=classid_in;
        if bnumber_exists=0
        then
                error_msg := 'The b# is invalid';
        else
		if classid_exists=0 then
			error_msg:= 'The classid is invalid';
		else
			select count(*) into enroll_exists from students s,enrollments e where s.b#=e.b# and s.b#=b#_in;
			if enroll_exists=0 then
				error_msg:='The student is not enrolled in the class';
			else
select count(*) into sem_year_exists from enrollments e,classes c where e.classid=c.classid and c.year=2018 and c.semester='Fall';
				if sem_year_exists=0 then
					error_msg := 'Only enrollment in the current semester can be dropped';
				else
select count(*) into prereq_count from classes c,prerequisites p where c.classid=classid_in and c.dept_code=p.pre_dept_code and c.course#=p.pre_course# and (p.dept_code,p.course#)in(select dept_code,course# from enrollments e,classes cl where e.classid = cl.classid and e.b# = b#_in);  		
					if prereq_count>0 then
						error_msg:= 'The drop is not permitted because another class the student registered uses it as a prerequisite';
					else
						select count(classid) into class_enroll_count from enrollments where b#=b#_in;
						select class_size into clsize from classes where classid=classid_in;
						select count(classid) into class_count from enrollments where classid=classid_in;
							if(class_enroll_count=1 and clsize=1) then
								delete from enrollments where b#=b#_in and classid=classid_in;
								error_msg := 'This student has not enrolled in any class now and the class has no students now';
							elsif(class_enroll_count=1) then
								delete from enrollments where b#=b#_in and classid=classid_in;
								error_msg := 'This student is not enrolled in any classes';
							else
								 delete from enrollments where b#=b#_in and classid=classid_in;
							end if; 
					end if;  
				end if;
			end if;
		end if;
	end if;
end;

/*procedure to delete students
INPUT PARAMETER - bNumber
OUTPUT PARAMETER - error message 
*/
procedure delete_students(b#_in in students.b#%type,msg out varchar2) as
	b#_check students.b#%type;
begin
	b#_check := 0;
	/*check if b# is present in DB,else throw error and return*/
	BEGIN
		SELECT b# INTO b#_check FROM students WHERE b# = b#_in;
	EXCEPTION
		WHEN no_data_found THEN raise_application_error(-20001,'The b# is invalid.');
	RETURN;
	END;
	BEGIN
	/*delete student if b# is found in db*/
		DELETE FROM students WHERE b#=b#_in;
		msg := 'Student has been deleted successfully';
		commit;
	END;
end;

end;
/
show errors
