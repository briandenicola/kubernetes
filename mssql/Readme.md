# Always On Read Replicas with SQL Server 2019 on AKS 

## Overview 
SQL Server has had the ability to run on Linux and inside of a Docker container since its 2017 release. This document shows an example of how it can be configured to run in an Always On Read-replica configuration.  

## Always On Cluster Types
* None -  Sets ups a SQL Server Always On Availability Group (AG) for read-scale workloads on Linux. 
    * Read-replicas is not HA. Failovers are manual and could have potential data loss
* External - Sets up a SQL Server Always On Availability Group (AG) for HA. 
    * Require something like Pacemaker installed to create a cluster but not supported on AKS at this time

## Notes and Caveats
* Deploys 2 StatefulSet pods in AKS in the Default namespace 
    * This is to maintain DNS name across pod recycles 
    * Each pod is independent inside AKS with their own Internal Load Balancer 
    * Pods can be across Availability Zones if deployed in an Azure region that supports zones
    * Each pod has its own PVC Azure Managed Disk attached. All Databases are stored on this drive
* Added the follow DNS records into my DNS server / local host file 
    * sql.bjdazure.tech - Primary Service IP Address (mssqlsvc0)
    * mssqlsvc0.bjdazure.tech - Primary Service IP Address
    * mssqlsvc1.bjdazure.tech - Secondary Service IP Address
* Using Kubernete's internal DNS naming for parts of the configuration - *.default.svc.cluster.local. 
    * This is what the pods know as their DNS name inside AKS
    * _TBD - Update to external DNS names if possible_
* AG Listeners needs to be set to the primary pod's internal IP address.
    * If that pod cycles then this IP Address needs to be updated (along with reestbalishing synchronization) 
    * _TBD - What other options do we have here_
* The configuration will create only Azure Internal Load Balancers. No public IP Addresses will be used. 
    * Will require connectivity to the virtual network where AKS is deployed

## References
* https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-availability-group-overview?view=sql-server-ver15
* https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-availability-group-configure-rs?view=sql-server-ver15
* https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-availability-group-cluster-ubuntu?view=sql-server-ver15
* https://docs.microsoft.com/en-us/sql/database-engine/availability-groups/windows/create-or-configure-an-availability-group-listener-sql-server?view=sql-server-ver15

# Prerequisites
* Azure AKS cluster with at least two nodes
* kubectl
* PowerShell 7.0 on either Windows or Linux 
* SQL Management Studio or SqlServer PowerShell cmdlets
* Optional: My [bjd.Common.Functions PowerShell module](https://github.com/briandenicola/PSScripts/packages/)
* Generate Master Key Password - New-Password -Length 25 -ExcludedSpecialCharacters 
    * Will be refered to as MKEY_PASSWORD in the rest of the documentation. Replace with real values as required
* Generate Primary Password - New-Password -Length 25 -ExcludedSpecialCharacters 
    * Will be refered to as PRIMARY_PASSWORD in the rest of the documentation. Replace with real values as required
* Generate Base64 Encoded SA Password - ConvertTo-Base64EncodedString -Text (New-Password -Length 25 -ExcludedSpecialCharacters)
    * Will be refered to as SA_PASSWORD in the rest of the documentation. Replace with real values as required

# Setups
0. Update mssql2019-stateful-alwayson-read-replica.yaml
    * Replace ~REPLACE~WITH~BASE64~ENCODE~PASSWORD~ with SA_PASSWORD
1. Create SQL Servers
    * kubectl apply -f ./mssql2019-stateful-alwayson-read-replica.yaml
2. Launch SQL Management Studio and log into both SQL instances
3. On the Primary Instance, create certificate for authentication
```
	CREATE MASTER KEY ENCRYPTION BY PASSWORD = '~MKEY_PASSWORD~';
	CREATE CERTIFICATE dbm_certificate WITH SUBJECT = 'dbm';
	BACKUP CERTIFICATE dbm_certificate
	   TO FILE = '/var/opt/mssql/data/dbm_certificate.cer'
	   WITH PRIVATE KEY (
            FILE = '/var/opt/mssql/data/dbm_certificate.pvk',
            ENCRYPTION BY PASSWORD = '~PRIMARY_PASSWORD~'
        );
```
4. Copy certifications to secondary instance
    * kubectl exec -it sqlserver0-0 -- tar -cvf /tmp/certs.tar  /var/opt/mssql/data/dbm_certificate.*
	* kubectl cp sqlserver0-0:tmp/certs.tar certs.tar
	* kubectl cp certs.tar sqlserver1-0:tmp/
	* kubectl exec -it sqlserver1-0 -- tar -xf /tmp/certs.tar -C /var/opt/mssql/data/
5. Import Certificate on Secondary
```
	CREATE MASTER KEY ENCRYPTION BY PASSWORD = '~MKEY_PASSWORD~';
	CREATE CERTIFICATE dbm_certificate
	    FROM FILE = '/var/opt/mssql/data/dbm_certificate.cer'
	    WITH PRIVATE KEY (
	        FILE = '/var/opt/mssql/data/dbm_certificate.pvk',
	        DECRYPTION BY PASSWORD = '~PRIMARY_PASSWORD~'
	    );
```
6. Restore AdenvtureWorks 2019 on Primary
    * https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2019.bak
    * Set Recovery Mode to Full
    * Take back after retore is complete

7. On each instance, create the Database Mirroring Listener 
```
	CREATE ENDPOINT [Hadr_endpoint]
	    AS TCP (LISTENER_PORT = 5022)
	    FOR DATABASE_MIRRORING (
		    ROLE = ALL,
		    AUTHENTICATION = CERTIFICATE dbm_certificate,
			ENCRYPTION = REQUIRED ALGORITHM AES
		);
    ALTER ENDPOINT [Hadr_endpoint] STATE = STARTED;
```
8. Create the Availabilty Group from the primary instance and add Database
```
    CREATE AVAILABILITY GROUP [linux-demo03]
        WITH (CLUSTER_TYPE = NONE)
        FOR REPLICA ON
            N'sqlserver0-0' WITH (
                ENDPOINT_URL = N'tcp://sqlserver0-0.mssqlsvc0.default.svc.cluster.local:5022',
                AVAILABILITY_MODE = SYNCHRONOUS_COMMIT,
                FAILOVER_MODE = MANUAL,
                SEEDING_MODE = AUTOMATIC,
                PRIMARY_ROLE (
                    READ_ONLY_ROUTING_LIST=('sqlserver1-0')
                ),
                SECONDARY_ROLE (
                    ALLOW_CONNECTIONS = ALL,
                    READ_ONLY_ROUTING_URL ='TCP://sqlserver0-0.mssqlsvc0.default.svc.cluster.local:1433'
                )
            ),
            N'sqlserver1-0' WITH ( 
                ENDPOINT_URL = N'tcp://sqlserver1-0.mssqlsvc1.default.svc.cluster.local:5022', 
                AVAILABILITY_MODE = SYNCHRONOUS_COMMIT,
                FAILOVER_MODE = MANUAL,
                SEEDING_MODE = AUTOMATIC,
                SECONDARY_ROLE ( 
                    ALLOW_CONNECTIONS = ALL,
                    READ_ONLY_ROUTING_URL ='TCP://sqlserver1-0.mssqlsvc1.default.svc.cluster.local:1433'
                )
            );
    ALTER AVAILABILITY GROUP [linux-demo03] GRANT CREATE ANY DATABASE;
```
9. Add Database
```
    ALTER AVAILABILITY GROUP [linux-demo03] ADD DATABASE [AdventureWorks2019];
```
10. Get Primary and Secondary Pod's pod IP Address
* kubectl get pod sqlserver0-0 -o json | jq ".status.podIPs[0].ip" (~PRIMARY_REPLICA_POD_IP~)
11. Create Availabilty Group Listener 
```
    ALTER AVAILABILITY GROUP [linux-demo03] ADD LISTENER 'sql' ( 
        WITH IP (('~PRIMARY_REPLICA_POD_IP~','255.255.255.255')), 
        PORT = 1440
    );
    SELECT * FROM sys.dm_tcp_listener_states;
```
12. Join the cluster from the secondary
```
    ALTER AVAILABILITY GROUP [linux-demo03] JOIN WITH (CLUSTER_TYPE = NONE);
    ALTER AVAILABILITY GROUP [linux-demo03] GRANT CREATE ANY DATABASE;
```

# Test and Validation
## Connectivity 
1. Test-NetConnection -ComputerName mssqlsvc0.bjdazure.tech -Port 1433
2. Test-NetConnection -ComputerName mssqlsvc1.bjdazure.tech -Port 1433
3. Test-NetConnection -ComputerName sql.bjdazure.tech -Port 1440

## Read Replica
1. Test Insert off Primary Replica. Should Proceed without Error
```
    $query = "Insert into Person.Address ([AddressLine1], [City], [StateProvinceID], [PostalCode]) values ('101 anywhere drive', 'usa', 79, '55555')"
    $standardConStr = "Server=tcp:sql.bjdazure.tech,1440;Database=AdventureWorks2019;User Id=sa;password=...;Trusted_Connection=False;MultiSubnetFailover=True"
    Invoke-Sqlcmd -ConnectionString $standardConStr -Query $query
```
2. Test Read off Read Replica. Should Receive - One result back
```
    $query = "Select top 1 * from Person.Address where [PostalCode] = '55555'"
    $readIntentConStr = "Server=tcp:sql.bjdazure.tech,1440;Database=AdventureWorks2019;User Id=sa;password=...;Trusted_Connection=False;ApplicationIntent=ReadOnly;MultiSubnetFailover=True"
    Invoke-Sqlcmd -ConnectionString $readIntentConStr -Query $query
```
3. Test Inserting on Read Replica. Should Receive - Invoke-Sqlcmd: Failed to update database "AdventureWorks2019" because the database is read-only.
```
    $query = "Insert into Person.Address ([AddressLine1], [City], [StateProvinceID], [PostalCode]) values ('102 anywhere drive', 'usa', 79, '55555')"
    $readIntentConStr = "Server=tcp:sql.bjdazure.tech,1440;Database=AdventureWorks2019;User Id=sa;password=...;Trusted_Connection=False;ApplicationIntent=ReadOnly;MultiSubnetFailover=True"
    Invoke-Sqlcmd -ConnectionString $readIntentConStr -Query $query
```

## Failover 
1. On current Primary  - ALTER AVAILABILITY GROUP [linux-demo03] OFFLINE
2. On current Secondary - ALTER AVAILABILITY GROUP [linux-demo03] FORCE_FAILOVER_ALLOW_DATA_LOSS;
3. Demote to old Primary to Secondary - ALTER AVAILABILITY GROUP [linux-demo03] SET (ROLE = SECONDARY);