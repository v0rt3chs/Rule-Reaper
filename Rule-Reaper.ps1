<# ============================================================ 
Written By: Curtis Dawkins (v0rt3chs)
Date Created: 01/24/2024
Purpose: Simplify process of eradicating malicious inbox rules.
============================================================ #> 

<#Pre-requisites:
--A current, working version of Exchange Online PowerShell module
--Exchange Admin (or higher) PIM role or static assignment
#>

#Get Commandline ARGS
param($upn,$mailbox,$rulename,$detailsflag)

Write-Host @"
`n`n
:::::::::  :::    ::: :::        ::::::::::               :::::::::  ::::::::::     :::     :::::::::  :::::::::: :::::::::             :::               
:+:    :+: :+:    :+: :+:        :+:                      :+:    :+: :+:          :+: :+:   :+:    :+: :+:        :+:    :+:             :+:              
+:+    +:+ +:+    +:+ +:+        +:+                      +:+    +:+ +:+         +:+   +:+  +:+    +:+ +:+        +:+    +:+              +:+             
+#++:++#:  +#+    +:+ +#+        +#++:++#   +#++:++#++:++ +#++:++#:  +#++:++#   +#++:++#++: +#++:++#+  +#++:++#   +#++:++#:                +#+            
+#+    +#+ +#+    +#+ +#+        +#+                      +#+    +#+ +#+        +#+     +#+ +#+        +#+        +#+    +#+              +#+             
#+#    #+# #+#    #+# #+#        #+#                      #+#    #+# #+#        #+#     #+# #+#        #+#        #+#    #+#            #+#              
###    ###  ########  ########## ##########               ###    ### ########## ###     ### ###        ########## ###    ###           ###     ########## 
`n`n
"@ -ForegroundColor Red

#Checking ARGS
if ($PSBoundParameters.ContainsKey('upn') -And $PSBoundParameters.ContainsKey('mailbox') ) {
} else {
    Write-Host "USAGE: .\Rule-Reaper.ps1 <your-UPN> <impacted-email-address> [name-of-rule-to-delete] [/d|/D|/details]" -ForegroundColor Red -BackgroundColor Black
    Write-Host `n
    Write-Host "NOTE: If you just supply a rule name, Rule-Reaper will give you the details for the rule but will cut directly to removal of the rule from the mailbox. If you just want the details of the rule, also pass the /d, /D, or /details flag after your rule name." -ForegroundColor Yellow 
    exit
}

#Connect to EXO and gather info on mailbox rules for impacted user or print info and prompt for deletion if rule was provided
connect-exchangeonline -userprincipalname $upn -ShowBanner:$false

#Check for connectivity and privileges before moving forward
try{get-inboxrule -mailbox $upn | out-null}
catch{
    Write-Warning -Message "Privilege error! Make sure you are elevated to Exchange Administrator or higher!"
    exit
}


#Rule Provided - WITH details flag
$acceptableFlags=@("/d","/D","/details","/Details","/DETAILS")
if ($PSBoundParameters.ContainsKey('rulename') -and $PSBoundParameters.ContainsKey('detailsFlag') -and ($detailsflag -in $acceptableFlags)){
    Write-Host "Rule Details: " -ForegroundColor Red
    (get-inboxrule -mailbox $mailbox -identity $rulename | Select-Object *).Description
    Write-Host "`nIf you'd like to remove this rule, run the same command without the details flag, $detailsFlag." -ForegroundColor Yellow
    exit
}

    #Rule Provided - WITHOUT details flag (default)
if ($PSBoundParameters.ContainsKey('rulename')){
    Write-Host "Rule Details: " -ForegroundColor Red
    (get-inboxrule -mailbox $mailbox -identity $rulename | Select-Object *).Description
    remove-inboxrule -mailbox $mailbox -identity $rulename
    $check=(get-inboxrule -mailbox $mailbox -identity $rulename -ErrorAction SilentlyContinue).Name
    if ($check -ne $rulename){
        Write-Host "The rule has been deleted successfully!" -ForegroundColor Green
    } else{
        Write-Host "Rule removal has been stopped. The inbox rule has not been deleted." -ForegroundColor Yellow
    }
} else{ #No Rule Provided - list rules
    Write-Host "Displaying names of email rules for mailbox:`n" -ForegroundColor Red
    (get-inboxrule -mailbox $mailbox).Name
}


