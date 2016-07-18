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

cd $PSScriptRoot

Rename-Item -Path ".\ThirdParty\Documents\ExampleProject.dgml" -NewName ($projectName + ".dgml")
Rename-Item -Path ".\ThirdParty\FxCop\ExampleProject.fxcop" -NewName ($projectName + ".fxcop")
Rename-Item -Path ".\Product\ExampleProject.sln" -NewName ($projectName + ".sln")

Set-Content -Path ".\Product\Production\ExampleProject\ExampleProject.csproj" -Replace "ExampleProject", $projectName
Set-Content -Path ".\Product\Production\ExampleProject\Properties\AssemblyInfo.cs" -Replace "ExampleProject", $projectName
Set-Content -Path ".\Product\Production\ExampleProject\Class1.cs" -Replace "ExampleProject", $projectName
Rename-Item -Path ".\Product\Production\ExampleProject\ExampleProject.csproj" -NewName ($projectName + ".csproj")
Rename-Item -Path ".\Product\Production\ExampleProject" -NewName $projectName

Set-Content -Path ".\Product\Tests\ExampleProject.Tests\ExampleProject.csproj" -Replace "ExampleProject", $projectName
Set-Content -Path ".\Product\Tests\ExampleProject.Tests\Properties\AssemblyInfo.cs" -Replace "ExampleProject", $projectName
Set-Content -Path ".\Product\Tests\ExampleProject.Tests\Class1.cs" -Replace "ExampleProject", $projectName
Rename-Item -Path ".\Product\Tests\ExampleProject.Tests\ExampleProject.csproj" -NewName ($projectName + ".Tests.csproj")
Rename-Item -Path ".\Product\Tests\ExampleProject.Tests" -NewName ($projectName + ".Tests")