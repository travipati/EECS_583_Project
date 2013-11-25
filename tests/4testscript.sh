rm llvmprof.out # Otherwise your profile runs are added together
clang -emit-llvm -o simple.bc -c simple.c || { echo "Failed to emit llvm bc"; exit 1; }
opt -loop-rotate < simple.bc > simple.lr.bc || { echo "Failed to opt loop simplify"; exit 1; }
opt -loop-simplify < simple.lr.bc > simple.ls.bc || { echo "Failed to opt loop simplify"; exit 1; }
opt -insert-edge-profiling simple.ls.bc -o simple.profile.ls.bc
llc simple.profile.ls.bc -o simple.profile.ls.s
g++ -o simple.profile simple.profile.ls.s /opt/llvm/Release+Asserts/lib/libprofile_rt.so
./simple.profile $2
opt -load /home/alexcope/EECS_583_Project/pass/Release+Debug+Asserts/lib/hw2pass.so -lamp-insts -insert-lamp-profiling -insert-lamp-loop-profiling -insert-lamp-init < simple.ls.bc > simple.lamp.bc || { echo "Failed to opt load"; exit 1; }
llc < simple.lamp.bc > simple.lamp.s || { echo "Failed to llc"; exit 1; }
g++ -o simple.lamp.exe simple.lamp.s /home/alexcope/EECS_583_Project/pass/tools/lamp-profiler/lamp_hooks.o || { echo "Failed to g++"; exit 1; }
./simple.lamp.exe $2
echo "Done generating lamp profile"
#clang -emit-llvm -o simple.bc -c simple.c || { echo "Failed to emit llvm bc"; exit 1; }
../../../../../opt/llvm-debug/Release+Debug+Asserts/bin/opt -load /home/alexcope/EECS_583_Project/pass/Release+Debug+Asserts/lib/proj.so -debug -profile-loader -profile-info-file=llvmprof.out -MaxUnroll -o modif.bc < simple.ls.bc > /dev/null || { echo "Failed to optload"; exit 1; }
../../../../../opt/llvm-debug/Release+Debug+Asserts/bin/opt  -simplifycfg -o modif2.bc < modif.bc > /dev/null || { echo "Failed to optload"; exit 1; }
#done with first pass, now make new profile to agressively delete dead branches put in by loop unrolling
rm llvmprof.out # Otherwise your profile runs are added together
opt -insert-edge-profiling modif2.bc -o modif2.profile.bc
#opt -load /home/alexcope/EECS_583_Project/pass/Release+Debug+Asserts/lib/hw2pass.so -lamp-insts -insert-lamp-profiling -insert-lamp-loop-profiling -insert-lamp-init < simple.ls.bc > simple.lamp.bc || { echo "Failed to opt load"; exit 1; }
llc modif2.profile.bc -o modif2.s
g++ -o modif.profile modif2.s /opt/llvm/Release+Asserts/lib/libprofile_rt.so
./modif.profile $2
../../../../../opt/llvm-debug/Release+Debug+Asserts/bin/opt -load /home/alexcope/EECS_583_Project/pass/Release+Debug+Asserts/lib/proj.so -profile-loader -profile-info-file=llvmprof.out -branchkill -o modif3.bc < modif2.profile.bc > /dev/null || { echo "Failed to optload"; exit 1; }
../../../../../opt/llvm-debug/Release+Debug+Asserts/bin/opt  -simplifycfg -o modif4.bc < modif3.bc > /dev/null || { echo "Failed to optload"; exit 1; }
../../../../../opt/llvm-debug/Release+Debug+Asserts/bin/opt  -adce -o modif5.bc < modif4.bc > /dev/null || { echo "Failed to optload"; exit 1; }
opt -dot-cfg modif5.bc
llc modif5.bc -o modif.s
#llc modif2.bc -o modif2.s
g++ -o modif modif.s /opt/llvm/Release+Asserts/lib/libprofile_rt.so
#g++ -o modif modif2.s /opt/llvm/Release+Asserts/lib/libprofile_rt.so

