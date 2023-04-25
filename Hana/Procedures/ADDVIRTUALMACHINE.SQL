-- Created by Arthur Duarte
-- https://github.com/DimplyKhan13/VMwareLog_Hana.git

CREATE PROCEDURE "SCHEMA"."ADDVIRTUALMACHINE"(
	
	in user_vm_id varchar(50),
	in user_vm_name varchar(30),
	in user_vm_cpu integer,
	in user_vm_memory integer,
	in user_vm_state tinyint

	
) LANGUAGE SQLSCRIPT
SQL SECURITY
DEFINER AS
BEGIN
	
	declare this_change integer;
	declare this_name integer;
	declare this_cpu integer;
	declare this_memory integer;
	declare this_state integer;

	
	if (select count(*) from "SCHEMA"."VM_CURRENT" where vm_id = user_vm_id)>0 then

	else
	begin

	insert into "SCHEMA"."CHANGES_DATES"(time, user)
	values(now(), user());
	select current_identity_value() into THIS_CHANGE from dummy;

	insert into "SCHEMA"."VM_NAME"(name, change_id, vm_id, previous_id)
	values(user_vm_name, this_change, user_vm_id, 0);
	select current_identity_value() into this_name from dummy;

	insert into "SCHEMA"."VM_STATE"(state, change_id, vm_id, previous_id, name_id)
	values(user_vm_state, this_change, user_vm_id, 0, this_name);
	select current_identity_value() into this_state from dummy;

	insert into "SCHEMA"."VM_CPU"(cpu, change_id, vm_id, previous_id, name_id)
	values(user_vm_cpu, this_change, user_vm_id, 0, this_name);
	select current_identity_value() into this_cpu from dummy;

	insert into "SCHEMA"."VM_MEMORY"(memory, change_id, vm_id, previous_id, name_id)
	values(user_vm_memory, this_change, user_vm_id, 0, this_name);
	select current_identity_value() into this_memory from dummy;

	insert into "SCHEMA"."VM_CREATED"(change_id, vm_id, name_id)
	values(this_change, user_vm_id, this_name);

	insert into "SCHEMA"."VM_CURRENT"(vm_id, is_deleted, name_id, memory_id, cpu_id, state_id, last_check)
	values(user_vm_id, 0, this_name, this_memory, this_cpu, this_state, now());
	end;

	end if;
	
end;