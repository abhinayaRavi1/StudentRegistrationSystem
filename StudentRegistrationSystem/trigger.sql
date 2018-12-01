delete from logs;
drop sequence sequence_logno;

drop trigger enrollments_trigger_insert;
drop trigger enrollments_trigger_delete;
drop trigger students_updated_delete;
drop trigger delete_student_enrollments;
drop trigger delete_student_classes;
drop trigger delete_student_tas;

/*Sequence for generating log#*/
create sequence sequence_logno
minvalue 100
maxvalue 9999
start with 100
increment by 1;


/*Trigger for insert on enrollment*/
create or replace trigger enrollments_trigger_insert
after insert on enrollments
for each row
declare
	username varchar2(20); 
	utime date;
begin
	select user into username from dual;
	select localtimestamp into utime from dual;

	update classes set class_size=class_size+1 where classid=:new.classid;
	insert into logs (log#,op_name,op_time,table_name,operation,key_value) 
	values (sequence_logno.nextval,username,utime,'ENROLLMENTS','INSERT',:new.b#||','||:new.classid);	
end;
/

/*Trigger for delete on enrollment*/
create or replace trigger enrollments_trigger_delete
after delete on enrollments
for each row
declare
	dba varchar2(20);
	keyvalue varchar2(20);
begin
	select user into dba from dual;
	keyvalue := :OLD.b#||','||:OLD.classid;
	update classes set class_size=class_size-1 where classid=:old.classid;
	insert into logs values(sequence_logno.nextval,dba,sysdate,'ENROLLMENTS','DELETE',keyvalue);
end;
/

/*Trigger for students update*/
create or replace TRIGGER students_updated_delete
after DELETE ON students
FOR EACH ROW
DECLARE
	dba varchar2(20);
BEGIN
	SELECT USER INTO dba from dual;
   	INSERT INTO logs VALUES (sequence_logno.nextval,dba,sysdate,'Students','Delete',:OLD.B# );
END;
/


/*student deleted, delete all his enrollments*/
CREATE OR REPLACE TRIGGER delete_student_enrollments
BEFORE DELETE ON students
FOR EACH ROW
BEGIN
	DELETE FROM enrollments WHERE b#=:OLD.b#;
END;
/

CREATE OR REPLACE TRIGGER delete_student_classes
BEFORE delete ON students
FOR EACH ROW
BEGIN
        update classes set ta_b#= NULL WHERE ta_b#=:OLD.b#;
END;
/

/*student deleted, delete all his enrollments*/
CREATE OR REPLACE TRIGGER delete_student_tas
BEFORE DELETE ON students
FOR EACH ROW
BEGIN
        DELETE FROM tas WHERE b#=:OLD.b#;
END;
/
