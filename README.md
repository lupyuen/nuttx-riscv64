![Apache NuttX RTOS on 64-bit QEMU RISC-V Emulator](https://lupyuen.github.io/images/riscv-title.png)

[_Apache NuttX RTOS on 64-bit QEMU RISC-V Emulator_](https://github.com/apache/nuttx/tree/master/boards/risc-v/qemu-rv/rv-virt)

# Apache NuttX RTOS on 64-bit RISC-V

Read the article...

-   ["64-bit RISC-V with Apache NuttX RTOS"](https://lupyuen.github.io/articles/riscv)

TODO

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
