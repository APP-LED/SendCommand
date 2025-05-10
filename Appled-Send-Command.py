#==============================================================================
# Appled-Send-Command.py
# Send a command to the APPLED LED Display using Python
#
# Copyright (C) 2025 - APPLED Smart LED Displays
#
# Info:
# This script sends a command to your APPLED Smart LED Screen using Python
# (Python must be installed on your PC)
#
# Parameters:
#  remoteHost : Hostname or IP address of the APPLED Smart LED Screen
#  command    : The command you want to execute.
#               'ding' will send a signal to the device and return 'dong' if
#               communication was successful.
#               See the APPLED user manual for available commands
#
# Usage:
#  python Appled-Send-Command.py 192.168.1.100 "ding"
#
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
import sys
import telnetlib

# Read parameters from command line
if len(sys.argv) < 3:
  print("Usage: Appled-Send-Command.py <remoteHost> <command>")
  sys.exit(1)

remoteHost = sys.argv[1]
command = sys.argv[2]
port = 23

try:
  # Open connection (with timeout)
  tn = telnetlib.Telnet(remoteHost, port, timeout=5)

  # Send the command
  tn.write(command.encode('ascii') + b"\r\n")

  # Optional: read the response
  output = tn.read_until(b"\n", timeout=2)
  print("Response:", output.decode(errors="ignore"))

  # Send exit and close the connection
  tn.write(b"exit\r\n")    
  tn.close()
  print("Command sent successfully.")
  
except Exception as e:
  print(f"Failed to connect or send command: {e}")

