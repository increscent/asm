avr-as -mmcu=atmega328p -o $1.o $1.asm
avr-ld -o $1.elf $1.o
avr-objcopy -O ihex -R .eeprom $1.elf $1.hex
sudo avrdude -C /etc/avrdude.conf -p atmega328p -c arduino -P /dev/ttyUSB1 -b 115200 -D -U flash:w:$1.hex:i
