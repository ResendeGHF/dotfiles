#!/bin/sh
# ~/.config/sway/scripts/status.sh

while :; do
    mem=$(awk '/MemTotal/{t=$2} /MemAvailable/{a=$2} END{printf "%.1fG", (t-a)/1048576}' /proc/meminfo)

    vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null \
        | awk '/MUTED/{print "muted"; exit} {printf "%d%%", $2*100}')

    bat=""
    for b in /sys/class/power_supply/BAT*; do
        [ -r "$b/capacity" ] && bat="bat $(cat "$b/capacity")%   "
    done

    echo "${bat}vol ${vol}   mem ${mem}   $(date +'%a %d %b  %H:%M')"
    sleep 5
done
