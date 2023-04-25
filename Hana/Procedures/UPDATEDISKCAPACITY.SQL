-- Created by Arthur Duarte
-- https://github.com/DimplyKhan13/VMwareLog_Hana.git

CREATE PROCEDURE "SCHEMA"."UPDATEDISKCAPACITY"(
	in disk_id INTEGER,
	in user_disk_capacity INTEGER,
	in update_name_id INTEGER
) LANGUAGE SQLSCRIPT
SQL SECURITY
DEFINER AS
BEGIN

	declare actual_capacity INTEGER;
	declare this_change INTEGER;
	declare old_id INTEGER;
	declare old_capacity_id integer;
	declare this_capacity INTEGER;
	declare this_datastore INTEGER;
	declare this_disk_name INTEGER;

	select capacity_id into old_capacity_id
	from "SCHEMA"."DISK_CURRENT"
	where id = disk_id;
	
	select capacity INTO actual_capacity
	from "SCHEMA"."DISK_CAPACITY"
	where id = old_capacity_id;
	
	if actual_capacity != user_disk_capacity then
	begin

	insert into "SCHEMA"."CHANGES_DATES"(time, user)
	values(now(), user());
	select current_identity_value() into THIS_CHANGE from dummy;

	select capacity_id, datastore_id, name_id into old_id, this_datastore, this_disk_name
	from "SCHEMA"."DISK_CURRENT"
	where id = disk_id;

	insert into "SCHEMA"."DISK_CAPACITY"(previous_id, change_id, capacity, disk_id, vm_name_id, datastore_id, disk_name_id)
	values(old_id, this_change, user_disk_capacity, disk_id, update_name_id, this_datastore, this_disk_name);
	select current_identity_value() into this_capacity from dummy;

	update "SCHEMA"."DISK_CURRENT"
	set  capacity_id = this_capacity
	where id = capacity_id;

	end;

	end if;

END;