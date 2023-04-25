-- Created by Arthur Duarte
-- https://github.com/DimplyKhan13/VMwareLog_Hana.git

CREATE PROCEDURE "SCHEMA"."UPDATEDISKNAME"(
	
	in disk_id varchar(50),
	in user_disk_name varchar(20),
	in update_name_id integer

) LANGUAGE SQLSCRIPT
SQL SECURITY
DEFINER AS
BEGIN


	declare actual_name varchar(20);
	declare this_change integer;
	declare old_id integer;
	declare old_name_id integer;
	declare this_name integer;

	select name_id into old_name_id
	from "SCHEMA"."DISK_CURRENT"
	where id = disk_id;

	select name into actual_name
	from "SCHEMA"."DISK_NAME"
	where id = old_name_id;

	if actual_name != user_disk_name then
	begin

	insert into "SCHEMA"."CHANGES_DATES"(time, user)
	values(now(), user());
	select current_identity_value() into THIS_CHANGE from dummy;

	select name_id into old_id
	from "SCHEMA"."DISK_CURRENT"
	where id = disk_id;

	insert into "SCHEMA"."DISK_NAME"(previous_id, change_id, name, disk_id, vm_name_id)
	values(old_id, this_change, user_disk_name, disk_id, update_name_id);
	select current_identity_value() into this_name from dummy;

	update "SCHEMA"."DISK_CURRENT"
	set  name_id = this_name
	where id = disk_id;

	end;

	end if;

END;