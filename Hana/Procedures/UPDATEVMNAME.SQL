-- Created by Arthur Duarte
-- https://github.com/DimplyKhan13/VMwareLog_Hana.git

CREATE PROCEDURE "SCHEMA"."UPDATEVMNAME"(
	
	in user_vm_id varchar(50),
	in user_vm_name varchar(30),
	inout update_name_id integer

) LANGUAGE SQLSCRIPT
SQL SECURITY
DEFINER AS
BEGIN

	declare this_name integer;
	declare actual_name varchar(30);
	declare this_change integer;
	declare old_id integer;


	select name into actual_name
	from "SCHEMA"."VM_NAME"
	where id = (select name_id
	from "SCHEMA"."VM_CURRENT"
	where vm_id = user_vm_id);

	if actual_name != user_vm_name then
	begin

	insert into "SCHEMA"."CHANGES_DATES"(time, user)
	values(now(), user());
	select current_identity_value() into THIS_CHANGE from dummy;

	select name_id into old_id
	from "SCHEMA"."VM_CURRENT"
	where vm_id = user_vm_id;

	insert into "SCHEMA"."VM_NAME"(name, change_id, vm_id, previous_id)
	values(user_vm_name, this_change, user_vm_id, old_id);
	select current_identity_value() into this_name from dummy;

	update_name_id := this_name;

	update "SCHEMA"."VM_CURRENT"
	set  name_id = this_name
	where vm_id = user_vm_id;
	end;

	end if;

end;