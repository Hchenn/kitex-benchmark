#!/bin/bash
set -e
CURDIR=$(cd $(dirname $0); pwd)

echo "Checking whether the environment meets the requirements ..."
source $CURDIR/env.sh
echo "Check succeed."

repo=("grpc" "kitex-pb" "kitex-mux" "rpcx" "arpc" "kitex-grpc")
ports=(8000 8001 8002 8003 8004 8005)

echo "Building protobuf services by exec build_pb.sh..."
source $CURDIR/build_pb.sh
echo "Build succeed."

# benchmark
for b in ${body[@]}; do
  for c in ${concurrent[@]}; do
    for ((i = 0; i < ${#repo[@]}; i++)); do
      rp=${repo[i]}
      addr="127.0.0.1:${ports[i]}"
      # server start
      echo "Starting server [$rp], if failed please check [output/log/nohup.log] for detail."
      nohup $cmd_server $CURDIR/../output/bin/${rp}_reciever >> output/log/nohup.log 2>&1 &
      sleep 1
      echo "Server [$rp] running with [$cmd_server]"

      # run client
      echo "Client [$rp] running with [$cmd_client]"
      $cmd_client $CURDIR/../output/bin/${rp}_bencher -addr="$addr" -b=$b -c=$c -n=$n --sleep=$sleep

      # stop server
      pid=$(ps -ef | grep ${rp}_reciever | grep -v grep | awk '{print $2}')
      disown $pid
      kill -9 $pid
      echo "Server [$rp] stopped, pid [$pid]."
      sleep 1
    done
  done
done
