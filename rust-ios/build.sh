#!/bin/sh

cargo clean
cargo install cbindgen
cbindgen src/lib.rs -l c > rust-ios.h
cargo install cargo-lipo
cargo lipo --release

rm -rf ../ios-local-internet-archive/rust-ios

mkdir -p ../ios-local-internet-archive/rust-ios/libs
mkdir -p ../ios-local-internet-archive/rust-ios/include

cp rust-ios.h ../ios-local-internet-archive/rust-ios/include
cp target/universal/release/librust_ios.a ../ios-local-internet-archive/rust-ios/libs