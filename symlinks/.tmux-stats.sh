#!/usr/bin/env bash
# Stats système pour la barre de statut tmux (macOS)
# Appelé par status-right via #(~/.tmux-stats.sh)

# CPU load average (1 min)
cpu=$(sysctl -n vm.loadavg | awk '{printf "%.1f", $2}')

# RAM : pages actives + wired vs total
ram_stats=$(vm_stat)
page_size=$(sysctl -n hw.pagesize)
pages_active=$(echo "$ram_stats" | awk '/Pages active/ {gsub("\\.", "", $3); print $3}')
pages_wired=$(echo "$ram_stats" | awk '/Pages wired down/ {gsub("\\.", "", $4); print $4}')
pages_total=$(sysctl -n hw.memsize)
used_bytes=$(( (pages_active + pages_wired) * page_size ))
total_bytes=$pages_total
ram_pct=$(( used_bytes * 100 / total_bytes ))

# Batterie
bat=$(pmset -g batt 2>/dev/null | grep -Eo '[0-9]+%' | head -1)

echo "CPU:${cpu} RAM:${ram_pct}% BAT:${bat:-N/A}"
