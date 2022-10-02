#!/bin/bash
# Command line arguments: $1 = led type :"led0", "led1", "led2", "led3", "all", $2 = mode: "on", "off", "heartbeat", "blink", "default" (
#Marton Pentek 293649 | Matey Matev 285041


arg1=("led0" "led1" "led2" "led3" "all")
arg2=("on" "off" "heartbeat" "blink" "default")

led="$1"
mode="$2"

displayhelp () {
    echo "Usage: assignment1.sh [led] [mode]"
    echo "led: led0, led1, led2, led3, all"
    echo "mode: on, off, heartbeat, blink, default"
    echo "Example: assignment1.sh led0 on"
    echo "If blink than provide frequency as third argument"
    exit 1
}

setblink () {
	delay=$(((1000/$1)/2))
    echo "timer" > /sys/class/leds/beaglebone:green:$led/trigger
    echo "$delay" > /sys/class/leds/beaglebone:green:$led/delay_on
    echo "$delay" > /sys/class/leds/beaglebone:green:$led/delay_off
}

mapled () {
    case "$led" in
	led0)
            led="usr0"
            ;;
        led1)
            led="usr1"
            ;;
        led2)
            led="usr2"
            ;;
        led3)
            led="usr3"
            ;;
    esac
}

mapmode () {
    case $1 in
        "on")
            mode="default-on"
            ;;
        "off")
            mode="none"
            ;;
        "heartbeat")
            mode="heartbeat"
            ;;
        "default")
                if [ "$2" -eq 0 ]; then
                    mode="heartbeat"
                elif [ "$2" -eq 1 ]; then
                    mode="mmc0"
                elif [ "$2" -eq 2 ]; then
                    mode="cpu0"
                elif [ "$2" -eq 3 ]; then
                    mode="mmc1"
                fi
            ;;
    esac
}


for i in "$@"; do
  case $i in
    -h|--help)
      displayhelp
      ;;
  esac
done

if [ "$#" -lt 2 ]; then
    echo "Error: Invalid number of arguments" 1>&2
    displayhelp 1>&2
fi

if [[ ! " ${arg1[@]} " =~ " ${led} " ]]; then
    echo "Error: Invalid LED" 1>&2
    displayhelp 1>&2
fi

if [[ ! " ${arg2[@]} " =~ " ${mode} " ]]; then
    echo "Error: Invalid mode" 1>&2
    displayhelp 1>&2
fi

if [ "$mode" = "blink" ]; then
    frequency=$3
    mapled
    setblink "$frequency"
fi


if [ "$led" = "all" ]; then
    for i in {0..3}
    do
        mapmode "$mode" $i
        echo $mode > /sys/class/leds/beaglebone:green:usr$i/trigger
    done
else
    mapmode "$mode" 0
    mapled
    if [ "$mode" = "blink" ]; then
        setblink "$frequency"
    else
        echo $mode > /sys/class/leds/beaglebone:green:$led/trigger
    fi
fi
