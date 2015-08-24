#!/system/bin/sh

# Parse Mode Enforcement from prop
if [ "`grep "kernel.turbo=true" /system/unikernel.prop`" != "" ]; then
	echo "Y" > /sys/module/cpufreq_interactive/parameters/enforce_toggle
fi

# Wait for 5 second so we pass out of init before starting the rest of the script
sleep 5

# Start SuperSU daemon
/system/xbin/daemonsu --auto-daemon &

# Parse IO Scheduler from prop
if [ "`grep "kernel.scheduler=noop" /system/unikernel.prop`" != "" ]; then
	echo "noop" > /sys/block/mmcblk0/queue/scheduler
    	echo "noop" > /sys/block/sda/queue/scheduler
    	echo "noop" > /sys/block/sdb/queue/scheduler
    	echo "noop" > /sys/block/sdc/queue/scheduler
    	echo "noop" > /sys/block/vnswap0/queue/scheduler
elif [ "`grep "kernel.scheduler=fiops" /system/unikernel.prop`" != "" ]; then
	echo "fiops" > /sys/block/mmcblk0/queue/scheduler
    	echo "fiops" > /sys/block/sda/queue/scheduler
    	echo "fiops" > /sys/block/sdb/queue/scheduler
    	echo "fiops" > /sys/block/sdc/queue/scheduler
    	echo "fiops" > /sys/block/vnswap0/queue/scheduler
elif [ "`grep "kernel.scheduler=bfq" /system/unikernel.prop`" != "" ]; then
	echo "bfq" > /sys/block/mmcblk0/queue/scheduler
    	echo "bfq" > /sys/block/sda/queue/scheduler
    	echo "bfq" > /sys/block/sdb/queue/scheduler
    	echo "bfq" > /sys/block/sdc/queue/scheduler
    	echo "bfq" > /sys/block/vnswap0/queue/scheduler
elif [ "`grep "kernel.scheduler=deadline" /system/unikernel.prop`" != "" ]; then
	echo "deadline" > /sys/block/mmcblk0/queue/scheduler
    	echo "deadline" > /sys/block/sda/queue/scheduler
    	echo "deadline" > /sys/block/sdb/queue/scheduler
    	echo "deadline" > /sys/block/sdc/queue/scheduler
    	echo "deadline" > /sys/block/vnswap0/queue/scheduler
else
	echo "cfq" > /sys/block/mmcblk0/queue/scheduler
    	echo "cfq" > /sys/block/sda/queue/scheduler
    	echo "cfq" > /sys/block/sdb/queue/scheduler
    	echo "cfq" > /sys/block/sdc/queue/scheduler
    	echo "cfq" > /sys/block/vnswap0/queue/scheduler
fi

# Parse VM Tuning from prop
if [ "`grep "kernel.vm=tuned" /system/unikernel.prop`" != "" ]; then
	# start swap with 1.8gb vnswap0
	/sbin/sswap -s -f 1843
	echo "200"	> /proc/sys/vm/vfs_cache_pressure
	echo "400"	> /proc/sys/vm/dirty_expire_centisecs
	echo "400"	> /proc/sys/vm/dirty_writeback_centisecs
	echo "145"	> /proc/sys/vm/swappiness
	echo "32"	> /sys/block/sda/queue/read_ahead_kb
	echo "32"	> /sys/block/sdb/queue/read_ahead_kb
	echo "32"	> /sys/block/sdb/queue/read_ahead_kb
	echo "32"	> /sys/block/vnswap0/queue/read_ahead_kb
else
	# start swap with stock 1.2gb vnswap0
	/sbin/sswap -s -f 1280
fi

# Parse InputBoost from prop
if [ "`grep "kernel.inputboost=false" /system/unikernel.prop`" != "" ]; then
	echo "Y" > /sys/module/input_booster/parameters/inputboost_toggle
fi

# Parse Interactive tuning from prop
if [ "`grep "kernel.interactive=performance" /system/unikernel.prop`" != "" ]; then
	#apollo
	echo "15000"	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/above_hispeed_delay
	echo "85" 	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/go_hispeed_load
	echo "75" 	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/target_loads
	echo "45000"	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/min_sample_time
	echo "10000"	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_rate
	echo "10000"	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_slack
	echo "25000"	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/boostpulse_duration
	echo "1"	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/io_is_busy
	#atlas
	echo "15000"	> /sys/devices/system/cpu/cpu4/cpufreq/interactive/above_hispeed_delay
	echo "90" 	> /sys/devices/system/cpu/cpu4/cpufreq/interactive/go_hispeed_load
	echo "85"	> /sys/devices/system/cpu/cpu4/cpufreq/interactive/target_loads
	echo "45000"	> /sys/devices/system/cpu/cpu4/cpufreq/interactive/min_sample_time
	echo "10000"	> /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_rate
	echo "105000"	> /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_slack
	echo "25000"	> /sys/devices/system/cpu/cpu4/cpufreq/interactive/boostpulse_duration
	echo "1"	> /sys/devices/system/cpu/cpu4/cpufreq/interactive/io_is_busy
elif [ "`grep "kernel.interactive=battery" /system/unikernel.prop`" != "" ]; then
	#apollo
	echo "30000"	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/above_hispeed_delay
	echo "95" 	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/go_hispeed_load
	echo "90" 	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/target_loads
	echo "800000"	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/hispeed_freq
	echo "15000"	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/min_sample_time
	echo "45000"	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_rate
	echo "15000"	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_slack
	echo "10000"	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/boostpulse_duration
	#atlas
	echo "70000 1500000:45000 1700000:30000" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/above_hispeed_delay
	echo "99" 	> /sys/devices/system/cpu/cpu4/cpufreq/interactive/go_hispeed_load
	echo "85 1300000:90" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/target_loads
	echo "1000000"	> /sys/devices/system/cpu/cpu4/cpufreq/interactive/hispeed_freq
	echo "10000"	> /sys/devices/system/cpu/cpu4/cpufreq/interactive/min_sample_time
	echo "45000"	> /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_rate
	echo "15000"	> /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_slack
	echo "10000"	> /sys/devices/system/cpu/cpu4/cpufreq/interactive/boostpulse_duration
fi

# Parse GApps wakelock fix from prop
if [ "`grep "kernel.gapps=true" /system/unikernel.prop`" != "" ]; then
	sleep 30
	su -c "pm enable com.google.android.gms/.update.SystemUpdateActivity"
	su -c "pm enable com.google.android.gms/.update.SystemUpdateService"
	su -c "pm enable com.google.android.gms/.update.SystemUpdateService$ActiveReceiver"
	su -c "pm enable com.google.android.gms/.update.SystemUpdateService$Receiver"
	su -c "pm enable com.google.android.gms/.update.SystemUpdateService$SecretCodeReceiver"
	su -c "pm enable com.google.android.gsf/.update.SystemUpdateActivity"
	su -c "pm enable com.google.android.gsf/.update.SystemUpdatePanoActivity"
	su -c "pm enable com.google.android.gsf/.update.SystemUpdateService"
	su -c "pm enable com.google.android.gsf/.update.SystemUpdateService$Receiver"
	su -c "pm enable com.google.android.gsf/.update.SystemUpdateService$SecretCodeReceiver"
fi

