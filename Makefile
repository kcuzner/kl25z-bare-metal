# Makefile for the kl25-hid project
#
# Kevin Cuzner

PROJECT=kl25-hid

# Directories
BINDIR=bin
OBJDIR=obj
SRCDIR=src
CMSISDIR=cmsis
INCDIR=include

# Target
CPU=cortex-m0plus

# Includes
INCLUDE=-I$(INCDIR) -I$(CMSISDIR)

# Source
SRC=$(wildcard $(SRCDIR)/*.c) $(wildcard $(CMSISDIR)/*.c)\
	$(wildcard $(SRCDIR)/*.s) $(wildcard $(CMSISDIR)/*.s)

# Linker Script
LSCRIPT=MKL25Z128xxx4_flash.ld

# Flags
GCFLAGS=-Wall -fno-common -mthumb -mcpu=$(CPU) -Os -std=c99 --specs=nano.specs\
		-g $(INCLUDE) -DCPU_MKL25Z128VLK4
LDFLAGS=-nostartfiles -T$(LSCRIPT) -mthumb -mcpu=$(CPU)\
		-g -Wl,-Map,$(BINDIR)/$(PROJECT).map
ASFLAGS=-mcpu=$(CPU)
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

