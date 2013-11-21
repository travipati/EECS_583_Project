#!/bin/bash
export fname=$1
export PATH=$PATH:/opt/llvm/Release+Asserts/bin
rm llvmprof.out # Otherwise your profile runs are added together
clang -emit-llvm -o $fname.bc -c $fname.c
opt -insert-edge-profiling $fname.bc -o $fname.profile.bc
llc $fname.profile.bc -o $fname.profile.s
g++ -o $fname.profile $fname.profile.s /opt/llvm/Release+Asserts/lib/libprofile_rt.so
./$fname.profile $2
clang -emit-llvm -o $fname.bc -c $fname.c || { echo "Failed to emit llvm bc"; exit 1; }
opt -loop-simplify < $fname.bc > $fname.ls.bc || { echo "Failed to opt loop simplify"; exit 1; }
opt -insert-edge-profiling $fname.ls.bc -o $fname.profile.ls.bc
llc $fname.profile.ls.bc -o $fname.profile.ls.s
g++ -o $fname.profile $fname.profile.ls.s /opt/llvm/Release+Asserts/lib/libprofile_rt.so
./$fname.profile $2
opt -load ./Release+Asserts/lib/approx.so -lamp-insts -insert-lamp-profiling -insert-lamp-loop-profiling -insert-lamp-init < $fname.ls.bc > $fname.lamp.bc || { echo "Failed to opt load"; exit 1; }
llc < $fname.lamp.bc > $fname.lamp.s || { echo "Failed to llc"; exit 1; }
g++ -o $fname.lamp.exe $fname.lamp.s ./tools/lamp-profiler/lamp_hooks.o || { echo "Failed to 
g++"; exit 1; }
./$fname.lamp.exe $2
echo "Done generating lamp profile"
opt -load ./Release+Asserts/lib/approx.so -lamp-inst-cnt -lamp-map-loop -lamp-load-profile -profile-loader -profile-info-file=llvmprof.out -slicm < $fname.ls.bc > $fname.intelligent-slicm.bc || { echo "Failed to optload"; exit 1; }
opt -dot-cfg $fname.intelligent-slicm.bc
xdot cfg.main.dot & 
