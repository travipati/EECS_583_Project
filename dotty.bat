export PATH=$PATH:/opt/llvm/Release+Asserts/bin
opt -dot-cfg $1.bc
