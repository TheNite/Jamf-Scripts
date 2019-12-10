#!/bin/bash
# scrap script

ps -A | grep -m1 caffeinate | awk '{print $1}'