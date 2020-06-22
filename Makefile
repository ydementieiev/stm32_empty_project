# This MakeFile for build project for STM32F303 with C++
# Need to install the ARM toolchain
# Here are instruction - https://gnu-mcu-eclipse.github.io/toolchain/arm/install/
# And link for download - https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-rm/downloads
# Dementieiev Yevhenii. (dem.yevhenii@gmail.com)

TARGET = Driver
#################################
# Working directories
#################################
BUILDDIR = bin
DEVICE = core/device
CMSIS = core/cmsis
PERIPH = core/stdperiph
STARTUP = core/start_up
DISCOVERY = core/discovery
ENGINEDRIVER = EngineDriver

#################################
# Source directory core
#################################
SOURCES += $(DISCOVERY)/src/stm32f3_discovery.c

SOURCES += $(PERIPH)/src/stm32f30x_gpio.c \
		   $(PERIPH)/src/stm32f30x_i2c.c \
		   $(PERIPH)/src/stm32f30x_rcc.c \
		   $(PERIPH)/src/stm32f30x_spi.c \
		   $(PERIPH)/src/stm32f30x_exti.c \
		   $(PERIPH)/src/stm32f30x_syscfg.c \
		   $(PERIPH)/src/stm32f30x_misc.c

SOURCES += $(DEVICE)/system_stm32f30x.c
SOURCES += $(STARTUP)/startup_stm32f30x.s

#################################
# Source directory user
#################################
SOURCES += $(ENGINEDRIVER)/src/main.cpp \
		   $(ENGINEDRIVER)/src/engine_driver.cpp

#################################
# Include directory
#################################
INCLUDES += -I$(DEVICE)/include \
			-I$(CMSIS) \
			-I$(PERIPH)/include \
			-I$(DISCOVERY)/include \
			-I$(ENGINEDRIVER)/include \

#################################
# Object List
#################################
OBJECTS = $(addprefix $(BUILDDIR)/, $(addsuffix .o, $(basename $(SOURCES))))


#################################
# Target Output Files
#################################
ELF = $(addprefix $(BUILDDIR)/, $(addsuffix .elf, $(basename $(TARGET))))
#HEX = $(addprefix $(BUILDDIR)/, $(addsuffix .hex, $(basename $(TARGET))))
BIN = $(addprefix $(BUILDDIR)/, $(addsuffix .bin, $(basename $(TARGET))))

#################################
# GNU ARM Embedded Toolchain
#################################
CC = arm-none-eabi-gcc
CXX = arm-none-eabi-g++
LD = arm-none-eabi-ld
AR = arm-none-eabi-ar
AS = arm-none-eabi-as
OBJCOPY = arm-none-eabi-objcopy
OD = arm-none-eabi-objdump
NM = arm-none-eabi-nm
SIZE = arm-none-eabi-size
A2L = arm-none-eabi-addr2line

#################################
# Flags
#################################
CFLAGS  = -O0 -g -Wall -I.\
   -mcpu=cortex-m4 -mthumb \
   -mfpu=fpv4-sp-d16 -mfloat-abi=hard \
   -mfloat-abi=softfp \
   -nostartfiles \
   -mlittle-endian \
   $(INCLUDES) -USE_STDPERIPH_DRIVER

CXXFLAGS  = -O0 -g -Wall -I.\
   -mcpu=cortex-m4 -mthumb \
   -mfpu=fpv4-sp-d16 -mfloat-abi=hard \
   -std=c++11 \
   -mfloat-abi=softfp \
   -mlittle-endian \
   -nostartfiles \
   $(INCLUDES) -USE_STDPERIPH_DRIVER

LDSCRIPT = stm32_flash.ld
LDFLAGS += -T$(LDSCRIPT) -mthumb -mcpu=cortex-m4 -nostartfiles -Wl,-V  -mlittle-endian -mthumb -mcpu=cortex-m4 -mthumb-interwork -specs=nano.specs -specs=nosys.specs

#################################
# Build
#################################
$(BIN): $(ELF)
	@echo "\033[32m Create binary file \033[0m"
	$(OBJCOPY) -O binary $< $@

#$(HEX): $(ELF)
#	@echo -e "\033[32m _______________________________Create ihex file____________________________________\033[0m"
#	$(OBJCOPY) -O ihex $< $@

$(ELF): $(OBJECTS)
	@echo "\033[32m Linking \033[0m"
	$(CC) $(LDFLAGS) -o $@ $(OBJECTS) $(LDLIBS)

$(BUILDDIR)/%.o: %.cpp
	@echo "\033[35m Building CXX object \033[0m"
	mkdir -p $(dir $@)
	$(CXX) -c $(CXXFLAGS) $< -o $@

$(BUILDDIR)/%.o: %.c
	@echo "\033[33m Building CC object \033[0m"
	mkdir -p $(dir $@)
	$(CC) -c $(CFLAGS) $< -o $@

$(BUILDDIR)/%.o: %.s
	@echo "\033[31m Building object from .s file \033[0m"
	mkdir -p $(dir $@)
	$(CC) -c $(CFLAGS) $< -o $@

#################################
# Recipes
#################################

clean:
	rm -R bin