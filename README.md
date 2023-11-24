# Azure SQL Security

Implementation of advanced SQL Server security features following [best practices][1].

Create the baseline infrastructure:

```sh
terraform init
terraform apply -auto-approve
```

## Always Encrypted

Secure enclaves [supported][2] are:

- VBS (Virtual) 👈 We'll use this one.
- SGX (Hardware)

Activate the "Always Encrypted" functionality:

```sh
az sql db update -g rg-bigbank79 -s sqls-bigbank79 -n sqldb-bigbank79 --preferred-enclave-type VBS
```

> For details on next steps check the official [documentation][3] tutorial.

Using **SSMS**, connect to the database with Always Encrypted **disabled**.

Create some data running the following files:

1. [`tsql/schema.sql`](sql/schema.sql)
2. [`tsql/data.sql`](sql/data.sql)

Now create the Always Encrypted keys:

1. CMK1 (Column master key)
2. CEK1 (Column encryption key)

<img src=".assets/mssql-alwaysencrypted.png" />

The Key Vaults keys should already be available for selection.

Reconnect to the database with Always Encrypted **enabled** (with Secure Enclaves, but no attestation).

Encrypt the `SSN` and `Salary` columns:

- [`tsql/encrypt.sql`](tsql/encrypt.sql)

Within the enabled session, it is possible to run [`rich queries`](tsql/richqueries.sql)

Now, connect to a new session with Always Encrypt **disabled**.

Querying results from a disabled session will now show encrypted values:

<img src=".assets/mssql-alwaysencrypted-results.png" />


### Column encryption

### Row encryption
    

## Auditing

Default audit:

```
BATCH_COMPLETED_GROUP
SUCCESSFUL_DATABASE_AUTHENTICATION_GROUP
FAILED_DATABASE_AUTHENTICATION_GROUP
```


Ledger
TDE
Always

CMK - Requires KeyVault purge protection


[1]: https://learn.microsoft.com/en-us/sql/relational-databases/security/sql-server-security-best-practices?view=sql-server-ver16
[2]: https://learn.microsoft.com/en-us/sql/relational-databases/security/encryption/always-encrypted-enclaves?view=sql-server-ver16#supported-enclave-technologies
[3]: https://learn.microsoft.com/en-us/azure/azure-sql/database/always-encrypted-enclaves-getting-started-vbs?view=azuresql&tabs=ssmsrequirements%2Cazure-cli
