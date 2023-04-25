-- Created by Arthur Duarte
-- https://github.com/DimplyKhan13/VMwareLog_Hana.git

CREATE PROCEDURE "SCHEMA"."UPDATEDISKDATASTORE"(
	
	in disk_id integer,
	in user_disk_datastore varchar(90),
	in update_name_id integer

) LANGUAGE SQLSCRIPT
SQL SECURITY
DEFINER AS
BEGIN

	declare actual_datastore varchar(90);
	declare this_change integer;
	declare old_id integer;
	declare	old_datastore_id integer;
	declare this_datastore integer;
	declare this_disk_name integer;
	
	select datastore_id into old_datastore_id
	from "SCHEMA"."DISK_CURRENT"
	where id = disk_id;
	
	select datastore into actual_datastore
	from "SCHEMA"."DISK_DATASTORE"
	where id = old_datastore_id;

	if actual_datastore != user_disk_datastore then
	begin

	insert into "SCHEMA"."CHANGES_DATES"(time, user)
	values(now(), user());
	select current_identity_value() into THIS_CHANGE from dummy;

	select datastore_id, name_id INTO old_id, this_disk_name
	from "SCHEMA"."DISK_CURRENT"
	where id = disk_id;

	insert into "SCHEMA"."DISK_DATASTORE"(previous_id, change_id, datastore, disk_id, vm_name_id, disk_name_id)
	values(old_id, this_change, user_disk_datastore, disk_id, update_name_id, this_disk_name);
	select current_identity_value() into this_datastore from dummy;

	update "SCHEMA"."DISK_CURRENT"
	set  datastore_id = this_datastore
	where id = datastore_id;

	end;

	end if;

END;