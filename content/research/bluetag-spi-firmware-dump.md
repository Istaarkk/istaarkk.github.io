**As there is no good documentation available for dumping SPI firmware with BlueTag, you will find proper instructions here.**

---
## Required Hardware
- BlueTag / serprog programmer (RP2040)
- SOIC8 test clip (WINGONEER recommended)
- Dupont jumper wires
- Target SPI Flash chip (SOIC8 package)


```bash
[ Pin configuration for target SPI Flash IC ]

         +-------------------------+
         | RP2040 pin  | SPI Flash |
         +-------------------------+
         | GP0         | CS        |
         | GP2         | CLK       |
         | GP3         | MOSI / DI |
         | GP4         | MISO / DO |
         | GND         | GND       |
         |-------------------------|
         | Optional:               |
         |-------------------------|
         | 3V3 Out     | VCC       |
         +-------------------------+

 [ Ex. Flashrom commands ]

   Read  : 'flashrom -p serprog:dev=XXXXXXXXXX:115200,spispeed=12M -r flashBackup.bin'
   Write : 'flashrom -p serprog:dev=XXXXXXXXXX:115200,spispeed=12M -w flash.bin'

   Replace 'XXXXXXXXXX' with the BlueTag serial port [e.g. '/dev/ttyACM0' (Linux) or 'COM4' (Windows)]

 Note: Connect BlueTag's '3V3 Out' pin to target SPI Flash IC's 'VCC' pin only if the target
       isn't externally powered
```


---

## BlueTag → SPI Flash Wiring (SOIC8)

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

## Connecting to the BlueTag (RP2040)

### Identify the USB serial interface  
List the connected serial devices to locate the BlueTag interface:

```bash
ls -l /dev/serial/by-id/
```

First, connect to the BlueTag.
Use `ls -l` to get the correct interface:

```bash
ls -l /dev/serial/by-id/usb-Aodrulez_blueTag_6MGG0G0VAMQORWBRF-if00
```

Then start `screen` on the BlueTag interface and press `F` to activate:

```bash 
sudo screen /dev/ttyACM12 115200
```

Press `F` to activate.

Then check the interface again and read the SPI firmware:
```bash
ls -l /dev/serial/by-id/usb-Aodrulez_blueTag_6MGG0G0VAMQORWBRF-if00
```


### Read SPI firmware:

```bash
flashrom -p serprog:dev=/dev/ttyACM0:115200,spispeed=12M -r flashBackup.bin
```

Another example:

```bash
sudo flashrom -p serprog:dev=/dev/ttyACM13:115200 -r flashBackup.bin
```

To extract partitions:

```bash
dd if=flash.bin of=squashfs1 skip=617707520 bs=1 status=progress count=77205756
```

Then:
```bash
unsquashfs squashfs1
```

