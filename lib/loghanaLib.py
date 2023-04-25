# Created by Arthur Duarte
# https://github.com/DimplyKhan13/VMwareLog_Hana.git

from hdbcli import dbapi

CONNECTION = {
    'host': "host_addr",
    'port': "30015",
    'user': "user",
    'password': "pass"
}
SCHEMA = "\"your_schema\""
class LogDB:

    def __init__(self) -> None:
        self.connection = False
        try:
            self.mydb = dbapi.connect(
                address=CONNECTION["host"],
                port=CONNECTION["port"],
                user=CONNECTION["user"],
                password=CONNECTION["password"]
            )
            self.connection = True

        except dbapi.Error as this_error:
            print("ERRO - Houve um erro na conexão do banco.")
            print(this_error)
            self.connection = False

    def printVmList(self):
        vm_list = []

        cursor = self.mydb.cursor()

        cursor.execute("SET SCHEMA " + SCHEMA + " ;")
        cursor.execute("SELECT * FROM \"CURRENT_VM_DATA\";")

        rows = cursor.fetchall()

        for item in rows:
            vm_list.append(item[0])

        cursor.close()

        return vm_list

    def printOldestCheck(self):
        vm_list = []

        cursor = self.mydb.cursor()

        cursor.execute("SET SCHEMA " + SCHEMA + " ;")
        cursor.execute("SELECT * FROM \"OLDEST_CHECK\";")

        rows = cursor.fetchall()

        for item in rows:
            vm_list.append(item[0])

        cursor.close()

        return vm_list

    def addVms(self, add_list):
        for vm_add in add_list:

            query = "call ADDVIRTUALMACHINE('" + vm_add.getID() + "', '" + vm_add.getName()[:30] + "', " + str(vm_add.getCpu()) + ", " + str(vm_add.getMemory()) + ", " + str(vm_add.getState()) + ");" # noqa
            
            cursor = self.mydb.cursor()
            cursor.execute("SET SCHEMA " + SCHEMA + " ;")
            cursor.execute(query)

            self.mydb.commit()
            cursor.close()

            disk_list = vm_add.getDisks()
            self.checkDisk(vm_add.getID(), disk_list)

    def delVms(self, del_list):
        for vm_del in del_list:

            query = "call DELVIRTUALMACHINE('" + vm_del + "');"
            print(query)

            cursor = self.mydb.cursor()
            cursor.execute("SET SCHEMA " + SCHEMA + " ;")
            cursor.execute(query)

            self.mydb.commit()
            cursor.close()

            # self.checkDisk(vm_del, [])

    def updateVms(self, update_list):
        for vm_update in update_list:

            query = "call UPDATEVIRTUALMACHINE('" + vm_update.getID() + "', '" + vm_update.getName()[:30] + "', " + str(vm_update.getCpu()) + ", " + str(vm_update.getMemory()) + ", " + str(vm_update.getState()) + ");" # noqa
            print(query)

            cursor = self.mydb.cursor()
            cursor.execute("SET SCHEMA " + SCHEMA + " ;")
            cursor.execute(query)

            self.mydb.commit()
            cursor.close()

            disk_list = vm_update.getDisks()
            self.checkDisk(vm_update.getID(), disk_list)

    def isConnected(self):
        return self.connection

    def checkDisk(self, vm_id, vmware_disk_list):
        cursor = self.mydb.cursor()

        vmware_disk_list_id = [disk['disk_id'] for disk in vmware_disk_list]
        log_disk_list_id = []

        query = "select disk_id from \"CURRENT_DISK_DATA\" where vm_id = '" + vm_id + "';"
        cursor.execute(query)

        rows = cursor.fetchall()

        for item in rows:
            log_disk_list_id.append(item[0])

        cursor.close()

        delete_disk_id = list(set(log_disk_list_id) - set(vmware_disk_list_id))
        for disk in delete_disk_id:

            self.delDisk(
                vm_id,
                disk
            )

        create_disk_id = list(set(vmware_disk_list_id) - set(log_disk_list_id))
        for disk in create_disk_id:
            disk_data = next(item for item in vmware_disk_list if item['disk_id'] == disk)

            self.addDisk(
                vm_id, disk_data['name'],
                disk_data['disk_id'],
                disk_data['capacity'],
                disk_data['datastore']
            )

        update_disk_id = list(set(vmware_disk_list_id).intersection(set(log_disk_list_id)))
        for disk in update_disk_id:
            disk_data = next(item for item in vmware_disk_list if item['disk_id'] == disk)

            self.updateDisk(
                vm_id, disk_data['name'],
                disk_data['disk_id'],
                disk_data['capacity'],
                disk_data['datastore']
            )

    def addDisk(self, vm_id, disk_name, disk_id, capacity, datastore):
        cursor = self.mydb.cursor()

        query = "call ADDDISK('" + vm_id + "', '" + disk_name + "', '" + disk_id + "', " + str(capacity) + ", '" + datastore + "');" # noqa
        print(query)

        cursor = self.mydb.cursor()
        cursor.execute("SET SCHEMA " + SCHEMA + " ;")
        cursor.execute(query)

        self.mydb.commit()
        cursor.close()

    def delDisk(self, vm_id, disk_id):
        cursor = self.mydb.cursor()

        query = "call DELDISK('" + vm_id + "', '" + disk_id + "');"
        print(query)

        cursor = self.mydb.cursor()
        cursor.execute("SET SCHEMA " + SCHEMA + " ;")
        cursor.execute(query)

        self.mydb.commit()
        cursor.close()

    def updateDisk(self, vm_id, disk_name, disk_id, capacity, datastore):
        cursor = self.mydb.cursor()

        query = "call UPDATEDISK('" + vm_id + "', '" + disk_name + "', '" + disk_id + "', " + str(capacity) + ", '" + datastore + "');" # noqa
        print(query)
        
        cursor = self.mydb.cursor()
        cursor.execute("SET SCHEMA " + SCHEMA + " ;")
        cursor.execute(query)

        self.mydb.commit()
        cursor.close()
