# Building llama.cpp shared libraries for Quorivell

Quorivell uses `llama_cpp_dart` **0.2.2**, which does **not** embed llama.cpp.
Android **prebuilt** `.so` files for `arm64-v8a` and `x86_64` are committed
under `android/app/src/main/jniLibs/` so `flutter run` works without a native
rebuild. Use this doc when you need to **rebuild or refresh** those binaries.

## Pin (required)

Build from llama.cpp commit:

```text
4ffc47cb2001e7d523f9ff525335bbe34b1a2858
```

A mismatched newer tree often **SIGSEGVs** on load. After replacing `.so`
files, do a **full reinstall** of the app (not just hot restart).

## What Quorivell loads

Per ABI directory (`android/app/src/main/jniLibs/<abi>/`):

| File | Role |
| --- | --- |
| `libllama.so` | Main llama.cpp library (loaded by name) |
| `libggml.so` | ggml |
| `libggml-base.so` | ggml base |
| `libggml-cpu.so` | CPU backend (registered at startup) |
| `libc++_shared.so` | NDK C++ runtime |

Shipped ABIs today: `arm64-v8a`, `x86_64` (emulator).

## Android rebuild (outline)

Prerequisites: Android NDK (side-by-side with your Flutter Android toolchain),
CMake, Ninja (or the NDK’s build tools).

```bash
git clone https://github.com/ggerganov/llama.cpp.git
cd llama.cpp
git checkout 4ffc47cb2001e7d523f9ff525335bbe34b1a2858

# Example arm64-v8a — adjust ANDROID_NDK and ABI as needed
cmake -S . -B build-android-arm64 \
  -DCMAKE_TOOLCHAIN_FILE="$ANDROID_NDK/build/cmake/android.toolchain.cmake" \
  -DANDROID_ABI=arm64-v8a \
  -DANDROID_PLATFORM=android-24 \
  -DBUILD_SHARED_LIBS=ON \
  -DGGML_NATIVE=OFF \
  -DLLAMA_BUILD_TESTS=OFF \
  -DLLAMA_BUILD_EXAMPLES=OFF \
  -DLLAMA_BUILD_SERVER=OFF

cmake --build build-android-arm64 --config Release
```

Copy the shared objects into:

```text
android/app/src/main/jniLibs/arm64-v8a/
```

Repeat with `-DANDROID_ABI=x86_64` for the emulator ABI. Copy `libc++_shared.so`
from the NDK’s `toolchains/llvm/prebuilt/.../sysroot/usr/lib/<triple>/`
(or the ABI folder your NDK documents) next to the llama/ggml libraries.

Exact CMake flags can vary slightly across llama.cpp revisions; if link or load
fails, prefer matching whatever flags produced the currently shipped jniLibs
and keep the **commit pin** above.

## Windows (desktop / host tooling)

```text
# Build shared llama.dll + ggml*.dll from the same pin, then place them
# in the Flutter project directory or next to the runner executable.
```

Windows DLLs are **not** committed (see `.gitignore`). Rebuild locally when
developing on Windows desktop.

## Runtime notes

- Quorivell prefers CPU inference (`n_gpu_layers=0`).
- On Android, load often uses `use_mmap=false` with one mmap retry.
- Prefer profile/release when timing isolate spawn; debugger-attached loads can
  look frozen.

Product context: [architecture Appendix A](../architecture.md#appendix-a-on-device-model-ops).
