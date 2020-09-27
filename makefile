# Put your source files here (*.c)
SRCS=./Src/main.c ./Src/stm32l4xx_it.c ./Src/system_stm32l4xx.c ./Src/syscalls.c

# Libraries source files, add ones that you intent to use
SRCS += stm32l4xx_hal_rcc.c
SRCS += stm32l4xx_hal_gpio.c
SRCS += stm32l4xx_hal_cortex.c
SRCS += stm32l4xx_hal_flash.c
SRCS += stm32l4xx_hal_flash_ex.c
SRCS += stm32l4xx_hal_pwr.c
SRCS += stm32l4xx_hal_pwr_ex.c
SRCS += stm32l4xx_nucleo_32.c
SRCS += stm32l4xx_hal.c

# Binaries will be generated with this name (.elf, .bin, .hex)
PROJ_NAME=Template

# Put your STM32F4 library code directory here, change YOURUSERNAME to yours
STM_COMMON=/home/piernik/programing/c/stm32/STM32Cube_FW_L4_V1.16.0/Drivers

# Compiler settings. Only edit CFLAGS to include other header files.
CC=arm-none-eabi-gcc
OBJCOPY=arm-none-eabi-objcopy


#Compiler flags
CFLAGS  = -g -O2 -Wall -T./SW4STM32/STM32L432KC_NUCLEO/STM32L432KCUx_FLASH.ld
CFLAGS += -DUSE_STDPERIPH_DRIVER
CFLAGS += -mlittle-endian -mthumb -mcpu=cortex-m4 -mthumb-interwork
CFLAGS += -mfloat-abi=hard -mfpu=fpv4-sp-d16
CFLAGS += -I.

CFLAGS += -I./Morse_codec


# Include files from STM libraries
CFLAGS += -I/home/piernik/programing/c/stm32/STM32Cube_FW_L4_V1.16.0/Projects/NUCLEO-L432KC/Examples/GPIO/GPIO_IOToggle/SW4STM32/STM32L432KC_NUCLEO
CFLAGS += -I./Inc
CFLAGS += -I$(STM_COMMON)/STM32L4xx_HAL_Driver/Inc
CFLAGS += -I$(STM_COMMON)/CMSIS/Device/ST/STM32L4xx/Include
CFLAGS += -I$(STM_COMMON)/CMSIS/Include
CFLAGS += -I$(STM_COMMON)/BSP/STM32L4xx_Nucleo_32


# add startup file to build
SRCS += ./SW4STM32/startup_stm32l432xx.s 
OBJS = $(SRCS:.c=.o)

vpath %.c $(STM_COMMON)/STM32L4xx_HAL_Driver/Src $(STM_COMMON)/BSP/STM32L4xx_Nucleo_32 

.PHONY: proj

# Commands
all: proj

proj: $(PROJ_NAME).elf

$(PROJ_NAME).elf: $(SRCS)
	$(CC) $(CFLAGS) $^ -o $@
	$(OBJCOPY) -O ihex $(PROJ_NAME).elf $(PROJ_NAME).hex
	$(OBJCOPY) -O binary $(PROJ_NAME).elf $(PROJ_NAME).bin

clean:
	rm -f *.o $(PROJ_NAME).elf $(PROJ_NAME).hex $(PROJ_NAME).bin

# Flash the STM32
burn: proj
	st-flash write $(PROJ_NAME).bin 0x8000000