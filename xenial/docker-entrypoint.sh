#!/bin/sh

set -e

EXIT_DIR=$(pwd)

err_handler() {
  #shellcheck disable=SC2181
  [ $? -eq 0 ] && exit
  cd "$EXIT_DIR"
}

trap err_handler EXIT

build_grasp_plugin() {
  mkdir -p /opt/choreonoid/build
  cd /opt/choreonoid/build
  cmake ..\
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_CORBA_PLUGIN:BOOL=ON \
    -DBUILD_GRASP_PCL_PLUGIN:BOOL=ON \
    -DBUILD_GROBOT_PLUGIN:BOOL=ON \
    -DBUILD_OPENRTM_PLUGIN:BOOL=ON \
    -DBUILD_PYTHON_PLUGIN:BOOL=ON \
    -DCNOID_ENABLE_GETTEXT:BOOL=ON \
    -DENABLE_CORBA:BOOL=ON \
    -DOPENRTM_DIR:PATH=/home/usr \
    -DOpenRTM_DIR:PATH=/home/usr/lib/openrtm-1.1/cmake \
    -DUSE_QT5:BOOL=ON \
    -DGRASP_PLUGINS="CnoidRos;ConstraintIK;GeometryHandler;Grasp;GraspConsumer;GraspDataGen;MotionFile;ObjectPlacePlanner;PCL;PRM;PickAndPlacePlanner;RobotInterface;RtcGraspPathPlan;SoftFingerStability;VisionTrigger;"
  cmake --build .
  cd "$EXIT_DIR"
}

if [ "$1" = build ]; then
  shift
  build_grasp_plugin
  if [ "$1" = exit ]; then
    exit
  fi
fi

if [ $# -eq 0 ]; then
  exec /bin/bash
else
  exec "$@"
fi
