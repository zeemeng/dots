#!/usr/bin/env sh

# Get the start time of the tmux session
start_time=$(tmux display-message -p -F "#{session_created}")

# Get the current time
current_time=$(date +%s)

# Calculate the uptime in seconds
uptime=$((current_time - start_time))

# Convert uptime to a human-readable format (days, hours, minutes, seconds)
day=$((uptime / 86400))
hr=$(( (uptime % 86400) / 3600 ))
min=$(( (uptime % 3600) / 60 ))
sec=$((uptime % 60))

# Print the uptime
fg="colour235"
bg="#ec9929"
output="#[bold]${sec}#[nobold]s"
[ "$min" -gt 0 ] && output="#[bold]${min}#[nobold]m $output"
[ "$hr" -gt 0 ] && output="#[bold]${hr}#[nobold]h $output"
[ "$day" -gt 0 ] && output="#[bold]${day}#[nobold]d $output"
printf "#[bg=$bg,fg=$fg] #[bold]⏱#[nobold] $output \n"

