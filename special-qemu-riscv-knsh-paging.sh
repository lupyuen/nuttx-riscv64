#!/usr/bin/env bash
## Special Build and Test NuttX for QEMU RISC-V 32-bit (Kernel Build with Paging)
function runme() {
  script /tmp/special-qemu-riscv-knsh-paging.log $HOME/riscv/nuttx-riscv64/special-qemu-riscv-knsh-paging.sh
  cat /tmp/special-qemu-riscv-knsh-paging.log \
    | tr -d '\r' \
    | tr -d '\r' \
    | sed 's/\x08/ /g' \
    | sed 's/\x1B(B//g' \
    | sed 's/\x1B\[K//g' \
    | sed 's/\x1B[<=>]//g' \
    | sed 's/\x1B\[[0-9:;<=>?]*[!]*[A-Za-z]//g' \
    | sed 's/\x1B[@A-Z\\\]^_]\|\x1B\[[0-9:;<=>?]*[-!"#$%&'"'"'()*+,.\/]*[][\\@A-Z^_`a-z{|}~]//g' \
    >>/tmp/special-qemu-riscv-knsh-paging-clean.log
  cat /tmp/special-qemu-riscv-knsh-paging-clean.log | \
    gh gist create \
    --public \
    --desc "Special Build and Test NuttX for QEMU RISC-V 32-bit (Kernel Build)" \
    --filename "special-qemu-riscv-knsh-paging.log"
}

## TODO: Set PATH
export PATH="$HOME/xpack-riscv-none-elf-gcc-13.2.0-2/bin:$PATH"

set -e  #  Exit when any command fails
set -x  #  Echo commands

tmp_path=/tmp/special-qemu-riscv-knsh-paging
rm -rf $tmp_path
mkdir $tmp_path
cd $tmp_path
neofetch

# name: special-qemu-riscv-knsh-paging (RV32 Kernel Build, Special Build and Test)

# permissions:
#   ## Allow publishing of GitHub Release
#   contents: write

# on:

#   ## Run every day at 0:00 UTC
#   ## schedule:
#   ##   - cron: '0 0 * * *'

#   ## Run on every commit to this branch
#   push:
#     branches: [ main ]

# jobs:
#   build:

#     runs-on: ubuntu-latest

#     steps:

#     - name: Checkout Source Files
#       run:  |
        set -x  #  Echo commands

        ## TODO: Paste the GitHub Repo and Branch
        source=https://github.com/apache/nuttx/tree/master

        ## Match `https://github.com/user/repo/tree/branch`
        pattern='\(.*\)\/tree\/\(.*\)'

        ## `url` becomes `https://github.com/user/repo`
        ## `branch` becomes `branch`
        url=`echo $source | sed "s/$pattern/\1/"`
        branch=`echo $source | sed "s/$pattern/\2/"`

        ## Check out the `url` and `branch`
        mkdir nuttx
        cd nuttx
        git clone \
          $url \
          --branch $branch \
          nuttx
        git clone https://github.com/apache/nuttx-apps apps

        ## Switch to this NuttX Commit
        # pushd nuttx
        # git reset --hard 6047a9fe146ad4b4e8b2dc7bffe92d9075db429f
        # popd

        cd .. #### Added this

    # - name: Install Build Tools
    #   run:  |
    #     set -x  #  Echo commands
    #     sudo apt -y update
    #     sudo apt -y install \
    #     bison flex gettext texinfo libncurses5-dev libncursesw5-dev \
    #     gperf automake libtool pkg-config build-essential gperf genromfs \
    #     libgmp-dev libmpc-dev libmpfr-dev libisl-dev binutils-dev libelf-dev \
    #     libexpat-dev gcc-multilib g++-multilib u-boot-tools util-linux \
    #     kconfig-frontends \
    #     wget u-boot-tools

    # - name: Install Toolchain
    #   run:  |
    #     set -x  #  Echo commands
    #     wget --no-check-certificate https://github.com/xpack-dev-tools/riscv-none-elf-gcc-xpack/releases/download/v13.2.0-2/xpack-riscv-none-elf-gcc-13.2.0-2-linux-x64.tar.gz
    #     tar -xf xpack-riscv-none-elf-gcc-*.tar.gz

    # - name: Build
    #   run: |
    #     set -x  #  Echo commands

        ## Add toolchain to PATH
        # export PATH=$PATH:$PWD/xpack-riscv-none-elf-gcc-13.2.0-2/bin
        cd nuttx/nuttx

        ## Dump the git hash
        hash1=`git rev-parse HEAD`
        pushd ../apps
        hash2=`git rev-parse HEAD`
        popd
        echo NuttX Source: https://github.com/apache/nuttx/tree/$hash1 >nuttx.hash
        echo NuttX Apps: https://github.com/apache/nuttx-apps/tree/$hash2 >>nuttx.hash
        cat nuttx.hash

        ## Show the GCC and Rust versions
        riscv-none-elf-gcc -v
        rustup --version || true
        rustc  --version || true

        ## Configure the build
        tools/configure.sh rv-virt:knsh_paging

        ## Preserve the build config
        cp .config nuttx.config

        ## Run the build
        make

        ## Build Apps Filesystem
        make export
        pushd ../apps
        ./tools/mkimport.sh -z -x ../nuttx/nuttx-export-*.tar.gz
        make import
        ./tools/mkromfsimg.sh ../nuttx/arch/risc-v/src/board/romfs_boot.c
        popd
        make

        ## Generate Initial RAM Disk
        # genromfs -f initrd -d ../apps/bin -V "NuttXBootVol"

        ## Prepare a Padding with 64 KB of zeroes
        # head -c 65536 /dev/zero >/tmp/nuttx.pad
        
        ## Append Padding and Initial RAM Disk to NuttX Kernel
        # cat nuttx.bin /tmp/nuttx.pad initrd \
        #   >Image

        ## Show the size
        riscv-none-elf-size nuttx

        ## Dump the disassembly to nuttx.S
        riscv-none-elf-objdump \
          --syms --source --reloc --demangle --line-numbers --wide \
          --debugging \
          nuttx \
          >nuttx.S \
          2>&1

        ## Dump the init disassembly to init.S
        riscv-none-elf-objdump \
          --syms --source --reloc --demangle --line-numbers --wide \
          --debugging \
          ../apps/bin/init \
          >init.S \
          2>&1

        ## Dump the hello disassembly to hello.S
        riscv-none-elf-objdump \
          --syms --source --reloc --demangle --line-numbers --wide \
          --debugging \
          ../apps/bin/hello \
          >hello.S \
          2>&1

    # - name: Upload Build Outputs as Artifacts
    #   uses: actions/upload-artifact@v4
    #   with:
    #     name: nuttx.zip
    #     path: |
    #       nuttx/nuttx/nuttx*
    #       nuttx/nuttx/initrd
    #       nuttx/nuttx/init.S
    #       nuttx/nuttx/hello.S
    #       nuttx/nuttx/Image
    #       nuttx/nuttx/System.map

    # - name: Zip Build Outputs for GitHub Release
    #   run: |
        # set -x  #  Echo commands
        # cd nuttx/nuttx
        zip nuttx.zip nuttx* initrd init.S hello.S Image System.map

    # - name: Get Current Date
    #   id: date
    #   run: echo "::set-output name=date::$(date +'%Y-%m-%d-%H-%M-%S')"

    # - name: Publish the GitHub Release
    #   uses: softprops/action-gh-release@v1
    #   with:
    #     tag_name: special-qemu-riscv-knsh-paging-${{ steps.date.outputs.date }}
    #     draft: false
    #     prerelease: false
    #     generate_release_notes: false
    #     files: |
    #       nuttx/nuttx/nuttx.zip
    #       nuttx/nuttx/nuttx
    #       nuttx/nuttx/nuttx.S
    #       nuttx/nuttx/nuttx.bin
    #       nuttx/nuttx/nuttx.map
    #       nuttx/nuttx/nuttx.hex
    #       nuttx/nuttx/nuttx.config
    #       nuttx/nuttx/nuttx.manifest
    #       nuttx/nuttx/nuttx.hash
    #       nuttx/nuttx/nuttx-export*
    #       nuttx/nuttx/initrd
    #       nuttx/nuttx/init.S
    #       nuttx/nuttx/hello.S
    #       nuttx/nuttx/Image
    #       nuttx/nuttx/System.map

    # - name: Install QEMU Emulator
    #   run:  |
    #     set -x  #  Echo commands
    #     sudo apt -y update
    #     sudo apt -y install \
    #       expect qemu-system-riscv32
        qemu-system-riscv32 --version

        ## Download OpenSBI for RISC-V 32-bit
        # cd nuttx/nuttx
        wget https://github.com/riscv-software-src/opensbi/releases/download/v1.5/opensbi-1.5-rv-bin.tar.xz
        tar xf opensbi-1.5-rv-bin.tar.xz
        ls -l opensbi-1.5-rv-bin/share/opensbi/ilp32/generic/firmware/fw_dynamic.bin

    # - name: Run Test
    #   run: |
        set -x  #  Echo commands
        script=qemu-riscv-knsh
        # cd nuttx/nuttx
        wget https://raw.githubusercontent.com/lupyuen/nuttx-riscv64/main/$script.exp
        chmod +x $script.exp
        ls -l
        cat nuttx.hash
        ./$script.exp
