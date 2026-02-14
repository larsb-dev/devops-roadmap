# Log Archive Tool

## Versions

- `log-archive` stores the archive locally in the directory where you run the script
- `log-archive-cloud` uploads the directory to an Azure Storage Account container

## Add scripts to `/usr/local/bin`

- This allows you to run `log-archive <log-director>` instead of `./log-archive`
- Make sure the execute bit is set for your user `chmod u+x filename`

## Store archive locally

```bash
log-archive /var/log/apache2
```

- Archives all apache2 logs as a `.tar.gz` file in the current working directory

## Store archive in the cloud

### Create Azure storage account

```bash
az storage account create \
  --name your_storage_account_name \
  --resource-group your_resource_group \
  --location your_location \
  --sku Standard_LRS
```

### Create container

```bash
az storage container create \
  --name linux_logs \
  --account-name your_storage_account_name
```

### Generate SAS token

- I did that in the portal, but you can also do it with the `az storage container generate-sas` command
- SAS tokens are pretty nice, because you don't have to log in and they also expire

### Export environment variables

```bash
export ACCOUNT_NAME=your_storage_account_name
export CONTAINER_NAME=your_container_name
export SAS_TOKEN=your_sas_token
```

### Execute

```bash
log-archive-cloud /var/log/apache2
``` 

## Resources

- [Upload a file to a storage blob](https://learn.microsoft.com/en-us/cli/azure/storage/blob?view=azure-cli-latest#az-storage-blob-upload)
