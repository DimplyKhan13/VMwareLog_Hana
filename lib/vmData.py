# Created by Arthur Duarte
# https://github.com/DimplyKhan13/VMwareLog_Hana.git

class vmData:

    def __init__(self, id) -> None:
        self.id = id
        self.name = None
        self.memory = None
        self.cpu = None
        self.state = None
        self.isDeleted = None
        self.disks = []

    def update(self, name=None, memory=None, cpu=None, state=None, isDeleted=None):

        if name is not None:
            self.name = name

        if memory is not None:
            self.memory = memory

        if cpu is not None:
            self.cpu = cpu

        if state is not None:
            self.state = state

        if isDeleted is not None:
            self.isDeleted = isDeleted

    def getID(self):
        return self.id

    def getName(self):
        return self.name

    def getCpu(self):
        return self.cpu

    def getMemory(self):
        return self.memory

    def getState(self):
        return self.state

    def getDisks(self):
        return self.disks

    def addDisk(self, disk_id, name, datastore, capacity):
        self.disks.append({
            'disk_id': disk_id,
            'name': name,
            'datastore': datastore,
            'capacity': capacity
        })