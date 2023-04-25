# Created by Arthur Duarte
# https://github.com/DimplyKhan13/VMwareLog_Hana.git

import lib.vmwareLib as vmware
import lib.loghanaLib as logdb

myVmware = vmware.VMWare()
mydb = logdb.LogDB()

if (myVmware.isConnected() and mydb.isConnected()):

    if (myVmware.getHosts()):

        vmware_list = myVmware.printVmList()
        logdb_list = mydb.printVmList()

        new_vms_ids = list(set(vmware_list) - set(logdb_list))
        if len(new_vms_ids) > 0:
            vms_to_add = myVmware.printVms(new_vms_ids)
            mydb.addVms(vms_to_add)

        deleted_vms_ids = list(set(logdb_list) - set(vmware_list))
        if len(deleted_vms_ids) > 0:
            mydb.delVms(deleted_vms_ids)

        logdb_odest_ids = mydb.printOldestCheck()
        if len(logdb_odest_ids) > 0:
            vms_to_update = myVmware.printVms(logdb_odest_ids)
            mydb.updateVms(vms_to_update)

myVmware.disconnect()