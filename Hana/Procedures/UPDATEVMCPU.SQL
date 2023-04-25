-- Created by Arthur Duarte
-- https://github.com/DimplyKhan13/VMwareLog_Hana.git

CREATE PROCEDURE "SCHEMA"."UPDATEVMCPU"(
	
	in user_vm_id varchar(50),
	in user_vm_cpu integer,
	in this_name_id integer

) LANGUAGE SQLSCRIPT
SQL SECURITY
DEFINER AS
BEGIN

	declare this_cpu integer;
	declare actual_cpu integer;
	declare this_change integer;
	declare old_id integer;


	select cpu into actual_cpu
	from "SCHEMA"."VM_CPU"
	where id = (select cpu_id
	from "SCHEMA"."VM_CURRENT"
	where vm_id = user_vm_id);

	if actual_cpu != user_vm_cpu then
	begin

	insert into "SCHEMA"."CHANGES_DATES"(time, user)
	values(now(), user());
	select current_identity_value() into THIS_CHANGE from dummy;

	select cpu_id into old_id
	from "SCHEMA"."VM_CURRENT"
	where vm_id = user_vm_id;

	insert into "SCHEMA"."VM_CPU"(cpu, change_id, vm_id, previous_id, name_id)
	values(user_vm_cpu, this_change, user_vm_id, old_id, this_name_id);
	select current_identity_value() into this_cpu from dummy;

	update "SCHEMA"."VM_CURRENT"
	set  cpu_id = this_cpu
	where vm_id = user_vm_id;
	end;

	end if;

end;