---
title: "Dumping SPI Firmware with BlueTag (RP2040)"
date: 2025-12-21
draft: false
tags: ["research", "firmware", "spi", "bluetag", "serprog", "flashrom"]
---

# Dumping SPI Firmware with BlueTag (RP2040)

As there is no good documentation available to dump SPI firmware with BlueTag, you will find proper instructions here.

## Required Hardware

- BlueTag / serprog programmer (RP2040)
- SOIC8 test clip (WINGONEER recommended)
- Dupont jumper wires
- Target SPI flash chip (SOIC8 package)

## Pin Configuration to Target SPI Flash IC

Two BlueTag pinouts are commonly seen depending on firmware and board revision. Verify your silkscreen or firmware docs and use the matching mapping.

### Pinout A (GPIO 1-4)

| RP2040 pin | SPI Flash |
| --- | --- |
| GPIO 1 | CS |
| GPIO 2 | CLK |
| GPIO 3 | MOSI / DI |
| GPIO 4 | MISO / DO |
| GND | GND |
| 3V3 Out (optional) | VCC |

### Pinout B (GPIO 0-4)

| RP2040 pin | SPI Flash |
| --- | --- |
| GPIO 0 | CS |
| GPIO 2 | CLK |
| GPIO 3 | MOSI / DI |
| GPIO 4 | MISO / DO |
| GND | GND |
| 3V3 Out (optional) | VCC |

Note: Connect BlueTag's `3V3 Out` pin to the target SPI flash `VCC` pin only if the target is not externally powered.

## BlueTag -> SPI Flash Wiring (SOIC8)

| SPI Flash function | Flash pin (SOIC8) | BlueTag (RP2040 GPIO) |
| --- | --- | --- |
| CS (Chip Select) | Pin 1 | GP0 or GP1 |
| DO / MISO | Pin 2 | GP4 |
| GND | Pin 4 | GND |
| DI / MOSI | Pin 5 | GP3 |
| CLK (Clock) | Pin 6 | GP2 |
| VCC (3.3V) | Pin 8 | 3V3 OUT (optional) |

Only connect 3.3V if the target board is not externally powered.

## Flashrom Command Examples

Replace `XXXXXXXXXX` with the BlueTag COM port (for example, `/dev/ttyACM0` on Linux or `COM4` on Windows).

```bash
# Read
flashrom -p serprog:dev=XXXXXXXXXX:115200,spispeed=12M -r flashBackup.bin

# Write
flashrom -p serprog:dev=XXXXXXXXXX:115200,spispeed=12M -w flash.bin
```

## Connecting to the BlueTag (RP2040)

Identify the USB serial interface:

```bash
ls -l /dev/serial/by-id/
```

You can also use `ll` if it is available:

```bash
ll /dev/serial/by-id/usb-Aodrulez_blueTag_6MGG0G0VAMQORWBRF-if00
```

Open the serial interface and activate serprog:

```bash
sudo screen /dev/ttyACM12 115200
```

Press `F` to activate, then re-check the interfaces:

```bash
ll /dev/serial/by-id/usb-Aodrulez_blueTag_6MGG0G0VAMQORWBRF-if00
```

Read the SPI firmware:

```bash
flashrom -p serprog:dev=/dev/ttyACM0:115200,spispeed=12M -r flashBackup.bin
```

Another example:

```bash
sudo flashrom -p serprog:dev=/dev/ttyACM13:115200 -r flashBackup.bin
```

## Extracting Partitions

Use `dd` to carve out a partition, then extract it:

```bash
dd if=flash.bin of=squashfs1 skip=617707520 bs=1 status=progress count=77205756
unsquashfs squashfs1
```
