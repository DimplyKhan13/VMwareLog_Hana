-- Created by Arthur Duarte
-- https://github.com/DimplyKhan13/VMwareLog_Hana.git

CREATE PROCEDURE "SCHEMA"."UPDATEVMMEMORY"(
	
	in user_vm_id varchar(50),
	in user_vm_memory integer,
	in this_name_id integer

) LANGUAGE SQLSCRIPT
SQL SECURITY
DEFINER AS
BEGIN

	declare this_memory integer;
	declare actual_memory integer;
	declare this_change integer;
	declare old_id integer;

	select memory into actual_memory
	from "SCHEMA"."VM_MEMORY"
	where id = (select memory_id
	from "SCHEMA"."VM_CURRENT"
	where vm_id = user_vm_id);

	if actual_memory != user_vm_memory then
	begin

	insert into "SCHEMA"."CHANGES_DATES"(time, user)
	values(now(), user());
	select current_identity_value() into THIS_CHANGE from dummy;
	
	select memory_id into old_id
	from "SCHEMA"."VM_CURRENT"
	where vm_id = user_vm_id;

	insert into "SCHEMA"."VM_MEMORY"(memory, change_id, vm_id, previous_id, name_id)
	values(user_vm_memory, this_change, user_vm_id, old_id, this_name_id);
	select current_identity_value() into this_memory from dummy;

	update "SCHEMA"."VM_CURRENT"
	set  memory_id = this_memory
	where vm_id = user_vm_id;
	end;

	end if;

end;