#!/bin/bash

set -e

echo -n "Copying cores..."

# copy info files
# for file in `find . -path ./dist -prune -o -name "*_libretro.info" -print`; do
#     cp "$file" dist/info/
#     echo -n "."
# done

# copy cores
for file in `find . -path ./dist -prune -o -name "*_libretro.so" -print`; do
    cp "$file" dist/unix/
    echo -n "."
done

# copy cores with arch names
for file in `find . -path ./dist -prune -o -name "*_libretro.*64*.so" -print`; do
    cp "$file" dist/unix/
    echo -n "."
done

echo "done"
