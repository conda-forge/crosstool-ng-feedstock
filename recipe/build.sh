#!/bin/bash

# Script and meta.yaml taken from https://github.com/AnacondaRecipes/aggregate/blob/088dd9dc0296bd0e5fdba1b3d2f2c2babd359327/crosstool-ng-feedstock/recipe/build.sh

export EXTRA_CFLAGS="-I${PREFIX}/include -I${PREFIX}/include/ncurses"
export EXTRA_LDFLAGS="-L${PREFIX}/lib -Wl,-rpath,${PREFIX}/lib -lncursesw"
# -rpath-link is needed because libncursesw.so dependes on libtinfo.so and
# configure will fail to find ncurses without it (if using the conda ncurses
# package).

# These get baked into paths.mk but we do not relocate them nor add
# run requirements for them.
unset LIBTOOL
unset LIBTOOLIZE
unset OBJCOPY
unset OBJDUMP
unset READELF
export BASH="/usr/bin/env bash"
export AWK="/usr/bin/env gawk"
export GREP="/usr/bin/env grep"
export MAKE="/usr/bin/make"
export SED="/usr/bin/env sed"
export OBJCOPY="/usr/bin/env objcopy"
export OBJDUMP="/usr/bin/env objdump"
export READELF="/usr/bin/env readelf"
export PATCH="/usr/bin/env patch"
export GPERF="/usr/bin/env gperf"
unset ncurses

export CPPFLAGS="-I${PREFIX}/include -L${PREFIX}/lib -Wl,-rpath-link,${PREFIX}/lib"
if [[ $(uname) == Darwin ]]; then
  export DYLD_FALLBACK_LIBRARY_PATH=${PREFIX}/lib
fi
./bootstrap
./configure --prefix=${PREFIX} || (cat config.log && exit 1)
make -j${CPU_COUNT} ${VERBOSE_AT}
make install
