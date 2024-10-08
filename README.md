![Apache NuttX RTOS on 64-bit QEMU RISC-V Emulator](https://lupyuen.github.io/images/riscv-title.png)

[_Apache NuttX RTOS on 64-bit QEMU RISC-V Emulator_](https://github.com/apache/nuttx/tree/master/boards/risc-v/qemu-rv/rv-virt)

# Apache NuttX RTOS on 64-bit RISC-V

[![Daily Build and Test: qemu-riscv-nsh](https://github.com/lupyuen/nuttx-riscv64/actions/workflows/qemu-riscv-nsh.yml/badge.svg)](https://github.com/lupyuen/nuttx-riscv64/actions/workflows/qemu-riscv-nsh.yml) <br>
[![Daily Build and Test: qemu-riscv-knsh](https://github.com/lupyuen/nuttx-riscv64/actions/workflows/qemu-riscv-knsh.yml/badge.svg)](https://github.com/lupyuen/nuttx-riscv64/actions/workflows/qemu-riscv-knsh.yml) <br>
[![Daily Build: qemu-riscv-nsh64](https://github.com/lupyuen/nuttx-riscv64/actions/workflows/qemu-riscv-nsh64.yml/badge.svg)](https://github.com/lupyuen/nuttx-riscv64/actions/workflows/qemu-riscv-nsh64.yml) <br>
[![Daily Build: qemu-riscv-knsh64](https://github.com/lupyuen/nuttx-riscv64/actions/workflows/qemu-riscv-knsh64.yml/badge.svg)](https://github.com/lupyuen/nuttx-riscv64/actions/workflows/qemu-riscv-knsh64.yml) <br>
[![Daily Build and Test: qemu-riscv-leds64-rust](https://github.com/lupyuen/nuttx-riscv64/actions/workflows/qemu-riscv-leds64-rust.yml/badge.svg)](https://github.com/lupyuen/nuttx-riscv64/actions/workflows/qemu-riscv-leds64-rust.yml) <br>

Read the articles...

- ["64-bit RISC-V with Apache NuttX Real-Time Operating System"](https://lupyuen.github.io/articles/riscv)

- ["NuttX for Star64 JH7110 SBC"](https://lupyuen.github.io/articles/release)

- ["NuttX for Ox64 BL808 SBC"](https://www.hackster.io/lupyuen/8-risc-v-sbc-on-a-real-time-operating-system-ox64-nuttx-474358)

- ["NuttX for Oz64 SG2000 SBC"](https://lupyuen.github.io/articles/sg2000)

- ["Rolling to RISC-V"](https://lupyuen.github.io/articles/pinephone2#rolling-to-risc-v)

Apache NuttX RTOS is now built and tested daily on QEMU RISC-V...

- [qemu-riscv-nsh64.yml](.github/workflows/qemu-riscv-nsh64.yml): GitHub Actions Workflow

- [qemu-riscv-nsh64.exp](qemu-riscv-nsh64.exp): Expect Script

<hr>

1.  _So we're moving from Arm64 to RISC-V?_

    Yep! We have a fresh new opportunity to teach the __RISC-V 64-bit Architecture__ from scratch.

    And hopefully RISC-V Devices will still be around after 8 years!

1.  _We're porting NuttX to a RISC-V Phone?_

    Sadly there isn't a __RISC-V Phone__ yet.
    
    Thus we'll port NuttX to a RISC-V Tablet instead: [__PineTab-V__](https://wiki.pine64.org/wiki/PineTab-V)

1.  _But PineTab-V isn't shipping yet!_

    That's OK, we'll begin by porting NuttX to the [__Star64 SBC__](https://wiki.pine64.org/wiki/STAR64)

    Which runs on the same RISC-V SoC as PineTab-V: [__StarFive JH7110__](https://doc-en.rvspace.org/Doc_Center/jh7110.html)

    (Hopefully we have better docs and tidier code than the older Arm64 SoCs)

1.  _Hopping from Arm64 to RISC-V sounds like a major migration..._

    Actually we planned for this [__one year ago__](https://www.mail-archive.com/dev@nuttx.apache.org/msg08395.html).

    NuttX already runs OK on the (64-bit) [__QEMU RISC-V Emulator__](https://github.com/apache/nuttx/tree/master/boards/risc-v/qemu-rv/rv-virt). (Pic below)
    
    So the migration might not be so challenging after all!
