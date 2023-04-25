-- Created by Arthur Duarte
-- https://github.com/DimplyKhan13/VMwareLog_Hana.git

CREATE PROCEDURE "SCHEMA"."UPDATEDISK"(
	
	in user_vm_id varchar(50),
	in user_disk_name varchar(50),
	in user_disk_vmware_id varchar(50),
	in user_disk_capacity integer,
	in user_disk_datastore varchar(90)

) LANGUAGE SQLSCRIPT
SQL SECURITY
DEFINER AS
BEGIN

	declare this_disk integer;
	declare this_vm_name_id integer;

	if (select count(*) from "SCHEMA"."DISK_CURRENT" where vm_id = user_vm_id and vmware_disk_id = user_disk_vmware_id)>0 then
	begin

	select id, name_id into this_disk, this_vm_name_id from "SCHEMA"."DISK_CURRENT" where vm_id = user_vm_id and vmware_disk_id = user_disk_vmware_id;

	call "SCHEMA"."UPDATEDISKDATASTORE"(this_disk, user_disk_datastore, this_vm_name_id);
	call "SCHEMA"."UPDATEDISKCAPACITY"(this_disk, user_disk_capacity, this_vm_name_id);
	call "SCHEMA"."UPDATEDISKNAME"(this_disk, user_disk_name, this_vm_name_id);

	update "SCHEMA"."DISK_CURRENT" set is_deleted = 0 where id = this_disk;

	end;

	else
	call "SCHEMA"."ADDDISK"(user_vm_id, user_disk_name, user_disk_vmware_id, user_disk_capacity, user_disk_datastore);

	end if;

END;