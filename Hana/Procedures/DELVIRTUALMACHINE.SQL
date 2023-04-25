-- Created by Arthur Duarte
-- https://github.com/DimplyKhan13/VMwareLog_Hana.gitBEGIN

CREATE PROCEDURE "SCHEMA"."DELVIRTUALMACHINE"(
	
	in user_vm_id varchar(50)

) LANGUAGE SQLSCRIPT
SQL SECURITY
DEFINER AS
BEGIN
	
	declare this_change integer;
	declare this_vm_name_id integer;
	declare this_vm_name varchar(30);
	
	
	if (select count(*) from "SCHEMA"."VM_CURRENT" where vm_id = user_vm_id)>0 then
	begin

	select name_id into this_vm_name_id from "SCHEMA"."VM_CURRENT" where vm_id = user_vm_id;
	select name into this_vm_name from "SCHEMA"."VM_NAME" where id = this_vm_name_id;
	call "SCHEMA"."UPDATEVIRTUALMACHINE"(user_vm_id, this_vm_name, 0, 0, 0);

	insert into "SCHEMA"."CHANGES_DATES"(time, user)
	values(now(), user());
	select current_identity_value() into THIS_CHANGE from dummy;

	UPDATE "SCHEMA"."VM_CURRENT"
	SET 
    	is_deleted = 1,
    	last_check = NOW()
	WHERE
    	vm_id = user_vm_id;
	
	insert into "SCHEMA"."VM_DELETED"(is_deleted, change_id, vm_id, vm_name_id)
	values(1, this_change, user_vm_id, this_vm_name_id);

	end;
	end if;
	
end;