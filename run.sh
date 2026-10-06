#!/bin/bash
set -xue

QEMU=qemu-system-riscv32

# clang 경로와 컴파일 옵션
CC=/opt/homebrew/opt/llvm/bin/clang
CFLAGS="-std=c11 -O2 -g3 -Wall -Wextra --target=riscv32-unknown-elf -fuse-ld=lld -fno-stack-protector -ffreestanding -nostdlib"

# 커널 빌드 (common.c 추가)
$CC $CFLAGS -Wl,-Tkernel.ld -Wl,-Map=kernel.map -o kernel.elf \
    kernel.c common.c

# QEMU 실행
$QEMU -machine virt -bios opensbi-riscv32-generic-fw_dynamic.bin -nographic -serial mon:stdio --no-reboot \
    -kernel kernel.elf
