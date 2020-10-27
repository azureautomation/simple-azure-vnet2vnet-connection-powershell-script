#===============================================
# Define your all parameters here
#===============================================


#===============================================
# Virtual Network1 Parameters
#===============================================
$VirtualNetwork1 = "VNetAustraliaEast"
$ResourceGroup1 = "RGAustraliaEast"
$AddressSpace1 = "10.1.0.0/16"
$Region1 = "Australia East"
$GatewaySubNet1 = "10.1.0.0/28"
$AppSubNet1 = "10.1.1.0/28"

#===============================================
# Virtual Network2 Parameters
#===============================================
$VirtualNetwork2 = "VNetAustraliaSoutEast"
$ResourceGroup2 = "RGAustraliaSoutEast"
$AddressSpace2 = "10.2.0.0/16"
$Region2 = "Australia Southeast"
$GatewaySubNet2 = "10.2.0.0/28"
$AppSubNet2 = "10.2.1.0/28"


#===============================================
# Creating Virtual Network1
#===============================================
New-AzureRmResourceGroup -Name $ResourceGroup1 -Location $Region1
$SubNet = New-AzureRmVirtualNetworkSubnetConfig -Name "GatewaySubnet" -AddressPrefix $GatewaySubNet1
$SubNet1 = New-AzureRmVirtualNetworkSubnetConfig -Name "AppSubnet" -AddressPrefi $AppSubNet1
New-AzureRmVirtualNetwork -Name $VirtualNetwork1 -ResourceGroupName $ResourceGroup1 -Location $Region1 -AddressPrefix $AddressSpace1 -Subnet $SubNet, $SubNet1
#===============================================
# Requesting Public IP
#===============================================
$GatewayPIP1= New-AzureRmPublicIpAddress -Name GatewayPIP1 -ResourceGroupName $ResourceGroup1 -Location $Region1 -AllocationMethod Dynamic

#===============================================
#Creating Gateway Configuration
#===============================================
$vnet = Get-AzureRmVirtualNetwork -Name $VirtualNetwork1 -ResourceGroupName $ResourceGroup1
$SubNet = Get-AzureRmVirtualNetworkSubnetConfig -Name "GatewaySubnet" -VirtualNetwork $vnet
$GatewayIPConfiguration = New-AzureRmVirtualNetworkGatewayIpConfig -Name GatewayIPConfiguration1 -SubnetId $SubNet.Id -PublicIpAddressId $GatewayPIP1.Id 
New-AzureRmVirtualNetworkGateway -Name VirtualNetworkGateway1 -ResourceGroupName $ResourceGroup1 -Location $Region1 -IpConfigurations $GatewayIPConfiguration -GatewayType Vpn -VpnType RouteBased

#===============================================
# Creating Virtual Network2
#===============================================
New-AzureRmResourceGroup -Name $ResourceGroup2 -Location $Region2
$SubNet = New-AzureRmVirtualNetworkSubnetConfig -Name "GatewaySubnet" -AddressPrefix $GatewaySubNet2
$SubNet1 = New-AzureRmVirtualNetworkSubnetConfig -Name "AppSubnet" -AddressPrefi $AppSubNet2
New-AzureRmVirtualNetwork -Name $VirtualNetwork2 -ResourceGroupName $ResourceGroup2 -Location $Region2 -AddressPrefix  $AddressSpace2 -Subnet $SubNet, $SubNet1
#===============================================
# Requesting Public IP
#===============================================
$GatewayPIP2= New-AzureRmPublicIpAddress -Name GatewayPIP2 -ResourceGroupName $ResourceGroup2 -Location $Region2 -AllocationMethod Dynamic
#===============================================
#Creating Gateway Configuration
#===============================================
$vnet = Get-AzureRmVirtualNetwork -Name $VirtualNetwork2 -ResourceGroupName $ResourceGroup2
$SubNet = Get-AzureRmVirtualNetworkSubnetConfig -Name "GatewaySubnet" -VirtualNetwork $vnet
$GatewayIPConfiguration = New-AzureRmVirtualNetworkGatewayIpConfig -Name GatewayIPConfiguration2 -SubnetId $SubNet.Id -PublicIpAddressId $GatewayPIP2.Id 
New-AzureRmVirtualNetworkGateway -Name VirtualNetworkGateway2 -ResourceGroupName $ResourceGroup2 -Location $Region2 -IpConfigurations $GatewayIPConfiguration -GatewayType Vpn -VpnType RouteBased

#===============================================
# Connecting Gateways
#===============================================
$VirtualNetworkGateWay1 = Get-AzureRmVirtualNetworkGateway -Name VirtualNetworkGateway1 -ResourceGroupName $ResourceGroup1
$VirtualNetworkGateWay2 = Get-AzureRmVirtualNetworkGateway -Name VirtualNetworkGateway2 -ResourceGroupName $ResourceGroup2
New-AzureRmVirtualNetworkGatewayConnection -Name VNetConnection1-ResourceGroupName $ResourceGroup1 -VirtualNetworkGateway1 $VirtualNetworkGateWay1 -VirtualNetworkGateway2 $VirtualNetworkGateWay2 -Location $Region1 -ConnectionType VNet2VNet -SharedKey "Key123"
$VirtualNetworkGateWay1 = Get-AzureRmVirtualNetworkGateway -Name VirtualNetworkGateway2 -ResourceGroupName $ResourceGroup2
$VirtualNetworkGateWay2 = Get-AzureRmVirtualNetworkGateway -Name VirtualNetworkGateway1 -ResourceGroupName $ResourceGroup1
New-AzureRmVirtualNetworkGatewayConnection -Name VNetConnection2 -ResourceGroupName $ResourceGroup2 -VirtualNetworkGateway1 $VirtualNetworkGateWay1 -VirtualNetworkGateway2 $VirtualNetworkGateWay2 -Location $Region2 -ConnectionType VNet2VNet -SharedKey "Key123"

#===============================================
# Verifying VirtualNetwork1 Connection to VirtualNetwork 2
#===============================================
Get-AzureRmVirtualNetworkGatewayConnection -Name VNetConnection1-ResourceGroupName $ResourceGroup1 -Debug 

#===============================================
# Verifying VirtualNetwork2 Connection to VirtualNetwork 1
#===============================================
Get-AzureRmVirtualNetworkGatewayConnection -Name VNetConnection2 -ResourceGroupName $ResourceGroup2 -Debug 




