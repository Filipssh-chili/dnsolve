#!/bin/sh
# Builds the dnsolve_native library for iOS and Android.
#
# Copy the generated builds to your project:
#
# - `/native/target/jniLibs` to `/android/app/src/main/jniLibs`,
#   - to `android/app/build.gradle` under android add:
#     externalNativeBuild {
#       cmake {
#         path "../CMakeLists.txt"
#       }
#     }
#   - Create android/CMakeLists.txt:
#   cmake_minimum_required(VERSION 3.22)
#   add_library(
#           dnsolve_native
#           SHARED
#           IMPORTED
#           GLOBAL
#   )
#   set_target_properties(dnsolve_native PROPERTIES IMPORTED_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}/app/src/main/jniLibs/${ANDROID_ABI}/libdnsolve_native.so)
#
# - `native/target/DNSolve.xcframework` to `/ios/Runner/Frameworks`
#   - Link it in xcode: `Runner -> General -> Frameworks, Libraries, and Embedded Content`

rustup target add \
    aarch64-linux-android \
    armv7-linux-androideabi \
    x86_64-linux-android \
    i686-linux-android \
    aarch64-apple-ios \
    aarch64-apple-ios-sim \
    x86_64-apple-ios && \
rm -rf ./target ./include/libdnsolve_native.h && \
cbindgen --config cbindgen.toml --crate dnsolve_native --output include/libdnsolve_native.h && \
xcframework && \
cargo ndk -t x86_64 -t x86 -t armeabi-v7a -t arm64-v8a -o ./target/jniLibs build --release