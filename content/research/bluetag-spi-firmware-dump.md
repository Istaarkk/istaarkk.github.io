---
title: "Dumping SPI Firmware with BlueTag (RP2040)"
date: 2025-12-21
draft: false
tags: ["research", "firmware", "spi", "bluetag", "serprog", "flashrom"]
---

**As there is no good documentation available to dump SPI firmware with BlueTag, you will find proper instructions here.**

---
## Required Hardware
- BlueTag / serprog programmer (RP2040)
- SOIC8 test clip (WINGONEER recommended)
- Dupont jumper wires
- Target SPI Flash chip (SOIC8 package)


```bash
[ Pin configuration to target SPI Flash IC ]

         +-------------------------+
         | RP2040 pin  | SPI Flash |
         +-------------------------+
         | GPIO 1      | CS        |
         | GPIO 2      | CLK       |
         | GPIO 3      | MOSI / DI |
         | GPIO 4      | MISO / DO |
         | GND         | GND       |
         |-------------------------|
         | Optional:               |
         |-------------------------|
         | 3V3 Out     | VCC       |
         +-------------------------+

 [ Ex. Flashrom commands ]

   Read  : 'flashrom -p serprog:dev=XXXXXXXXXX:115200,spispeed=12M -r flashBackup.bin'
   Write : 'flashrom -p serprog:dev=XXXXXXXXXX:115200,spispeed=12M -w flash.bin'

   Replace 'XXXXXXXXXX' with COM port of blueTag [Ex. '/dev/ttyACM0' (Linux) or 'COM4' (Win)]

 Note: Connect blueTag's '3V3 Out' pin to target SPI Flash IC's 'VCC' pin only if the target
       isn't externally powered
```


---

## BlueTag -> SPI Flash Wiring (SOIC8)

| SPI Flash Function     | Flash Pin (SOIC8) | BlueTag (RP2040 GPIO) |
|------------------------|-------------------|------------------------|
| CS (Chip Select)       | Pin 1             | GP0                    |
| DO / MISO              | Pin 2             | GP4                    |
| GND                    | Pin 4             | GND                    |
| DI / MOSI              | Pin 5             | GP3                    |
| CLK (Clock)            | Pin 6             | GP2                    |
| VCC (3.3V)             | Pin 8             | 3V3 OUT *(optional)*   |

> Only connect 3.3V if the target board is **not externally powered**.

---

## Flashrom Command Examples


## Connecting to the BlueTag (RP2040)

### Identify the USB serial interface
List the connected serial devices to locate the BlueTag interface:

```bash
ls -l /dev/serial/by-id/
```

firstly you have to connect to the bluetag
so you can use ll in order to get the correct interfaces

```bash
ll /dev/serial/by-id/usb-Aodrulez_blueTag_6MGG0G0VAMQORWBRF-if00
```

then u can screen on and press F when u are on the blutag interfaces

```bash
sudo screen /dev/ttyACM12 115200
```

press F and activate

then u search for the new interfaces and u can read SPI firmware
```bash
ll /dev/serial/by-id/usb-Aodrulez_blueTag_6MGG0G0VAMQORWBRF-if00
```


### Read SPI firmware:

```bash
flashrom -p serprog:dev=/dev/ttyACM0:115200,spispeed=12M -r flashBackup.bin

another example:

sudo flashrom -p serprog:dev=/dev/ttyACM13:115200 -r flashBackup.bin
```

In order to extract partitions :

```bash
dd if=flash.bin of=squashfs1 skip=617707520 bs=1 status=progress count=77205756
```

and
```bash
unsquashfs squashfs1
```
