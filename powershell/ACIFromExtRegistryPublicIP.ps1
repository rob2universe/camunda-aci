if ( (-not $myreguser) -and (-not $regpasswd)) {
    $myreguser = Read-Host -Prompt 'Camunda registry user?'
    $regpasswd = ConvertTo-SecureString (Read-Host -Prompt 'Camunda registry password?') -AsPlainText -Force
}
$myregcred = New-Object System.Management.Automation.PSCredential ($myreguser, $regpasswd)
$rgName = "rg-camunda"
$accountName = "robsapacstorage"
$shareName = "camundashare"
$containerGroupName = 'camunda-containers'
$dnsName = 'camunda-apac'
$image = 'registry.camunda.cloud/cambpm-ee/camunda-bpm-platform-ee:run-7.15.0'
$server = 'registry.camunda.cloud'
$envvar = @{'SPRING_APPLICATION_JSON' = '{"spring.datasource.url":"jdbc:h2:/mnt/azfile/camunda-h2-default/process-engine;TRACE_LEVEL_FILE=0;DB_CLOSE_ON_EXIT=FALSE","camunda.bpm.run.auth.enabled":"true"}' }
#$envvar = @{"SPRING_APPLICATION_JSON"='{"spring.datasource.url":"jdbc:h2:/mnt/azfile/camunda-h2-default/process-engine;TRACE_LEVEL_FILE=0;DB_CLOSE_ON_EXIT=FALSE"}'; "camunda.bpm.run.auth.enabled"="true"}
#'SPRING_APPLICATION_JSON='{"camunda.bpm.run.auth.enabled":"true"}''
$storageKey = $(az storage account keys list -g $rgName --account-name $accountName --query "[0].value" --output tsv)
$mysharecred = New-Object System.Management.Automation.PSCredential ($accountName, (ConvertTo-SecureString $storageKey -AsPlainText -Force))

Write-Host "`n Initialization completed. Creating container group $containerGroupName ... `n"
$aci = New-AzContainerGroup -ResourceGroupName $rgName -Name $containerGroupName -Image $image -RegistryServer $server `
    -RegistryCredential $myregcred -DnsNameLabel $dnsName -OsType Linux -IpAddressType Public -Port @(8080) -Cpu 1 -MemoryInGB 0.5 `
    -AzureFileVolumeShareName $shareName -AzureFileVolumeAccountCredential $mysharecred -AzureFileVolumeMountPath /mnt/azfile `
    -EnvironmentVariable $envvar
$aci

az container logs -g $rgName -n $containerGroupName

$ENV:AZURE_STORAGE_ACCOUNT = $accountName
$ENV:AZURE_STORAGE_KEY = $storageKey
az storage file list -s $shareName -o table