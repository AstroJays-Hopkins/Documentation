# Specifications for Propulsion Avionics
Version: 0.1.0  
Date: 19 October 2019  
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
See [the specification](Spec-Prop-Avionics-Control-Plane.md) for a detailed
treatment of this component.
