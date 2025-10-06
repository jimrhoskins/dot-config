#!/usr/bin/env bash
cur="$(hyprctl getoption general:layout | awk '$1=="str:" {print $2; exit}')"
if [ "$cur" = "dwindle" ]; then
  hyprctl keyword general:layout master
else
  hyprctl keyword general:layout dwindle
fi

