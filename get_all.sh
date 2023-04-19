#!/bin/sh

dart pub upgrade

cd example/client
flutter packages upgrade

cd ../server
dart pub upgrade

cd ../..