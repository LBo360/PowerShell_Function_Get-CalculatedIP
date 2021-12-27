function Get-CalculatedIP
{
<#
.Synopsis
   Simple IP Address Calculator
.DESCRIPTION
   This IP calculator is unaware of any network boundaries. It's use will always result in a valid IP address object, but it may not be in the proper subnet.
.EXAMPLE
   Get-CalculatedIP -IPAddress 192.168.0.0 -ChangeValue 255 
 
 
Address            : 4278233280 
AddressFamily      : InterNetwork 
ScopeId            :  
IsIPv6Multicast    : False 
IsIPv6LinkLocal    : False 
IsIPv6SiteLocal    : False 
IsIPv6Teredo       : False 
IsIPv4MappedToIPv6 : False 
IPAddressToString  : 192.168.0.255


This example demonstrates starting with a base address of 192.168.0.0 and adding 255 addressess to it.
.EXAMPLE
   Get-CalculatedIP -IPAddress 192.168.4.0 -ChangeValue -512 
 
 
Address            : 174272 
AddressFamily      : InterNetwork 
ScopeId            :  
IsIPv6Multicast    : False 
IsIPv6LinkLocal    : False 
IsIPv6SiteLocal    : False 
IsIPv6Teredo       : False 
IsIPv4MappedToIPv6 : False 
IPAddressToString  : 192.168.2.0


This example demonstrates starting with a base address of 192.168.4.0 and subtracting 512 addressess from it.
.EXAMPLE
   Get-CalculatedIP -IPAddress 192.168.4.0 -ChangeValue -2055
 
 
Address            : 4194019264 
AddressFamily      : InterNetwork 
ScopeId            :  
IsIPv6Multicast    : False 
IsIPv6LinkLocal    : False 
IsIPv6SiteLocal    : False 
IsIPv6Teredo       : False 
IsIPv4MappedToIPv6 : False 
IPAddressToString  : 192.167.251.249


This example demonstrates starting with a base address of 192.168.4.0 and subtracting 2055 addressess from it.
.INPUTS
   
.OUTPUTS
   [System.Net.IPAddress]
.NOTES
    Author: Logan "L-Bo" Boydell
    Created 08/10/2018
    Changed:
                V1.0 - Initial Creation
    11/10/2018  V1.1 - Updated name of function to standard syntax. Overhauled logic to handle CIDRs smaller than /24, removed -Octet parameter
    12/11/2018  V1.2 - Updated logic to work in reverse, this allows subtraction by passing the -changeValue parameter a negative integer
    12/11/2018  V1.3 - Polished up script, added comments prior to publishing to techNet
    12/18/2020  V1.4 - Added built in help
     
.COMPONENT
   The component this cmdlet belongs to
.ROLE
   The role this cmdlet belongs to
.FUNCTIONALITY
   The functionality that best describes this cmdlet
#>
  Param
  (
    # Param1 help description
    [parameter(Mandatory=$true,
               Position=0)]
    [IPAddress]$IPAddress,
    
    # Param2 help description
    [parameter(Mandatory=$true,
               Position=1)]
    [int]$ChangeValue
  )
$count = 0..3
foreach($number in $count)
  {
    $splat = @{
    Name = ('Octet' + $number)
    Value = ([int]$IPAddress.toString().Split('\.')[$number])
    }
    New-Variable @splat
  }

  # If the sum of the last octet and changevalue is greater or equal to 256, do math...
  $newValue = $ChangeValue + $octet3
  If($newValue -ge 256 -or $newValue -lt 0)
    {
      # Set a counter to work back through the octets
      $count = 3

      # Do-Until loop to work out IP host math
      do
      {
        # Default break condition is true
        $continue = $false

        # Calculate the remainder in order to add to the current octet
        $remainder = ($newValue % 256)

        # if remainder is less than zero add 256 to it and reset remainder to the positive number
        if($remainder -lt 0)
          {$remainder = $remainder + 256}
        
        # Set the name variable to the octect we need to change
        $name = ('Octet' + $count)

        # Build a hashtable to splat our updated value to the variable
        $splat = @{
        Name = $name
        Value = $remainder
        }
        Set-Variable @splat

        # Figure out the quotient, this will be added to the next current octect (left of existing)
        $quotient = [math]::Round(($newValue - $remainder) / 256)

        # Increment count down by 1
        $count--
        $name = ('Octet' + $count)
        $newValue = $quotient + $(Get-Variable -Name $name).Value

        # If newValue is greater than or equal to 256 or less than 0 update the break condition allow another iteration of the loop
          if($newValue -ge 256 -or $newValue -lt 0)
            {
              # Update break condition to go through another loop
              $continue = $true
            }
          else
            {
                # Build a hashtable to splat our updated value to the variable
                $splat = @{
                Name = $name
                Value = $newValue
                }
                Set-Variable @splat
            }
      
      } until ($continue -eq $false)
  }
  else
    {
      # If the change value and the last octect is not greater than or equal to 256, and great than 0 then output the new IP address
      $newValue = $octet3 + $ChangeValue
      Set-Variable -Name Octet3 -Value $newValue 
    }
  
  # Final Output
  [ipaddress]$("{0}.{1}.{2}.{3}" -f $octet0,$octet1,$octet2,$octet3)
}
