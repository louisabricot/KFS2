# Kernel From Scratch - GDT & STACK

This is the second step in the *Kernel From Scratch* journey!
It involves creating a Global Descriptor Table (GDT) and integrating it to our Kernel.

The GDT must be set at address 0x800 and contain:
- a kernel code, data and stack
- a user code, data and stack

## Getting started

### Prerequisites

To run this project locally, you must have installed:

* binutils
* nasm
* gcc
* grub-common
* make
* xorriso

### Installation

1. Clone this repository

```sh
git clone https://github.com/louisabricot/KFS2.git
```

2. Build the ISO

```sh
cd KFS
make 
```

3. (42 only)
[You'll need a cross-compiler](/docs/Cross-Compiler.md)

4. Run it with qemu

```sh
make run
```
