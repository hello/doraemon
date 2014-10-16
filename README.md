doraemon
========

Automated testing and build for firmware for factory

To use:
./load.sh $BUILD_TYPE

$BUILD_TYPE is defined by a folder in the targets directory.

Example:
target/
  | sense_evt/
      | target.sh
      | other crap

run by calling ./load.sh sense_evt
will automatically call the target.sh in the directory and run setup/cleanup scripts in the common directory
