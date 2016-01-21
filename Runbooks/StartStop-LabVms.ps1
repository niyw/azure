workflow StartStop-LabVms
{
   Param
    (   
		[Parameter(Mandatory=$true)]
        [Boolean]
		$Shutdown
    )
	
	$AzureResourceGroup="LabVmRG"
	$vmlist="dcvm0","bevm0","mdvm0","mdvm1","fevm0","fevm1"

	#The name of the Automation Credential Asset this runbook will use to authenticate to Azure.
    $CredentialAssetName = "DefaultAzureCredential";
	
	#Get the credential with the above name from the Automation Asset store
    $Cred = Get-AutomationPSCredential -Name $CredentialAssetName
    if(!$Cred) {
        Throw "Could not find an Automation Credential Asset named '${CredentialAssetName}'. Make sure you have created one in this Automation Account."
    }

    #Connect to your Azure Account   	
	Add-AzureRmAccount -Credential $Cred

	if($Shutdown -eq $true){
        Write-Output "Stopping VMs in '$($AzureResourceGroup)' resource group";
        for($i=$vmlist.Count-1;$i -ge 0;$i--){
            Write-Output "Stopping '$($vmlist[$i])' ...";
            Stop-AzureRmVM -ResourceGroupName $AzureResourceGroup -Name $vmlist[$i] -Force
        }
	}
	else{
		Write-Output "Starting VMs in '$($AzureResourceGroup)' resource group";
		for($i=0;$i -lt $vmlist.Count;$i++){
            Write-Output "Starting '$($vmlist[$i])' ...";
	        Start-AzureRmVM -ResourceGroupName $AzureResourceGroup -Name $vmlist[$i]
        }
	}
}