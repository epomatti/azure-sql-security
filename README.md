# Azure SQL Security

Create the baseline infrastructure:

```sh
terraform init
terraform apply -auto-approve
```

Activate the "Always Encrypted" functionality:

```sh
az sql db tde set -g rg-bigbank79 -s sqls-bigbank79 -d sqldb-bigbank79 --status Enabled
```

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
