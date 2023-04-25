-- Created by Arthur Duarte
-- https://github.com/DimplyKhan13/VMwareLog_Hana.git

CREATE PROCEDURE "SCHEMA"."UPDATEVMSTATE"(
	
	in user_vm_id varchar(50),
	in user_vm_state tinyint,
	in this_name_id integer
	
) LANGUAGE SQLSCRIPT
SQL SECURITY
DEFINER AS
BEGIN
	
	declare this_state integer;
	declare actual_state tinyint;
	declare this_change integer;
	declare old_id integer;

	
	select state into actual_state
	from "SCHEMA"."VM_STATE"
	where id = (select state_id
	from "SCHEMA"."VM_CURRENT"
	where vm_id = user_vm_id);

	if actual_state != user_vm_state then
	begin

	insert into "SCHEMA"."CHANGES_DATES"(time, user)
	values(now(), user());
	select current_identity_value() into THIS_CHANGE from dummy;

	select state_id into old_id
	from "SCHEMA"."VM_CURRENT"
	where vm_id = user_vm_id;

	insert into "SCHEMA"."VM_STATE"(state, change_id, vm_id, previous_id, name_id)
	values(user_vm_state, this_change, user_vm_id, old_id, this_name_id);
	select current_identity_value() into this_state from dummy;

	update "SCHEMA"."VM_CURRENT"
	set  state_id = this_state
	where vm_id = user_vm_id;
	end;

	end if;	
	
end;