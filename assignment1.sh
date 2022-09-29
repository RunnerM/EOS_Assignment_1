# Command line arguments: $1 = led type :"led0", "led1", "led2", "led3", "all", $2 = mode: "on", "off", "heartbeat", "blink", "default" (

arg1=("led0" "led1" "led2" "led3" "all")
arg2=("on" "off" "heartbeat" "blink" "default")

led=$1
mode=$2

for i in "$@"; do
  case $i in
    -h|--help)
      displayhelp
      ;;
  esac
done      

if [ "$#" -ne 2 ]; then
    echo "Error: Invalid number of arguments"
    displayhelp
fi

if [[ ! " ${arg1[@]} " =~ " ${led} " ]]; then
    echo "Error: Invalid LED"
    displayhelp
fi

if [[ ! " ${arg2[@]} " =~ " ${mode} " ]]; then
    echo "Error: Invalid mode"
    displayhelp
fi

if [ mode == "blink" ]; then
    frequency=$3
    setblink(frequency)
fi


if [ "$led" = "all" ]; then
    for i in {0..3}
    do
        mapmode(mode, i)
        echo $mode > /sys/class/leds/beaglebone:green:usr$i/trigger
    done
else
    mapmode(mode,0)
    echo $mode > /sys/class/leds/beaglebone:green:$led/trigger
fi

exit 0


function displayhelp {
    echo "Usage: assignment1.sh [led] [mode]"
    echo "led: led0, led1, led2, led3, all"
    echo "mode: on, off, heartbeat, blink, default"
    echo "Example: assignment1.sh led0 on"
    echo "If blink than provide frequency as third argument"
    exit 1
}

function setblink (frequency) {
    delay=(1000/$frequency)/2
    echo "timer" > /sys/class/leds/beaglebone:green:$led/trigger
    echo "$delay" > /sys/class/leds/beaglebone:green:$led/delay_on
    echo "$delay" > /sys/class/leds/beaglebone:green:$led/delay_off
    exit 0
}

function mapmode (mode, i) {
    case $mode in
        "on")
            mode = "default-on"
            ;;
        "off")
            mode = "none"
            ;;
        "heartbeat")
            mode = "heartbeat"
            ;;
        "default")
                if i==0
                    mode = "heartbeat"
                elif i==1
                    mode = "mmc0"
                elif i==2
                    mode = "cpu0"
                elif i==3
                    mode = "mmc1"
                fi
            ;;
    esac
}