# Copyright (c) 2024, aaronsql2019@gmail.com
# All rights reserved.
#
# This source code is licensed under the BSD-style license found in the
# LICENSE file in the root directory of this source tree. 

# Define the DNS server to use
$dnsServer = "8.8.8.8"  # Replace with your desired DNS server IP

# Path to the file containing domain names
$domainFile = "C:\AaronSQL2019_SysAdmin\CheckDomainsPossibleReboot.txt"

# Read the domain names from the file
$domains = Get-Content -Path $domainFile

# Initialize counters
$totalDomains = $domains.Count
$resolvedCount = 0
$unresolvedCount = 0

# Loop through each domain and attempt to resolve it
foreach ($domain in $domains) {
    try {
        # Use Resolve-DnsName with the specific DNS server
        $result = Resolve-DnsName -Name $domain -Server $dnsServer -ErrorAction Stop
        $resolvedCount++
    }
    catch {
        # If an error occurs (e.g., domain can't be resolved), increase the unresolved count
        Write-Host "Failed to resolve: $domain"
        $unresolvedCount++
    }
}

# Calculate if the majority of domains can't be resolved
$majorityUnresolved = [math]::Ceiling($totalDomains / 2)

if ($unresolvedCount -ge $majorityUnresolved) {
    Write-Host "Majority of domains cannot be resolved. Rebooting server..."
    Restart-Computer -Force
} else {
    Write-Host "DNS resolution successful for most domains."
}
