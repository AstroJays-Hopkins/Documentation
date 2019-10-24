# Specifications for Control Plane used by Prop Avionics
Version: 0.4.0  
Date: 21 October 2019  
Status: Draft  
Type: Component Specification  

## Overview
The command and control (C2) plane is responsible for communicating with
onboard systems such as the engine, and ensure they remain responsive and under
operator control at all times. Control signals shall be transmitted over 915Mhz
LoRa radio

## Radio protocol
The Ground Station, Relay Box and Ignition computer shall all implement the C2
over 915Mhz LoRa radiio. Each packet sent over the LoRa network shall follow the
following format:

|Packet Byte|Description|
|-----------|-----------|
|0|Sender/Reciever ID byte|
|1|Packet Type|
|2...n|Packet Payload|

Bytes 0-1 are considered the "header" of the packet and primarily serve as
metadata that allow recievers to choose how to handle packets with minimal
overhead.

The sender/reciever ID shall be an 8 bit integer (uint8_t) with the high 4 bits
representing the sender ID and the low 4 bits representing the reciever ID. That
is:

```text
0b11110000 will be split into
Sender ID = 0b1111 = 15
Reciever ID = 0b0000 = 0
```

These IDs must follow the table below:

|C2 Plane Component|ID|
|------------------|--|
|Ground Station|0|
|Ignition (Engine) Computer|1|
|Relay Box Controller|2|
|**Broadcast**|15|

NOTE: ID #15 is reserved for broadcast messages sent to all radio devices on the
      same network and thus the amximum devices that can be conencted to the
      same network as of this spec is 15. 

Thus, if the Ground Station were to send a packet to the Ignition Computer, it
would send 0b00000001 in the 1 byte of its radio packet. This also means that
the sender of a packet can be determined by parsing byte 1 of the packet.

Packet types must be one of the following:

|Packet Type         |Code|
|--------------------|----|
|NOOP (does nothing) |   0|
|GS State Command    |   1|
|Heartbeat Request   |   2|
|ACK                 | 100|
|NACK                | 101|

### Synchronization and Awknowledgement
The C2 plane uses an _acked_ radio protocol. This means that every command sent
from the Grand Station to the rocket must be awknowledged by a corresponding
packet from the rocket to be considered successfully transmitted. However, since
only the newest state of the ground station needs to be carried out by the
rocket, only the _latest command packet_ will need to be acked. 

```text
repeat forever:
    if button state changed from last transmitted state:
        record state of GS
        assign sequence code to state so ack can be track
        replace current state pending ack
        send state to rocket
    otherwise:
       if state transmission is pending ack
             check for ack with matching sequence number from rocket, if received, mark state as acked
             if no response, and time is over ack timeout:
                 resend only if there are retries left, otherwise light up transmission error led
```

Heartbeat Request Packet Format:

|Packet Byte|      Content|
|-----------|-------------|
|        0-1|HEADER       |
|          2|Sequence Code|

ACK Packet Format:

|Packet Byte|      Content|
|-----------|-------------|
|        0-1|HEADER       |
|          2|Sequence Code|


The sequence code is a pseudo-unique code that matches request packets with
their corresponding ACK packets. Sequence codes should be incremented after
every ack'd packet transmission and should roll over at 256 (uint8_t will do
this automatically).  All ack'd packets transmitted from the same node should
use and increment the same sequence node counter to ensure that all packets
transmistted in a short time window fromt eh node have different sequence codes.
Packets that require awknowledgement should include a sequence code so the
resulting ack can be tracked back to the originating request.

### Valve Control

**Valve Control Packet**

|Packet Byte|         Content|
|-----------|----------------|
|        0-1|HEADER          |
|          2|Seqeunce Code   |
|          3|Ball Valve State|
|          4|Vent State      |
|          5|Fuel Valve State|


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
|0|Standby signal that does not lead to any change in current valve action.|
|1|Reversed movement of the valve.|
|2|Forward movement of the valve.|
|255|signal for **Ignition** Sequence, including opening the valve for a preset amount of time, before closing.|

**Venting solenoid valve control**

|value|Description|
|-----|-----------|
|0|Standbay Signal, with no change in current valve action|
|1|**Closing** of the venting valve|
|2|**Opening** of the venting valve|


**Fuel solenoid valve control**

|value|Description|
|-----|-----------|
|0|Standbay Signal, with no change in current valve action|
|1|**Closing** of the Fuel valve|
|2|**Opening** of the Fuel valve|

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
