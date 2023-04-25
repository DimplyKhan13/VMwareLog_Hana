# Created by Arthur Duarte
# https://github.com/DimplyKhan13/VMwareLog_Hana.git

from vconnector.core import VConnector
import lib.vmData as vmData
import pyVmomi
import os

CREDENTIALS = {
    'username': "user",
    'password': "pass"
}
VMWARE_SERVER = "server_addr"

ROOT_PATH = os.path.dirname(__file__)
VMWARE_CERT = os.path.join(ROOT_PATH, "..", "cert", "vmware.pem")

VM_PROPERTIES = ["name", "config.uuid", "config.hardware.numCPU",
                 "config.hardware.memoryMB", "guest.guestState",
                 "config.guestFullName", "config.hardware.device"]

class VMWare:

    def __init__(self) -> None:
        self.connection = False
        self.host_list = []
        try:
            self.getConnection()
        except: # noqa
            print("ERRO - Houve um erro na conexão VmWare.")
            self.connection = False

    def getConnection(self):
        self.vmware = VConnector(CREDENTIALS['username'], CREDENTIALS['password'], VMWARE_SERVER)
        self.vmware.connect()
        self.connection = True
        
    def getHosts(self):
        vm_view = self.vmware.get_vm_view()
        self.host_list = self.vmware.collect_properties(vm_view, pyVmomi.vim.VirtualMachine, VM_PROPERTIES)
        return True

    def printVmList(self):
        id_list = []
        for host in self.host_list:
            id_list.append(host['config.uuid'])
        return id_list

    def printVms(self, ids_list):
        
        vm_list = []

        for vm_id in ids_list:

            host_data = next(item for item in self.host_list if item['config.uuid'] == vm_id)
            new_vm = vmData.vmData(vm_id)

            new_vm.update(
                name=host_data['name'],
                memory=round(host_data['config.hardware.memoryMB']/1024),
                cpu=host_data['config.hardware.numCPU'],
                state=1 if host_data['guest.guestState'] == 'running' else 0,
                isDeleted=0
            )

            new_vm = self.addDiskData(new_vm, host_data)

            vm_list.append(new_vm)

        return vm_list

    def isConnected(self):
        return self.connection

    def addDiskData(self, vm_data, host_data):
        
        for device in host_data['config.hardware.device']:
            if isinstance(device, pyVmomi.vim.vm.device.VirtualDisk):
                vm_data.addDisk(
                    disk_id=device.backing.uuid,
                    name=device.deviceInfo.label,
                    datastore=device.backing.fileName.split(' ')[0],
                    capacity=device.capacityInBytes/(1024*1024*1024)
                )
            
        return vm_data

    def disconnect(self):
        self.vmware.disconnect()