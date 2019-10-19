# Specifications for Control Plane used by Prop Avionics
Version: 0.1.0  
Date: 19 October 2019  
Status: Draft  
Type: Component Specification  

## Overview
The command and control plane is responsible for communicating with
onboard systems such as the engine, and ensure they remain responsive and under
operator control at all times. Control signals shall be transmitted over 915Mhz
LoRa radio

## Radio protocol
The ignition computer receives valve control commands from the
operator. Corresponding control signals are then sent to the propulsion system.
Radio commands for each valve shall be represented by an integer value, should
be of the `int8_t` type. As there are 3 valves, a radio command shall be an
array containing 3 integers of the following order:

1. Open/Close of fuel-combustion ball valve
2. Open/Close of fueling solenoid valve
3. Open/Close of venting solenoid valve

The commands values used by each of the command is outlined in the following
tables. *Note*, the values here are only used at software level, whilst the
actual signals sent to **hardware components** need to be defined based on the
particular needs.

**Ball valve control**

|value|Description|
|-----|-----------|
|0|Reversed movement of the valve.|
|1|Forward movement of the valve.|
|-1|Standby signal that does not lead to any change in current valve action.|
|127|signal for **Ignition** Sequence, including opening the valve for a preset amount of time, before closing.|

**Venting solenoid valve control**

|value|Description|
|-----|-----------|
|0|**Closing** of the venting valve|
|1|**Opening** of the venting valve|
|-1|Standbay Signal, with no change in current valve action|


**Fuel solenoid valve control**

|value|Description|
|-----|-----------|
|0|**Closing** of the Fuel valve|
|1|**Opening** of the Fuel valve|
|-1|Standbay Signal, with no change in current valve action|

One example of a command would be `{1,-1,0}`, denoting the unlikely command of
forward action of ball valve, no change in action of venting valve, and the
closing of fuel valve. For future expansion of the commands, it is recommanded
that any simple command should obtain a value ascending from 1, whilst complex
sequence command should obtain a value descending from 127. For the valves used,
Simple and sequence commands are defined as:

- Simple command is a command that is accomplished by #one# #continuous# and
  #unidirectional# action of the valve.
- Sequence commands is a command that is accomplished by #multiple#
  #discontinuous(e.g. with intervals)# and/or #multidirectional# action of the
  valve.
