while true; do
    if grep -q closed /proc/acpi/button/lid/LID/state; then
        swaylock --clock --screenshots --effect-pixelate 5
    fi
    sleep 1
done
