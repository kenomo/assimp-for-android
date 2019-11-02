# Assimp for Android
The scripts will help you to cross-compile [Assimp](https://github.com/assimp/assimp) **v5.0.0** for Android.
It requires at least Android **NDK r19**, because it uses the NDK in-place toolchain. So one does not need to make a standalone toolchain for an arbitrary build system.
Just get yourself a fresh [NDK version](https://developer.android.com/ndk/downloads) and place it somewhere besides your Android Studio, if you missing an NDK version beyond r19.

The minimum SDK version depends on the ABI as follows:

| ABI | MIN_SDK_VERSION |
|--|--|
| armeabi-v7a | 16 |
| arm64-v8a | 21 |
| x86 | 16 |
| x86-64 | 21 |
 
 If you want to support SDK versions below these named, you have to make a [standalone toolchain](https://developer.android.com/ndk/guides/standalone_toolchain).


## Usage

The example builds **shared** and **static** libs for a 64-bit ARM Android (**arm64-v8a**) with a minimum SDK version of **21**. The includes and binaries are found under `assimp-for-android/build/arm64-v8a`.
```bash
git clone https://github.com/kenomo/assimp-for-android.git
cd assimp-for-android
./download.sh
export ANDROID_NDK=PATH-TO-THE-ANDROID-NDK-FOLDER
export HOST_TAG=YOUR-HOST-TAG
./build.sh arm64-v8a 21 ON
```

## HOST_TAG

| NDK OS Variant | Host Tag |
|--|--|
| macOS | darwin-x86_64 |
| Linux | linux-x86_64 |


## ./build.sh

The build script takes at least 3 arguments defining the ABI, the  MIN_SDK_VERSION and building either shared librarys (*ON*) or not (*OFF*). Static libraries will always be build.
``` bash
./build.sh ABI MIN_SDK_VERSION BUILD_SHARED_LIBS
```

## Importer/Exporter
In addition one can turn *ON* or *OFF* Assimp importer and exporter.

By default, the following importer formats are enabled
- AMF 3DS AC ASE ASSBIN B3D BVH COLLADA DXF CSM HMP IRRMESH IRR LWO LWS MD2 MD3 MD5 MDC MDL NFF NDO OFF OBJ OGRE OPENGEX PLY MS3D COB BLEND IFC XGL FBX Q3D Q3BSP RAW SIB SMD STL TERRAGEN 3D X X3D GLTF 3MF MMD STEP

and the following exporter formats:
- 3DS ASSBIN ASSXML COLLADA OBJ OPENGEX PLY FBX STL X X3D GLTF 3MF ASSJSON STEP

They can be disabled by adding e. g.:
- -DASSIMP_BUILD_**AMF**_IMPORTER=OFF
- -DASSIMP_BUILD_**3DS**_EXPORTER=OFF

to the `./build.sh`.

``` bash
./build.sh ABI MIN_SDK_VERSION BUILD_SHARED_LIBS -DASSIMP_BUILD_AMF_IMPORTER=OFF -DASSIMP_BUILD_3DS_EXPORTER=OFF
```
