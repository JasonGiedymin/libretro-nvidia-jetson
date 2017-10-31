# Instructions


## Libretro on Nvidia Jetson

[![](http://www.libretro.com/wp-content/uploads/2013/10/copy-libretro_final_thumb.png)]

![jetson](http://images.nvidia.com/content/tegra/embedded-systems/images/jetson-tx2-header-new.jpg)


### Current Release

  - [Based on `libretro-super` build `daf73cc`](https://github.com/JasonGiedymin/libretro-nvidia-jetson/releases/tag/beta-daf73cc)

### Compatibility

Should work on:
  - Nvidia Jetson TX1
  - Nvidia Jetson TX2


### Scripts

The following shell script below may work as-is. If it doesn't you want to use the commands within the script manually.

The precompiled cores can be found on the releases page.

I haven't had enough rounds of testing to complete the automated work you see below. In the near future my goals are to sync this repo with upstream libretro as well as merge the necessary changes into the upstream repository eventually. Most of the scripts as you see them now need to be cleaned up.

```shell
export SHALLOW_CLONE=1

# deps
sudo apt-get -y install build-essential libxkbcommon-dev zlib1g-dev libfreetype6-dev libegl1-mesa-dev libgles2-mesa-dev libgbm-dev libavcodec-dev libsdl2-dev libsdl-image1.2-dev libxml2-dev yasm g++ make libsdl2-dev libmpeg2-4-dev libogg-dev libvorb is-dev libflac-dev libmad0-dev libpng-dev libtheora-dev libfaad-dev libfluidsynth-dev zlib1g-dev liblog4cplus-dev liblog4cpp5-dev build-essential libncursesw5-dev bison flex liblua5.1-0-dev libsqlite3-dev libz-dev pkg-config libsdl2-image-dev libsdl2-mixer-dev libpng-dev ttf-dejavu-core

# build sdl2

# initial repo
git clone --depth=1 https://github.com/libretro/libretro-super

# dive into libretro
cd libretro-super

# fetch
./libretro-fetch.sh

# copy the patches over
cp -R libretro-super-patches/* libretro-super/

# build retroarch
./retroarch-build.sh

# build cores manually if they fail
# ensure no neon
# ensure no abi-hard
./libretro-build.sh

# lutro will fail, rebuild manually
pushd libretro-lutro
make clean
make
popd

# desmume will fail, rebuild manually
pushd libretro-desmume
make clean
# Important not to declare arm here, let the platform be detected
make
popd

# rebuild scummvm, and this compile is long
pushd libretro-scummvm/backends/platform/libretro/build
DEFINES="-fpermissive" make
popd

# rebuild mame2010
pushd libretro-mame2010
make "platform=arm" "VRENDER=soft" buildtools
make "platform=arm" "VRENDER=soft" emulator
popd

# rebuild stonesoup
pushd libretro-stonesoup
make -f Makefile.libretro
popd

# rebuild mame2016
pushd libretro-mame2016
make -f Makefile.libretro
popd

# rebuild mame
pushd libretro-mame
make -f Makefile.libretro "platform=arm"
popd

# rebuild emux_chip8
pushd libretro-emux_chip8
make -f Makefile.arm64-v8a "platform=arm" MACHINE=chip8
make -f Makefile.arm64-v8a "platform=arm" MACHINE=gb
make -f Makefile.arm64-v8a "platform=arm" MACHINE=nes
make -f Makefile.arm64-v8a "platform=arm" MACHINE=sms
popd

# Does not work -----------
pushd libretro-ffmpeg/libretro
./configure
make "platform=arm"
sudo make install
popd

# rebuild ppsspp
pushd libretro-ppsspp/libretro
make "platform=aarch64"
popd
# -------------------------

# install to /usr/lib/libretro
make install
# or ./libretro-install.sh <location>
