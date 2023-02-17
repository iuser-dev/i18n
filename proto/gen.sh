#!/usr/bin/env bash

DIR=$(dirname $(realpath "$0"))
cd $DIR
set -ex

out=../hsproxy/hsproxy
python3 -m grpc_tools.protoc -I. --python_out=$out --grpclib_python_out=$out ./i18n.proto

sd 'import ([^\s]+)_pb2' 'from . import ${1}_pb2' $out/i18n_grpc.py

protoc \
  -I . \
  --plugin=./node_modules/.bin/protoc-gen-ts_proto \
  --ts_proto_opt=snakeToCamel=false \
  --ts_proto_opt=lowerCaseServiceMethods=true \
  --ts_proto_out=../i18n \
  --ts_proto_opt=forceLong=number \
  --ts_proto_opt=env=browser \
  --ts_proto_opt=outputPartialMethods=false\
  --ts_proto_opt=outputJsonMethods=false \
  --ts_proto_opt=oneof=unions \
  --ts_proto_opt=esModuleInterop=true \
  --ts_proto_opt=enumsAsLiterals=true \
  --ts_proto_opt=unrecognizedEnum=false \
  --ts_proto_opt=outputServices=grpc-js \
  ./i18n.proto

bun run tsc --p ..
