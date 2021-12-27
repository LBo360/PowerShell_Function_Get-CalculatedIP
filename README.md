# PowerShell Function "Get-CalculatedIP"
## Description
This is a simple IP calculator unaware of network boundaries. If you use this as part of a solution to automate exclusion ranges on DHCP scopes keep this in mind. This function will always return a valid IPAddress object, even if that address is outside of the subnet.
### **Example**
```PowerShell
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
```
This example demonstrates starting with a base address of 192.168.0.0 and adding 255 addressess to it.
### **Example**
```PowerShell
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
```
This example demonstrates starting with a base address of 192.168.4.0 and subtracting 512 addressess from it.
