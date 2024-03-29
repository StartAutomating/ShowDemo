# Any *.PSA.ps1 file will be run when PSA runs.

# A good thing to do at the start of this file is to connect.

Connect-BlueSky

# If $env:AT_PROTOCOL_HANDLE or $env:AT_PROTOCOL_EMAIL is set, it will be treated as the username
# If $env:AT_PROTOCOL_APP_PASSWORD is set, it will be treated as the App Password.
# _Never_ use your actual BlueSky password

# Once we're connected, we can do anything our app password allows.

# However, you _might_ want to output some information first, so that you can see you're connected.

Get-BskyActorProfile -Actor $env:AT_PROTOCOL_HANDLE -Cache | Out-Host

# To ensure you're not going to send a skeet on every checkin, it's a good idea to ask what GitHub is up to

# There will be a variable, $GitHubEvent, that contains information about the event.

# A fairly common scenario is to perform an annoucement whenever a PR is merged.

$isMergeToMain = 
    ($gitHubEvent.head_commit.message -match "Merge Pull Request #(?<PRNumber>\d+)") -and 
    $gitHubEvent.ref -eq 'refs/heads/main'

$importedModule = Import-Module .\ShowDemo.psd1 -Global -PassThru
$importedModule | Out-Host
$moduleAndVersion = "$($importedModule.Name) $($importedModule.Version)"

$isManuallyTriggered = $gitHubEvent.psobject.properties["inputs"]

if ($isMergeToMain -or $isManuallyTriggered) {

    $fullMessage = @(    
        "Show off your scripts",        
        "Demo your PowerShell",
        "Never typo during a talk again" | Get-Random

        "$($ImportedModule.Name)"
    ) -join [Environment]::NewLine
    
    $sendSplat = [Ordered]@{
        Text = $fullMessage
    }
    if ($importedModule.PrivateData.PSData.ProjectURI) {
        $sendSplat.WebCard = @{Url=$importedModule.PrivateData.PSData.ProjectURI}
        $sendSplat.LinkPattern = @{$importedModule.Name=$importedModule.PrivateData.PSData.ProjectURI}
    }

    Send-AtProto @sendSplat
    return
}