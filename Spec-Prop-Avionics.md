# Specifications for Propulsion Avionics
Version: 0.0.1  
Date: 29 September 2019  
Status: Draft  
Type: System Specification  

## Overview
Propulsion Avionics shall be avionics systems that control and instrument
the BJ-01 rocket engine during test runs (CFTs and hot fires) and full flights. 
This system is **safety critical**, and any changes shall be integration tested 
with propulsion components before flying.

## Goals
1. Minimize risk to anyone involved in propulsion system operations
2. Ensure reliable ignition and operation of the BJ-01 rocket engine
3. Collect propulsion system metrics for analysis

## Requirements
1. Accept and log instrumentation data
2. Initiate and monitor ignition process for the rocket engine
3. Monitor instrumentation and alert operator(s) in case of malfunction and/or
    automatically act to minimize safety risk.
4. Respond automatically to failures to minimize safety risk

## Out of scope
1. Rocket operations after engine burn has completed (this is the domain of
   *recovery avionics*)
2. Rocket operations before oxidizer fueling (this is the domain of the
    ground support hardware)

## Components:
- Data Acquisition Plane (DAP): Tasked with receiving and logging data from engine
  instrumentation
- Command & Control Plane (C2P): Tasked with receiving operator commands and
  sending the appropriate control signals to the engine (oxidizer valve and
  fueling solenoids). Also tasked with automatically responding to real-time data 
  received from the DAQ.
- Data Transmission and Visualization plane (DTP): Tasked with transmitting data
  to the operator console. Must also visualize telemetry data easing identification
  of error conditions.

### Data Acquisition Plane
The data acquisition plane shall read and track the state of the following engine
components:

1. Thermocouples (TCs)
2. Pressure transducers (PTs)
3. Load cells (LCs)
4. Solenoids
5. Motorized valve

and log the output to a csv log at a sample rate of __ seconds. The log shall
consist of one line per sample and `E_[sensor]` for any data collection 
errors. The log for each run shall be called `log_[time]` where` [time]` is the
Unix timestamp. The DAQ shall also provide the DTP and C2P with updated data
in every sample interval.

### Command and Control Plane
The command and Control Plane receives radio command that controls actions of valves from the operator. Corresponding control signal is then sent to propulsion system. Radio command for each valve is represented by an integer value, which shall be `int8_t` type. As there are 3 valve, a radio commands shall be an array containing 3 integers of the following order:

1. Open/Close of fuel-combustion ball valve
2. Open/Close of fueling solenoid valve
3. Open/Close of venting solenoid valve

The commands values used by each of the command is outlined in the following tables. *Note*, the values here are only used at software level, whilst the actual signals sent to **hardware components** need to be defined based on the particular needs.

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

One example of a command would be `{1,-1,0}`, denoting the unlikely command of forward action of ball valve, no change in action of venting valve, and the closing of fuel valve. For future expansion of the commands, it is recommanded that any simple command should obtain a value ascending from 1, whilst complex sequence command should obtain a value descending from 127. For the valves used, Simple and sequence commands are defined as:

- Simple command is a command that is accomplished by #one# #continuous# and #unidirectional# action of the valve.
- Sequence commands is a command that is accomplished by #multiple# #discontinuous(e.g. with intervals)# and/or #multidirectional# action of the valve.
