#!/bin/bash

################################
# vars
################################
#ANDROID_NDK
#HOST_TAG
ANDROID_ABI=$1
MIN_SDK_VERSION=$2
SHARED_LIB=$3


if [ -z ${ANDROID_NDK+x} ]; then 
  echo "ANDROID_NDK not found, set it as an environment variable!"
  exit 1
fi
if [ -z ${HOST_TAG+x} ]; then 
  echo "HOST_TAG not found, set it as an environment variable (darwin-x86_64, linux-x86_64)!"
  exit 1
fi
if [ -z "${ANDROID_ABI}" ]; then
  echo "ANDROID_ABI not found, pass it as the first argument to this script!"
  exit 1
fi
if [ -z "${MIN_SDK_VERSION}" ]; then
  echo "MIN_SDK_VERSION not found, pass it as the second argument to this script!"
  exit 1
fi

if [ -z "${SHARED_LIB}" ]; then
  echo "SHARED_LIB not set, pass it as the second argument to this script!"
  exit 1
else
  if [ ${SHARED_LIB} == "ON" ]; then
    echo "Shared library will be build!"
  else
    echo "Shared library will NOT be build!"
    SHARED_LIB="OFF"
  fi
fi


if [ ${ANDROID_ABI} == "armeabi-v7a" ]; then
  TARGET="armv7a-linux-androideabi${MIN_SDK_VERSION}"
  if [ ${MIN_SDK_VERSION} \< 16 ]; then
    echo "MIN_SDK_VERSION must be at least 16 for armeabi-v7a!"
    exit 1
  fi
elif [ ${ANDROID_ABI} == "arm64-v8a" ]; then
  TARGET="aarch64-linux-android${MIN_SDK_VERSION}"
  if [ ${MIN_SDK_VERSION} \< 21 ]; then
    echo "MIN_SDK_VERSION must be at least 21 for arm64-v8a!"
    exit 1
  fi
elif [ ${ANDROID_ABI} == "x86" ]; then
  TARGET="i686-linux-android${MIN_SDK_VERSION}"
  if [ ${MIN_SDK_VERSION} \< 16 ]; then
    echo "MIN_SDK_VERSION must be at least 16 for armeabi-v7a!"
    exit 1
  fi
elif [ ${ANDROID_ABI} == "x86-64" ]; then
  TARGET="x86_64-linux-android${MIN_SDK_VERSION}"
  if [ ${MIN_SDK_VERSION} \< 21 ]; then
    echo "MIN_SDK_VERSION must be at least 21 for armeabi-v7a!"
    exit 1
  fi
else
  echo "ANDROID_ABI is unknown!"
  exit 1
fi


IMPORTER_EXPORTER=""
for i in "${@:4}"; do
  IMPORTER_EXPORTER=${IMPORTER_EXPORTER}" ${i}"
done


ROOT=$(pwd)
TOOLCHAIN=${ANDROID_NDK}/toolchains/llvm/prebuilt/${HOST_TAG}
cd assimp

sed -i -e 's/SET( platform_libs pthread )/#SET( platform_libs pthread )/g' test/CMakeLists.txt


rm -rf android-build
mkdir -p android-build
ANDROID_BUILD=${ROOT}/assimp/android-build

cmake \
-DCMAKE_C_COMPILER=${TOOLCHAIN}/bin/clang \
-DCMAKE_CXX_COMPILER=${TOOLCHAIN}/bin/clang++ \
-DCMAKE_SYSROOT=${TOOLCHAIN}/sysroot \
-DCMAKE_CXX_FLAGS="${CMAKE_CXX_FLAGS} --target=${TARGET} -stdlib=libc++ -fexceptions -pthread" \
-DCMAKE_C_FLAGS="${CMAKE_C_FLAGS} --target=${TARGET}" \
\
-DBUILD_SHARED_LIBS=${SHARED_LIB} \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_INSTALL_PREFIX=${ANDROID_BUILD} \
\
-DANDROID=ON \
-DASSIMP_ANDROID_JNIIOSYSTEM=ON \
-DASSIMP_BUILD_ASSIMP_TOOLS=OFF \
-DASSIMP_BUILD_ZLIB=ON \
-DASSIMP_BUILD_TESTS=ON \
${IMPORTER_EXPORTER} .

make -j4
make install

BUILD=${ROOT}/build/${ANDROID_ABI}
rm -rf ${BUILD}
mkdir -p ${BUILD}
cp -r ${ANDROID_BUILD}/include ${BUILD}/include
cp -r ${ANDROID_BUILD}/lib ${BUILD}/lib
rm -rf ${BUILD}/lib/pkgconfig
rm -rf ${ROOT}/assimp/android-build

