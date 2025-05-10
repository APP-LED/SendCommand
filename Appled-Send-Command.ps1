#==============================================================================
# Appled-Send-Command.ps1
# Send a command to the APPLED LED Display using Powershell
#
# Copyright (C) 2025 - APPLED Smart LED Displays
#
# Info:
# This script sends a command to your APPLED Smart LED Screen using the
# Powershell command line.
#
# Parameters:
#  remoteHost : Hostname or IP address of the APPLED Smart LED Screen
#  port       : TCP Port number the APPLED device is listening on (default: 23)
#  command    : The command you want to execute.
#               'ding' will send a signal to the device and return 'dong' if
#               communication was successful.
#               See the APPLED user manual for available commands
#
# Usage:
# - Run in PowerShell (admin not needed):
#  powershell -ExecutionPolicy Bypass -File C:\path\to\Appled-Send-Command.ps1
#  powershell -File Appled-Send-Command.ps1 -remoteHost 192.168.130.59 -command "/f:1010"
#
# License:
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
#
#==============================================================================

param (
  [string]$remoteHost = "192.168.130.59",
  [int]$port = 23,
  [string]$command = "/f:2525"
)


# Create and connect the TCP client
$client = New-Object System.Net.Sockets.TcpClient
$client.Connect($remotehost, $port)

# Get the network stream
$stream = $client.GetStream()
$writer = New-Object System.IO.StreamWriter($stream)
$reader = New-Object System.IO.StreamReader($stream)

# Configure writer to auto-flush
$writer.AutoFlush = $true

# Send the command and wait for the device to acknowledge
$writer.WriteLine($command)
Start-Sleep -Milliseconds 200

# Optionally read the response
if ($stream.DataAvailable) {
  $response = $reader.ReadLine()
  Write-Host "Response: $response"
}

# Send exit command
$writer.WriteLine("exit")

# Wait for server to acknowledge and close
Start-Sleep -Milliseconds 500

# Clean up
$writer.Close()
$reader.Close()
$stream.Close()
$client.Close()

Write-Host "Command sent and connection closed."
