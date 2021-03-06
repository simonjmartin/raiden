﻿Clear-Host

<#
.SYNOPSIS

Replace all instances of a string in a file with a different string.
.DESCRIPTION

Notes: http://superuser.com/questions/517760/how-to-search-and-replace-a-string-in-a-file-with-cmd-or-powershell
.PARAMETER $path

The file to search for replacements.
.PARAMETER $val

the value to replace.
.PARAMETER $repl

the value with which to replace it.
#>
function Replace($path, $val, $repl){
    (Get-Content $path) | ForEach-Object {$_ -replace $val, $repl} | set-content $path
}


<#
.SYNOPSIS

Updates the specified project with the new name.
.DESCRIPTION

.PARAMETER $projectPathFragment

"Production" or "Tests".
.PARAMETER $oldProjectName

The current name of the project.
.PARAMETER $newProjectName

The new name of the project.
#>
function UpdateProject($projectPathFragment, $oldProjectName, $newProjectName){
    Replace -path (".\Product\" + $projectPathFragment + "\" + $oldProjectName + "\Properties\AssemblyInfo.cs") -val "ExampleProject" -repl $newProjectName
    Replace -path  (".\Product\" + $projectPathFragment + "\" + $oldProjectName + "\Class1.cs") -val "ExampleProject" -repl $newProjectName
    Replace -path  (".\Product\" + $projectPathFragment + "\" + $oldProjectName + "\" + $oldProjectName + ".csproj") -val "ExampleProject" -repl $projectName
    if (Test-Path (".\Product\" + $projectPathFragment + "\" + $oldProjectName + "\" + $oldProjectName + ".snk")){
        Rename-Item -Path (".\Product\" + $projectPathFragment + "\" + $oldProjectName + "\" + $oldProjectName + ".snk") -NewName ($newProjectName + ".snk")
    }

    Rename-Item -Path (".\Product\" + $projectPathFragment + "\" + $oldProjectName + "\" + $oldProjectName + ".csproj") -NewName ($newProjectName + ".csproj")
    Rename-Item -Path (".\Product\" + $projectPathFragment + "\" + $oldProjectName) -NewName $newProjectName
}

Write-Host "CCCU New Solution Configurator"
Write-Host "-----------------------------"

$branch = Read-Host -Prompt "Which branch do you want? master or SOA? > "
if ($branch -ne "master")
{
    git checkout $branch -q
    Write-Host "Branch changed.  Please run the configurator again."
    return
}

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

# Replace all instances of the ExampleProject placeholder in the solution
Replace -path ".\Product\ExampleProject.sln" -val "ExampleProject" -repl $projectName

# Rename some one-off files
Rename-Item -Path ".\ThirdParty\Documents\ExampleProject.dgml" -NewName ($projectName + ".dgml")
Rename-Item -Path ".\ThirdParty\FxCop\ExampleProject.fxcop" -NewName ($projectName + ".fxcop")
Rename-Item -Path ".\Product\ExampleProject.sln" -NewName ($projectName + ".sln")
Rename-Item -Path ".\ReadMe.md" -NewName "Structure.md"

# Create new project readme.
$wikiLink = if ($wikiPage) { "[" + $wikiPage + "](" + $wikiPage + ")" } else { "" } 
"# " + $projectName + "`r`n`r`n" + $description + "`r`n`r`n" + $wikiLink | Out-File ".\ReadMe.md"

if ($gitOrigin)
{
    git remote rm origin
    git remote add origin $gitOrigin
    Write-Host ("origin is now set to track " + $gitOrigin)
}

UpdateProject -projectPathFragment "Production" -oldProjectName "ExampleProject" -newProjectName $projectName
UpdateProject -projectPathFragment "Tests" -oldProjectName "ExampleProject.Tests" -newProjectName ($projectName + ".Tests")

Write-Host "Complete."
