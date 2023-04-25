-- Created by Arthur Duarte
-- https://github.com/DimplyKhan13/VMwareLog_Hana.git

CREATE PROCEDURE "SCHEMA"."DELDISK"(

	in user_vm_id varchar(50),
	in user_disk_vmware_id varchar(50)

) LANGUAGE SQLSCRIPT
SQL SECURITY
DEFINER AS
BEGIN

	declare this_change integer;
	declare this_disk integer;
	declare this_disk_name integer;
	declare this_vm integer;
	declare this_vm_id varchar(50);


	if (select count(*) from "SCHEMA"."DISK_CURRENT" where 
	vm_id = user_vm_id and vmware_disk_id = user_disk_vmware_id)>0 then
	begin

	select id, name_id, vm_id into this_disk, this_disk_name, this_vm_id from "SCHEMA"."DISK_CURRENT" where vm_id = user_vm_id and vmware_disk_id = user_disk_vmware_id;
	select name_id into this_vm from "SCHEMA"."VM_CURRENT" where vm_id = this_vm_id;

	call "SCHEMA"."UPDATEDISK"(user_vm_id, '-', user_disk_vmware_id, 0, '-');

	insert into "SCHEMA"."CHANGES_DATES"(time, user)
	values(now(), user());
	select current_identity_value() into THIS_CHANGE from dummy;

	UPDATE "SCHEMA"."DISK_CURRENT"
	SET is_deleted = 1
	WHERE id = this_disk;

	insert into "SCHEMA"."DISK_DELETED"(is_deleted, change_id, disk_id, vm_name_id, disk_name_id)
	values(1, this_change, this_disk, this_vm, this_disk_name);

	end;
	end if;
END;