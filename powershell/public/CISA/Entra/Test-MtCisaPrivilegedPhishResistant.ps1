﻿<#
.SYNOPSIS
    Checks if Conditional Access Policy requiring phishing resistant authentication methods for privileged roles is enabled
.DESCRIPTION

    Phishing-resistant MFA SHALL be required for highly privileged roles.

.EXAMPLE
    Test-MtCisaPhishResistant

    Returns true if at least one policy requires phishing resistant methods for the specific roles
#>

Function Test-MtCisaPhishResistant {
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    $highlyPrivilegedRoles = @(
        "Global Administrator",
        "Privileged Role Administrator",
        "User Administrator",
        "SharePoint Administrator",
        "Exchange Administrator",
        "Hybrid Identity Administrator",
        "Application Administrator",
        "Cloud Application Administrator"
    )

    $roles = Get-MtRole

    $highlyPrivilegedRoles = $roles | Where-Object {`
        $_.displayName -in $highlyPrivilegedRoles }

    $result = Get-MtConditionalAccessPolicy

    #Hacky approach to do validation of all objects
    $policies = $result | Where-Object {`
        $_.state -eq "enabled" -and `
        $_.conditions.applications.includeApplications -contains "All" -and `
        $_.grantControls.authenticationStrength.displayName -eq "Phishing-resistant MFA" -and `
        ($_.conditions.users.includeRoles|Sort-Object) -join "," -like "*$(($highlyPrivilegedRoles.id|Sort-Object) -join "*")*" }

    $testResult = $policies.Count -ge 1

    if ($testResult) {
        $testResultMarkdown = "Well done. Your tenant has one or more policies that require phishing resistant MFA for highly privileged users:`n`n%TestResult%"
    } else {
        $testResultMarkdown = "Your tenant does not have any conditional access policies that require phishing resistant MFA for highly privileged users."
    }
    Add-MtTestResultDetail -Result $testResultMarkdown -GraphObjectType ConditionalAccess -GraphObjects $policies

    return $testResult
}