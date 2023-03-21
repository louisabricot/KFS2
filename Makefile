src_asm = boot.S \
	  gdt.S \
	  multiboot.S \

src_c = print_stack.c

vpath %.c $(src_dir)
vpath %.S $(src_dir)

src_dir = src
build_dir = build
iso_path := iso
boot_path := ${iso_path}/boot
grub_path := ${boot_path}/grub

iso = kfs.iso
bin = ${build_dir}/kernel
cfg = grub.cfg

LD := ld
ldfile := linker.ld
LDFLAGS := -m elf_i386 -T ${ldfile}

AS := nasm
ASFLAGS := -f elf32
CC := gcc
CCFLAGS := -m32

MKRESCUE := grub-mkrescue

objs_asm := $(addprefix ${build_dir}/, ${src_asm:.S=.o})
objs_c := $(addprefix ${build_dir}/, ${src_c:.c=.o})

objs := ${objs_asm} ${objs_c}

.PHONY: all
all: build link iso

.PHONY: build
build: ${objs_asm} ${objs_c}
	@printf "\033[0;36m0bject file created\033[m\n"

${build_dir}/%.o: ${src_dir}/%.S
	@mkdir -p ${build_dir}
	${AS} ${ASFLAGS} $< -o $@

${build_dir}/%.o: ${src_dir}/%.c
	@mkdir -p ${build_dir}
	${CC} ${CCFLAGS} -c $< -o $@

.PHONY: link
link: build ${ldfile}
	${LD} ${LDFLAGS} ${objs_asm} ${objs_c} -o ${bin}
	@printf "\033[0;34mLinking completed\033[m\n"


.PHONY: iso
iso: link ${bin}
	@mkdir -p ${grub_path}
	@cp ${bin} ${boot_path}
	@cp ${cfg} ${grub_path}
	@${MKRESCUE} -o ${iso} ${iso_path}
	@printf "\033[0;32mIso file created\033[m\n"


.PHONY: clean
clean:
	@/bin/rm -rf ${build_dir}

.PHONY: fclean
fclean: clean
	@/bin/rm -rf ${iso} ${iso_path}

.PHONY: re
re: fclean all

.PHONY: run
run: iso ${iso}
	qemu-system-i386 -s -cdrom ${iso}
