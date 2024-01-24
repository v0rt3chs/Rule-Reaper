# Rule-Reaper
A PowerShell tool for simplifying the process of eradicating malicious inbox rules in O365.

One of the most common security incidents today is Business Email Compromise (BEC). In these cases, it is common for threat actors to create malicious inbox rules in the victim's mailbox to redirect or hide email traffic. During the eradication phase of incident response, cleaning up email rules can be a tedious process. Rule-Reaper simplifies the process by handling the exchange online powershell commands for you.

<H1>How to use Rule-Reaper</H1>

<H2>Prerequisites</H2> - In order to use Rule-Reaper properly, you will need the following:
    <br>1. Exchange Online Powershell Installed (https://learn.microsoft.com/en-us/powershell/exchange/exchange-online-powershell-v2?view=exchange-ps#install-and-maintain-the-exchange-online-powershell-module)
    <br>2. At least Exchange Admin privileges in your O365 Tenant

<H2>Usage</H2>

`.\Rule-Reaper.ps1 <your-UPN> <impacted-email-address> [name-of-rule-to-delete] [/d|/D|/details]`

<H3>Parameters</H3>

**<your-upn\>** - This is your User Principal Name in your O365 tenant. It is usually your email address. (example@example-company.com)

**<impacted-email-address\>** - This is the email address of the victim. (victim@example-company.com)

**[name-of-rule-to-delete]** - (Optional) If you already know the name of the rule you'd like to delete, you can specify it here. You may need quotes if the name has spaces or special characters. ("Example Name of Rule..")

**[/d|/D|/details]** - (Optional) This is the details flag. If you pass it in your command you will only get the description of the inbox rule. Rule-Reaper will not prompt you to delete the rule afterwards. If you pass a rule name without the details flag, Rule-Reaper will give you the details of the inbox rule but will also then prompt you for deletion. If you don't want to delete the rule yet you can simply click "No" or type "N" depending on where you are running the tool.

Notes: If you do not know the name of the rule that was added, simply do not include a rule name. If Rule-Reaper does not receive a rule name, it will simply print out all of the rules present for the account. When you do include a rule name, make sure to pass in the name exactly as it appears.

<H3>Usage Examples</H3>

**Rule Name not Known**
`.\Rule-Reaper.ps1 me@example.com victim@example.com`<br>
**Rule Name Known; Details Only**
`.\Rule-Reaper.ps1 me@example.com victim@example.com "malicious rule name" /d`<br>
**Rule Name Known; Details and Delete**
`.\Rule-Reaper.ps1 me@example.com victim@example.com "malicious rule name"`<br>

<br><br>
Good luck, blue team! I hope this helps! :)
<br>ASCII art is credit of https://patorjk.com/
