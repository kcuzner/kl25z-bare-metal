# Makefile for a bare metal KL25Z project
#
# Configure this makefile as needed for the project

# Project name
PROJECT=kl25

# Target (Uncomment one)
#DEVICE=CPU_MKL25Z32VFM4
#DEVICE=CPU_MKL25Z32VFT4
#DEVICE=CPU_MKL25Z32VLH4
#DEVICE=CPU_MKL25Z32VLK4
#DEVICE=CPU_MKL25Z64VFM4
#DEVICE=CPU_MKL25Z64VFT4
#DEVICE=CPU_MKL25Z64VLH4
#DEVICE=CPU_MKL25Z64VLK4
#DEVICE=CPU_MKL25Z128VFM4
#DEVICE=CPU_MKL25Z128VFT4
#DEVICE=CPU_MKL25Z128VLH4
DEVICE=CPU_MKL25Z128VLK4

CORE=cortex-m0plus

# Directories
BINDIR=bin
OBJDIR=obj
SRCDIR=src
CMSISDIR=cmsis
INCDIR=include

# Includes
INCLUDE=-I$(INCDIR) -I$(CMSISDIR)

# Source
SRC=$(wildcard $(SRCDIR)/*.c) $(wildcard $(CMSISDIR)/*.c)\
	$(wildcard $(SRCDIR)/*.s) $(wildcard $(CMSISDIR)/*.s)

# Linker Script Selection
LSCRIPT=
ifneq (,$(filter CPU_MKL25Z32%4,$(DEVICE)))
LSCRIPT=$(CMSISDIR)/MKL25Z32xxx4_flash.ld
endif
ifneq (,$(filter CPU_MKL25Z64%4,$(DEVICE)))
LSCRIPT=$(CMSISDIR)/MKL25Z64xxx4_flash.ld
endif
ifneq (,$(filter CPU_MKL25Z128%4,$(DEVICE)))
LSCRIPT=$(CMSISDIR)/MKL25Z128xxx4_flash.ld
endif

ifndef LSCRIPT
$(error Unrecognized KL25 device. Unable to find linker script.)
endif

# Flags
GCFLAGS=-Wall -fno-common -mthumb -mcpu=$(CORE) -Os -std=c99 --specs=nano.specs\
		-g $(INCLUDE) -D${DEVICE}
LDFLAGS=-nostartfiles -T$(LSCRIPT) -mthumb -mcpu=$(CORE)\
		-g -Wl,-Map,$(BINDIR)/$(PROJECT).map
ASFLAGS=-mcpu=$(CORE)
COPYFLAGS=-R .stack

# Tools
AS=arm-none-eabi-gcc
CC=arm-none-eabi-gcc
OBJCOPY=arm-none-eabi-objcopy
OBJDUMP=arm-none-eabi-objdump
SIZE=arm-none-eabi-size
MKDIR=mkdir -p
RM=rm -rf

# Build
OBJS=$(addprefix $(OBJDIR)/,$(addsuffix .o,$(basename $(SRC))))

.PHONY: all
all: $(BINDIR)/$(PROJECT).srec
all: $(BINDIR)/$(PROJECT).hex
all: $(BINDIR)/$(PROJECT).bin
all: $(BINDIR)/$(PROJECT).lst
all: size

.PHONY: clean
clean:
	$(RM) $(BINDIR)
	$(RM) $(OBJDIR)

.PHONY: size
size: $(BINDIR)/$(PROJECT).elf
	$(SIZE) --format=SysV $(BINDIR)/$(PROJECT).elf

$(BINDIR)/$(PROJECT).srec: $(BINDIR)/$(PROJECT).elf
	$(OBJCOPY) $(COPYFLAGS) -O srec $< $@

$(BINDIR)/$(PROJECT).hex: $(BINDIR)/$(PROJECT).elf
	$(OBJCOPY) $(COPYFLAGS) -O ihex $< $@

$(BINDIR)/$(PROJECT).bin: $(BINDIR)/$(PROJECT).elf
	$(OBJCOPY) $(COPYFLAGS) -O binary $< $@

$(BINDIR)/$(PROJECT).lst: $(BINDIR)/$(PROJECT).elf
	$(OBJDUMP) -D $< > $@

$(BINDIR)/$(PROJECT).elf: $(OBJS)
	@$(MKDIR) -p $(dir $@)
	$(CC) $(OBJS) $(LDFLAGS) -o $(BINDIR)/$(PROJECT).elf

$(OBJDIR)/%.o: %.c
	@$(MKDIR) -p $(dir $@)
	$(CC) $(GCFLAGS) -c $< -o $@

$(OBJDIR)/%.o: %.s
	@$(MKDIR) -p $(dir $@)
	$(CC) $(ASFLAGS) -c $< -o $@

$(OBJS): Makefile

$(OBJS): $(LSCRIPT)

