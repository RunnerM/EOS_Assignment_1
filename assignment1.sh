# Command line arguments: $1 = led type :"led0", "led1", "led2", "led3", "all", $2 = mode: "on", "off", "heartbeat", "blink", "default" (

arg1=("led0" "led1" "led2" "led3" "all")
arg2=("on" "off" "heartbeat" "blink" "default")

led=$1
mode=$2

if [ "$#" -ne 2 ]; then
    echo "Error: Invalid number of arguments"
    exit 1
fi

if [[ ! " ${arg1[@]} " =~ " ${led} " ]]; then
    echo "Error: Invalid LED"
    exit 1
fi

if [[ ! " ${arg2[@]} " =~ " ${mode} " ]]; then
    echo "Error: Invalid mode"
    exit 1
fi

if [ "$led" = "all" ]; then
    for i in {0..3}
    do
        echo $mode > /sys/class/leds/beaglebone:green:usr$i/trigger
    done
else
    echo $mode > /sys/class/leds/beaglebone:green:$led/trigger
fi

exit 0
