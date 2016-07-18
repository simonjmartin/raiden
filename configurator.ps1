Clear-Host
Write-Host "CCCU New Solution Configurator"
Write-Host "-----------------------------"
$projectName = Read-Host -Prompt "What is the name of this solution? > "
if ($projectName.EndsWith(".sln"))
{
    $projectName = $projectName.Substring(0, $projectName.Length - 4).Trim()
}

$description = Read-Host -Prompt "Please describe this solution in a few words > "
$gitOrigin = Read-Host -Prompt "What is the repo URL for this project in BitBucket? > "
$wikiPage = Read-Host -Prompt "What is the Wiki URL for this solution? > "
Read-Host -Prompt "Please make sure the solution is not open in Visual Studio or any other editors.  Press ENTER when ready."
Write-Host "Thank you.  Configuring..."

Rename-Item -Path ".\ThirdParty\Documents\ExampleProject.dgml" -NewName ($projectName + ".dgml")