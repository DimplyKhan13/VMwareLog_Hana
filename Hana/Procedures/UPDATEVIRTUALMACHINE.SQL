-- Created by Arthur Duarte
-- https://github.com/DimplyKhan13/VMwareLog_Hana.git

CREATE PROCEDURE "SCHEMA"."UPDATEVIRTUALMACHINE"(
	
	in user_vm_id varchar(50),
	in user_vm_name varchar(30),
	in user_vm_cpu integer,
	in user_vm_memory integer,
	in user_vm_state tinyint

) LANGUAGE SQLSCRIPT
SQL SECURITY
DEFINER AS
BEGIN
	
	declare this_name_id integer;
	
	
	if (select count(*) from "SCHEMA"."VM_CURRENT" where vm_id = user_vm_id)>0 then
	begin

	select name_id into this_name_id from "SCHEMA"."VM_CURRENT" where (vm_id = user_vm_id);

	call "SCHEMA"."UPDATEVMNAME"(user_vm_id, user_vm_name, this_name_id);
	call "SCHEMA"."UPDATEVMCPU"(user_vm_id, user_vm_cpu, this_name_id);
	call "SCHEMA"."UPDATEVMMEMORY"(user_vm_id, user_vm_memory, this_name_id);
	call "SCHEMA"."UPDATEVMSTATE"(user_vm_id, user_vm_state, this_name_id);

	update "SCHEMA"."VM_CURRENT" set is_deleted = 0, last_check = now() where vm_id = user_vm_id;

	end;

	else
	call "SCHEMA"."ADDVIRTUALMACHINE"(user_vm_id, user_vm_name, user_vm_cpu, user_vm_memory, user_vm_state);

	end if;
	
end;