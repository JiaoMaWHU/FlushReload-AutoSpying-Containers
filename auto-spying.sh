#!/bin/bash

echo "Spying Start..."
cleanup (){
    echo "Spying Exit..."
    exit 0
}
trap cleanup SIGINT SIGTERM
while true
do
    rm -f ~/attack_spying/*
    timeout -k 7s 7s ruby ~/flush-reload-attacks/flush-reload/myversion/ruby/AttackRecorderAuto.rb \
        --spy-binary ~/flush-reload-attacks/experiments/links/binaries/links-demo \
        --probe-file ~/flush-reload-attacks/experiments/links/binaries/links-demo.probes \
        --output-dir ~/attack_spying
    if [ -n "$(ls -A ~/attack_spying)" ]; then
        ~/flush-reload-attacks/flush-reload/myversion/ruby/AttackRecoveryAuto.rb \
            --recording-dir ~/attack_spying \
            --train-dir ~/attack_training/demo1 \
            --max-length 1000
    fi
done