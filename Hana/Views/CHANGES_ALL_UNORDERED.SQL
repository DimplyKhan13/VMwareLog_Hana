-- Created by Arthur Duarte
-- https://github.com/DimplyKhan13/VMwareLog_Hana.git

CREATE VIEW "SCHEMA"."CHANGES_ALL_UNORDERED" ( "TYPE_ID",
    "TIME",
    "TYPE",
    "NOME_VM",
    "CPU",
    "MEMORY",
    "CPU_ANTIGO",
    "MEMORIA_ANTIGA",
    "NOME_ANTIGO_VM",
    "NOME_DISCO",
    "NOME_ANTIGO_DISCO",
    "DATASTORE_DISCO",
    "DATASTORE_ANTIGO_DISCO",
    "CAPACIDADE_DISCO",
    "CAPACIDADE_ANTIGO_DISCO" ) 
    AS (((((((((
                (SELECT
                    1 AS "TYPE_ID",
                    "VM_CHANGES_CREATED"."TIME" AS "TIME",
                    'VM - CRIACAO' AS "TYPE",
                    "VM_CHANGES_CREATED"."NAME" AS "NOME_VM",
                    "VM_CHANGES_CREATED"."CPU" AS "CPU",
                    "VM_CHANGES_CREATED"."MEMORY" AS "MEMORY",
                    NULL AS "CPU_ANTIGO",
                    NULL AS "MEMORIA_ANTIGA",
                    NULL AS "NOME_ANTIGO_VM",
                    NULL AS "NOME_DISCO",
                    NULL AS "NOME_ANTIGO_DISCO",
                    NULL AS "DATASTORE_DISCO",
                    NULL AS "DATASTORE_ANTIGO_DISCO",
                    NULL AS "CAPACIDADE_DISCO",
                    NULL AS "CAPACIDADE_ANTIGO_DISCO" 
                FROM "VM_CHANGES_CREATED") 
		UNION   (SELECT
                    3 AS "TYPE_ID",
                    "VM_CHANGES_NAME"."TIME" AS "TIME",
                    'VM - ALTERACAO DE NOME' AS "TYPE",
                    "VM_CHANGES_NAME"."NEW_NAME" AS "NOME_VM",
                    NULL AS "CPU",
                    NULL AS "MEMORY",
                    NULL AS "CPU_ANTIGO",
                    NULL AS "MEMORIA_ANTIGA",
                    "VM_CHANGES_NAME"."OLD_NAME" AS "NOME_ANTIGO_VM",
                    NULL AS "NOME_DISCO",
                    NULL AS "NOME_ANTIGO_DISCO",
                    NULL AS "DATASTORE_DISCO",
                    NULL AS "DATASTORE_ANTIGO_DISCO",
                    NULL AS "CAPACIDADE_DISCO",
                    NULL AS "CAPACIDADE_ANTIGO_DISCO" 
                FROM "VM_CHANGES_NAME" 
                WHERE "VM_CHANGES_NAME"."OLD_NAME" IS NOT NULL)) 
        UNION   (SELECT
                    5 AS "TYPE_ID",
                    "VM_CHANGES_CPU"."TIME" AS "TIME",
                    'VM - ALTERACAO DE CPU' AS "TYPE",
                    "VM_CHANGES_CPU"."NAME" AS "NOME_VM",
                    "VM_CHANGES_CPU"."NEW_CPU_VALUE" AS "CPU",
                    NULL AS "MEMORY",
                    "VM_CHANGES_CPU"."OLD_CPU_VALUE" AS "CPU_ANTIGO",
                    NULL AS "MEMORIA_ANTIGA",
                    NULL AS "NOME_ANTIGO_VM",
                    NULL AS "NOME_DISCO",
                    NULL AS "NOME_ANTIGO_DISCO",
                    NULL AS "DATASTORE_DISCO",
                    NULL AS "DATASTORE_ANTIGO_DISCO",
                    NULL AS "CAPACIDADE_DISCO",
                    NULL AS "CAPACIDADE_ANTIGO_DISCO" 
                FROM "VM_CHANGES_CPU" 
                WHERE "VM_CHANGES_CPU"."OLD_CPU_VALUE" IS NOT NULL)) 
        UNION   (SELECT
                    6 AS "TYPE_ID",
                    "VM_CHANGES_MEMORY"."TIME" AS "TIME",
                    'VM - ALTERACAO DE MEMORIA' AS "TYPE",
                    "VM_CHANGES_MEMORY"."NAME" AS "NOME_VM",
                    NULL AS "CPU",
                    "VM_CHANGES_MEMORY"."NEW_MEMORY_VALUE" AS "MEMORY",
                    NULL AS "CPU_ANTIGO",
                    "VM_CHANGES_MEMORY"."OLD_MEMORY_VALUE" AS "MEMORIA_ANTIGA",
                    NULL AS "NOME_ANTIGO_VM",
                    NULL AS "NOME_DISCO",
                    NULL AS "NOME_ANTIGO_DISCO",
                    NULL AS "DATASTORE_DISCO",
                    NULL AS "DATASTORE_ANTIGO_DISCO",
                    NULL AS "CAPACIDADE_DISCO",
                    NULL AS "CAPACIDADE_ANTIGO_DISCO" 
                    FROM "VM_CHANGES_MEMORY" 
                    WHERE "VM_CHANGES_MEMORY"."OLD_MEMORY_VALUE" IS NOT NULL)) 
        UNION   (SELECT
                    4 AS "TYPE_ID",
                    "VM_CHANGES_DELETED"."TIME" AS "TIME",
                    'VM - REMOCAO' AS "TYPE",
                    "VM_CHANGES_DELETED"."NAME" AS "NOME_VM",
                    NULL AS "CPU",
                    NULL AS "MEMORY",
                    NULL AS "CPU_ANTIGO",
                    NULL AS "MEMORIA_ANTIGA",
                    NULL AS "NOME_ANTIGO_VM",
                    NULL AS "NOME_DISCO",
                    NULL AS "NOME_ANTIGO_DISCO",
                    NULL AS "DATASTORE_DISCO",
                    NULL AS "DATASTORE_ANTIGO_DISCO",
                    NULL AS "CAPACIDADE_DISCO",
                    NULL AS "CAPACIDADE_ANTIGO_DISCO" 
                FROM "VM_CHANGES_DELETED")) 
        UNION   (SELECT
                    10 AS "TYPE_ID",
                    "DISK_CHANGES_NAME"."TIME" AS "TIME",
                    'DISCO - ALTERACAO DE NOME' AS "TYPE",
                    "DISK_CHANGES_NAME"."VM_NAME" AS "NOME_VM",
                    NULL AS "CPU",
                    NULL AS "MEMORY",
                    NULL AS "CPU_ANTIGO",
                    NULL AS "MEMORIA_ANTIGA",
                    NULL AS "NOME_ANTIGO_VM",
                    "DISK_CHANGES_NAME"."NEW_DISK_NAME" AS "NOME_DISCO",
                    "DISK_CHANGES_NAME"."OLD_DISK_NAME" AS "NOME_ANTIGO_DISCO",
                    NULL AS "DATASTORE_DISCO",
                    NULL AS "DATASTORE_ANTIGO_DISCO",
                    NULL AS "CAPACIDADE_DISCO",
                    NULL AS "CAPACIDADE_ANTIGO_DISCO" 
                FROM "DISK_CHANGES_NAME" 
                WHERE "DISK_CHANGES_NAME"."OLD_DISK_NAME" IS NOT NULL)) 
        UNION   (SELECT
                    9 AS "TYPE_ID",
                    "DISK_CHANGES_DATASTORE"."TIME" AS "TIME",
                    'DISCO - ALTERACAO DE DATASTORE' AS "TYPE",
                    "DISK_CHANGES_DATASTORE"."VM_NAME" AS "NOME_VM",
                    NULL AS "CPU",
                    NULL AS "MEMORY",
                    NULL AS "CPU_ANTIGO",
                    NULL AS "MEMORIA_ANTIGA",
                    NULL AS "NOME_ANTIGO_VM",
                    "DISK_CHANGES_DATASTORE"."DISK_NAME" AS "NOME_DISCO",
                    NULL AS "NOME_ANTIGO_DISCO",
                    "DISK_CHANGES_DATASTORE"."NEW_DISK_DATASTORE" AS "DATASTORE_DISCO",
                    "DISK_CHANGES_DATASTORE"."OLD_DISK_DATASTORE" AS "DATASTORE_ANTIGO_DISCO",
                    NULL AS "CAPACIDADE_DISCO",
                    NULL AS "CAPACIDADE_ANTIGO_DISCO" 
                FROM "DISK_CHANGES_DATASTORE" 
                WHERE "DISK_CHANGES_DATASTORE"."OLD_DISK_DATASTORE" IS NOT NULL)) 
        UNION   (SELECT
                    8 AS "TYPE_ID",
                    "DISK_CHANGES_CAPACITY"."TIME" AS "TIME",
                    'DISCO - ALTERACAO DE CAPACIDADE' AS "TYPE",
                    "DISK_CHANGES_CAPACITY"."VM_NAME" AS "NOME_VM",
                    NULL AS "CPU",
                    NULL AS "MEMORY",
                    NULL AS "CPU_ANTIGO",
                    NULL AS "MEMORIA_ANTIGA",
                    NULL AS "NOME_ANTIGO_VM",
                    "DISK_CHANGES_CAPACITY"."DISK_NAME" AS "NOME_DISCO",
                    NULL AS "NOME_ANTIGO_DISCO",
                    "DISK_CHANGES_CAPACITY"."DATASTORE" AS "DATASTORE_DISCO",
                    NULL AS "DATASTORE_ANTIGO_DISCO",
                    "DISK_CHANGES_CAPACITY"."NEW_DISK_CAPACITY" AS "CAPACIDADE_DISCO",
                    "DISK_CHANGES_CAPACITY"."OLD_DISK_CAPACITY" AS "CAPACIDADE_ANTIGO_DISCO" 
				FROM "DISK_CHANGES_CAPACITY" 
				WHERE "DISK_CHANGES_CAPACITY"."OLD_DISK_CAPACITY" IS NOT NULL)) 
		UNION   (SELECT
                    2 AS "TYPE_ID",
                    "DISK_CHANGES_CREATED"."TIME" AS "TIME",
                    'DISCO - CRIACAO' AS "TYPE",
                    "DISK_CHANGES_CREATED"."VM_NAME" AS "NOME_VM",
                    NULL AS "CPU",
                    NULL AS "MEMORY",
                    NULL AS "CPU_ANTIGO",
                    NULL AS "MEMORIA_ANTIGA",
                    NULL AS "NOME_ANTIGO_VM",
                    "DISK_CHANGES_CREATED"."DISK_NAME" AS "NOME_DISCO",
                    NULL AS "NOME_ANTIGO_DISCO",
                    "DISK_CHANGES_CREATED"."DATASTORE" AS "DATASTORE_DISCO",
                    NULL AS "DATASTORE_ANTIGO_DISCO",
                    "DISK_CHANGES_CREATED"."CAPACITY" AS "CAPACIDADE_DISCO",
                    NULL AS "CAPACIDADE_ANTIGO_DISCO" 
			    FROM "DISK_CHANGES_CREATED")) 
	    UNION   (SELECT
                    7 AS "TYPE_ID",
                    "DISK_CHANGES_DELETED"."TIME" AS "TIME",
                    'DISCO - REMOCAO' AS "TYPE",
                    "DISK_CHANGES_DELETED"."VM_NAME" AS "NOME_VM",
                    NULL AS "CPU",
                    NULL AS "MEMORY",
                    NULL AS "CPU_ANTIGO",
                    NULL AS "MEMORIA_ANTIGA",
                    NULL AS "NOME_ANTIGO_VM",
                    "DISK_CHANGES_DELETED"."DISK_NAME" AS "NOME_DISCO",
                    NULL AS "NOME_ANTIGO_DISCO",
                    NULL AS "DATASTORE_DISCO",
                    NULL AS "DATASTORE_ANTIGO_DISCO",
                    NULL AS "CAPACIDADE_DISCO",
                    NULL AS "CAPACIDADE_ANTIGO_DISCO" 
	        	FROM "DISK_CHANGES_DELETED")) 
    WITH READ ONLY