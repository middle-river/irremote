MCU=attiny2313

all : irtx_led.hex

%.s : %.asm
	avr-cpp -mmcu=$(MCU) -o $@ $<
%.o : %.s
	avr-as -mmcu=$(MCU) -o $@ $<
%.elf : %.o
	avr-ld -o $@ $<
%.hex : %.elf
	avr-objcopy -I elf32-avr -O ihex $< $@
