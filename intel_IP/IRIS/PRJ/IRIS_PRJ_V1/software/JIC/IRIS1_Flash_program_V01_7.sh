#!/bin/bash

# Define variables
VERSION="V01_7"
SOF_FILE="../IRIS_PRJ_V1.sof"
ELF_FILE="../IRIS1_CPU_${VERSION}/IRIS1_CPU_${VERSION}.elf"

# Print the variable values
echo "Using SOF file: $SOF_FILE"
echo "Using ELF file: $ELF_FILE"

echo "Converting .sof to .flash...."
sof2flash --input="$SOF_FILE" --output=${VERSION}_hw.flash --epcs --verbose

echo "Converting .elf to .flash..."
elf2flash --input="$ELF_FILE" --output=${VERSION}_sw.flash --epcs --after=${VERSION}_hw.flash --verbose

echo "Converting .flash to .hex..."
nios2-elf-objcopy -I srec -O ihex ${VERSION}_hw.flash ${VERSION}_hw.hex
nios2-elf-objcopy -I srec -O ihex ${VERSION}_sw.flash ${VERSION}_sw.hex

echo "All tasks completed."
