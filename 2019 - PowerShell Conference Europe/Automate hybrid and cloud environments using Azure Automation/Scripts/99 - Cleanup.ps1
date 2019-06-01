break #Safety net against running the script as a whole, it is meant to be run line by line

Connect-AzAccount

Remove-AzResourceGroup -Name psconfeu2019-rg -Force
