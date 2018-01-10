#Assumes that script is being ran with admin rights
param(
    [Parameter(Mandatory=$True)]
    [string]$serviceName
)
$service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
if ($service -eq $null)
{
    Write-Output "The '$serviceName' service does not seem to be installed on $env:ComputerName.$env:UserDomain"
    Write-Output "Skipping stop/delete steps"
}
else {
    Write-Output "Found the '$serviceName' service."
    Write-Output "Stopping the '$serviceName' service."
    Stop-Service -InputObject $service 
    Write-Output "The '$serviceName' service has been stopped."
    $service = Get-WmiObject -Class win32_Service -Filter "Name='$serviceName'"
    Write-Output "Attempting to delete the '$serviceName' service"
    $result = $service.delete()
    if ($result.ReturnValue -ne 0){
        $errorMessage = "Failed to delete the '$serviceName' service with an error code of $($result.ReturnValue).`n"
        $helpMessage = "Please refer to https://msdn.microsoft.com/en-us/library/aa389960(v=vs.85).aspx for more information on the error code" 
        throw ($errorMessage + $helpMessage)
    }
    else{
        Write-Output "Successfully deleted the '$serviceName' service"
    }
}
