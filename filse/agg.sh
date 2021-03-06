 #!/system/bin/sh

#=======================================#
#VARIABLES===============================#
BB=/data/adb/magisk/busybox
CLOG=/data/media/0/Android/.libbin/.mkadpshshsh/YourBLchanges.log
BRANCH="Aggressive-Profile"
#=======================================#
#=======================================#

 su -lp 2000 -c "cmd notification post -S bigtext -t 'OxyPlus Descrete' 'Tag' 'Aggressive Profile started applying
 At $(date)'"

#=======================================#
#VARIABLES==============================#
NEWLOG2=/data/media/0/.mkadp.log
LOGFU=/data/media/0/butterlimits.log
#=======================================#
LOG2=/data/data/com.mkadp.oxyplusd/files/butterlimits.log
LOG2A=/data/data/com.mkadp.oxyplusd/files/zbutterlimits.log
LOG2B=/data/data/com.mkadp.oxyplusd/files/zzbutterlimits.log
FILEZERO=/data/data/com.mkadp.oxyplusd/files/scrpt.sh
pme='pm enable'
pmd='pm disable'
#=======================================#
#=======================================#

rm -rf $LOG2
rm -rf $LOG2A
rm -rf $LOG2B

$BB wget https://raw.githubusercontent.com/DevMohitash/opd11/main/filse/agg -O /data/media/0/zzagg
$BB cp -rf /data/media/0/zzagg $FILEZERO
$BB rm -rf /data/media/0/zzagg

kmsg() {
	echo -e "[*] $@" >> $LOG2B
}

kmsg2() {
	echo -e "[*] $@" >> $LOG2
}

# Safely write value to file
_ctl() {
	# Bail out if file does not exist
	[[ ! -f "$1" ]] && return 1
	
	chmod +w "$1" 2> /dev/null

	# Fetch the current key value
	local curval=`cat "$1" 2> /dev/null`

	# Bail out if value is already set
	[[ "$curval" == "$2" ]] && return 0

	# Write the new value
	echo "$2" > "$1" 2> /dev/null

	# Bail out if ctl fails
	if [[ $? -ne 0 ]]
	then
		err "Failed to ctl $2 to $1.Skipping."
		return 1
	fi

	kmsg "$1: $curval => $2"
}

# Background fork ctl function
ctl() {
	_ctl $@
}

sync

# Print device information prior to execution
kmsg2 $(date)
kmsg2 "Aggressive Profile"
kmsg2 "v11.0"
kmsg2 "----"

# Killall to save battery
killall -9 com.google.android.gms

kmsg "Killed gms idle server"
kmsg "----"

# GMS Doze
cmd appops set com.google.android.gms BOOT_COMPLETED allow
cmd appops set com.google.android.ims BOOT_COMPLETED sllow
cmd appops set com.google.android.gsf WAKE_LOCK allow
cmd appops set com.google.android.gms AUTO_START allow
cmd appops set com.google.android.ims AUTO_START allow
cmd appops set com.google.android.ims WAKE_LOCK allow

$pme 'com.google.android.gms/com.google.android.gms.mdm.receivers.MdmDeviceAdminReceiver'   | tee -a $LOG2A
$pme 'com.google.android.gms/com.google.android.gms.auth.managed.admin.DeviceAdminReceiver'   | tee -a $LOG2A
$pme 'com.google.android.gms/com.google.android.gms.auth.setup.devicesignals.LockScreenService'   | tee -a $LOG2A
$pme 'com.google.android.gms/com.google.android.gms.mdm.receivers.MdmDeviceAdminReceiver'   | tee -a $LOG2A

kmsg2 $(date) 
kmsg2 "Universal GMS Doze disabled"
kmsg2 "----"

# Some stuffs to be enabled
kmsg2 $(date) 
kmsg2 "Starting Enabling stuffs that are"
kmsg2 "disabled by other profile/mod if any..."

List1="com.google.android.gms/.update.SystemUpdateService com.google.android.gms/com.google.android.gms.analytics.service.AnalyticsService com.google.android.gms/com.google.android.gms.analytics.AnalyticsService com.google.android.gms/com.google.android.gms.analytics.AnalyticsTaskService com.google.android.gms/com.google.android.gms.measurement.AppMeasurementJobService com.google.android.syncadapters.contacts/com.google.android.gms.analytics.AnalyticsJobService com.google.android.syncadapters.contacts/com.google.android.gms.analytics.AnalyticsService com.google.android.gms/com.google.android.gms.gcm.HeartbeatAlarm$ConnectionInfoPersistService com.google.android.gms/com.google.android.gms.chimera.PersistentIntentOperationService com.google.android.gsf/.update.SystemUpdateService com.android.vending/com.google.android.gms.measurement.AppMeasurementReceiver com.android.vending/com.google.firebase.iid.FirebaseInstanceIdInternalReceiver  com.android.vending/com.google.firebase.iid.FirebaseInstanceIdReceiver com.google.android.gms/.update.SystemUpdateActivity com.google.android.gms/.update.SystemUpdateService$ActiveReceiver com.google.android.gms/.update.SystemUpdateService$Receiver com.google.android.gms/.update.SystemUpdateService$SecretCodeReceiver com.google.android.gms/com.google.android.gms.analytics.AnalyticsReceiver com.google.android.gms/com.google.android.gms.gcm.nts.SchedulerInternalReceiver com.google.android.gms/com.google.android.gms.gcm.nts.SchedulerReceiver com.google.android.gms/com.google.android.gms.measurement.AppMeasurementInstallReferrerReceiver com.google.android.gms/com.google.android.gms.measurement.AppMeasurementReceiver com.google.android.gms/com.google.android.gms.measurement.AppMeasurementService com.google.android.gms/com.google.android.gms.measurement.PackageMeasurementReceiver com.google.android.gms/com.google.android.gms.measurement.PackageMeasurementService com.google.android.gms/com.google.android.gms.measurement.service.MeasurementBrokerService com.google.android.gms/com.google.android.location.internal.AnalyticsSamplerReceiver com.google.android.gsf/.update.SystemUpdateActivity com.google.android.gsf/.update.SystemUpdatePanoActivity com.google.android.gsf/.update.SystemUpdateService$Receiver com.google.android.gsf/.update.SystemUpdateService$SecretCodeReceiver com.google.android.gms/com.google.android.gms.analytics.service.AnalyticsService com.google.android.gms/com.google.android.gms.analytics.AnalyticsService com.google.android.gms/com.google.android.gms.analytics.AnalyticsTaskService com.google.android.gms/com.google.android.gms.measurement.AppMeasurementJobService com.google.android.syncadapters.contacts/com.google.android.gms.analytics.AnalyticsJobService com.google.android.syncadapters.contacts/com.google.android.gms.analytics.AnalyticsService com.google.android.gms/com.google.android.gms.gcm.HeartbeatAlarm$ConnectionInfoPersistService com.google.android.gms/com.google.android.gms.chimera.PersistentIntentOperationService com.google.android.gms/com.google.android.gms.mdm.receivers.MdmDeviceAdminReceiver disable com.google.android.gms/com.google.android.gms.auth.managed.admin.DeviceAdminReceiver com.google.android.gms/com.google.android.gms.auth.setup.devicesignals.LockScreenService";
List2="com.crashlytics.android.CrashlyticsInitProvider com.google.android.gms.analytics.AnalyticsService com.google.android.gms.analytics.AnalyticsReceiver com.google.android.gms.analytics.AnalyticsJobService com.google.android.gms.analytics.CampaignTrackingService com.google.android.gms.measurement.AppMeasurementService com.google.android.gms.analytics.CampaignTrackingReceiver com.google.android.gms.measurement.AppMeasurementReceiver com.google.android.gms.measurement.AppMeasurementJobService com.google.android.gms.measurement.AppMeasurementContentProvider com.google.android.gms.measurement.AppMeasurementInstallReferrerReceiver com.google.android.gms.ads.AdActivity";
for list in $List1; do
$pme $list
done
for list in $List12; do
$pme $list 
done

AppList=/data/mkadp/mkadp_app.list
TempList=/data/temp.list
tmp1=/data/temp1.list
tmp2=/data/temp2.list
log=/data/media/0/Android/.libbin/mkadplogs/altcs.log
dlog=data/media/0/Android/.libbin/mkadplogs/altcs_detailed.log

if [ -f $AppList ]; then
Apps="`cat $AppList`"
for app in $Apps; do
	for list in $List2; do
		$pme $app/$list
	done
done
rm -f $AppList
rm -f $TempList
rm -f $tmp1
rm -f $tmp2
rm -f $log
rm -f $dlog
fi

kmsg2 $(date) 
kmsg2 "Enabled"
kmsg2 "----"

kmsg $(date) 
kmsg "Kernel and CPU Level Tweaks Started"
kmsg "----"

kmsg2 $(date) 
kmsg2 "Applying Kernel and CPU Level Tweaks"
kmsg2 "----"

am start -a android.intent.action.MAIN -e toasttext "Starting applying of Kernel/CPU/GPU Level Tweaks" -n mkadp.toast/.MainActivity

# Other CPU tweaks
#ctl /dev/cpuctl/cpu.shares 1024


# Force switch off some headache created by kernel logging in case kernel have it enabled;
ctl /proc/sys/debug/exception-trace 0

# Optimized tweaks & enhancements for a improved userspace experience;
ctl /proc/sys/fs/dir-notify-enable 0
ctl /proc/sys/fs/lease-break-time 20

# Entropy tweaks for a slight UI responsivness boost;
ctl /proc/sys/kernel/random/urandom_min_reseed_secs 90

# kernel tweaks to remove wasted CPU cycles kind of headache for kernel
ctl /proc/sys/kernel/panic 0
ctl /proc/sys/kernel/panic_on_oops 0
ctl /proc/sys/kernel/sched_tunable_scaling 0

# disable kernel printk console
ctl /proc/sys/kernel/printk "0 0 0 0"

# Increase how much CPU bandwidth (CPU time) realtime to lightly improved system stability and minimized chance of system freezes & lockups;
ctl /proc/sys/kernel/sched_rt_runtime_us 955000

# Network tweaks to reduced battery consumption when being "actively" connected to a network;
#ctl /proc/sys/net/core/netdev_max_backlog 128
#ctl /proc/sys/net/core/netdev_tstamp_prequeue 0
#ctl /proc/sys/net/ipv4/ipfrag_time 24
#ctl /proc/sys/net/ipv4/tcp_congestion_control westwood
#ctl /proc/sys/net/ipv4/tcp_ecn 1
#ctl /proc/sys/net/ipv4/tcp_fastopen 3
#ctl /proc/sys/net/ipv4/tcp_sack 1
#ctl /proc/sys/net/ipv4/tcp_fack 1
#ctl /proc/sys/net/ipv4/tcp_tw_reuse 1
#ctl /proc/sys/net/ipv4/tcp_dsack 1
#ctl /proc/sys/net/ipv4/tcp_fwmark_accept 0
#ctl /proc/sys/net/ipv4/tcp_keepalive_intvl 320
#ctl /proc/sys/net/ipv4/tcp_keepalive_time 21600
#ctl /proc/sys/net/ipv4/tcp_no_metrics_save 1
#ctl /proc/sys/net/ipv4/tcp_slow_start_after_idle 0
#ctl /proc/sys/net/ipv6/ip6frag_time 48
#
ctl /proc/sys/net/ipv4/tcp_keepalive_probes 5
ctl /proc/sys/net/ipv4/tcp_fin_timeout 30
ctl /proc/sys/net/ipv4/tcp_moderate_rcvbuf 1
ctl /proc/sys/net/ipv4/udp_rmem_min 6144
ctl /proc/sys/net/ipv4/udp_wmem_min 6144
ctl /proc/sys/net/ipv4/tcp_rfc1337 1
ctl /proc/sys/net/ipv4/ip_no_pmtu_disc 0
ctl /proc/sys/net/ipv4/tcp_ecn 0
ctl /proc/sys/net/ipv4/tcp_wmem "6144 87380 2097152"
ctl /proc/sys/net/ipv4/tcp_rmem "6144 87380 2097152"
ctl /proc/sys/net/ipv4/tcp_synack_retries 2
ctl /proc/sys/net/ipv4/tcp_syn_retries 2
ctl /proc/sys/net/ipv4/ip_forward 0
ctl /proc/sys/net/ipv4/tcp_window_scaling 1
ctl /proc/sys/net/ipv4/conf/default/accept_source_route 0
ctl /proc/sys/net/ipv4/conf/all/accept_source_route 0
ctl /proc/sys/net/ipv4/conf/all/accept_redirects 0
ctl /proc/sys/net/ipv4/conf/default/accept_redirects 0
ctl /proc/sys/net/ipv4/conf/all/secure_redirects 0
ctl /proc/sys/net/ipv4/conf/default/secure_redirects 0
ctl /proc/sys/net/ipv4/tcp_tw_recycle 1
ctl /proc/sys/net/ipv4/ip_dynaddr 0
ctl /proc/sys/net/ipv4/tcp_timestamps 0
ctl /proc/sys/net/ipv4/tcp_max_tw_buckets 1440000
ctl /proc/sys/net/ipv4/tcp_mem "57344 57344 524288"
ctl /proc/sys/net/ipv4/tcp_max_tw_buckets 1440000
ctl /proc/sys/net/core/rmem_max 2097152
ctl /proc/sys/net/core/wmem_max 2097152
ctl /proc/sys/net/core/rmem_default 262144
ctl /proc/sys/net/core/wmem_default 262144
ctl /proc/sys/net/core/optmem_max 20480
ctl /proc/sys/net/core/netdev_max_backlog 2500
ctl /proc/sys/net/unix/max_dgram_qlen 50

# VMemory tweaks big improved balance between performance and battery life;
ctl /proc/sys/vm/drop_caches 1
ctl /proc/sys/vm/dirty_background_ratio 11
ctl /proc/sys/vm/dirty_expire_centisecs 400
ctl /proc/sys/vm/page-cluster 0
ctl /proc/sys/vm/dirty_ratio 20
ctl /proc/sys/vm/laptop_mode 0
ctl /proc/sys/vm/block_dump 0
ctl /proc/sys/vm/compact_memory 1
ctl /proc/sys/vm/dirty_writeback_centisecs 3000
ctl /proc/sys/vm/oom_dump_tasks 0
ctl /proc/sys/vm/oom_kill_allocating_task 0
ctl /proc/sys/vm/stat_interval 1103
ctl /proc/sys/vm/panic_on_oom 0
ctl /proc/sys/vm/swappiness 30
ctl /proc/sys/vm/vfs_cache_pressure 94
ctl /proc/sys/vm/overcommit_ratio 50
ctl /proc/sys/vm/extra_free_kbytes 24300
ctl /proc/sys/kernel/random/read_wakeup_threshold 64
ctl /proc/sys/kernel/random/write_wakeup_threshold 2200
ctl /sys/module/lowmemorykiller/parameters/minfree "6400,7680,11520,25600,35840,38400"
ctl /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk 0

ctl /sys/module/lowmemorykiller/parameters/oom_reaper 1

ctl /d/tracing/tracing_on 0
ctl /sys/module/rmnet_data/parameters/rmnet_data_log_level 0

ctl /sys/kernel/debug/kgsl/kgsl-3d0/log_level_cmd 0
ctl /sys/kernel/debug/kgsl/kgsl-3d0/log_level_ctxt 0
ctl /sys/kernel/debug/kgsl/kgsl-3d0/log_level_drv 0
ctl /sys/kernel/debug/kgsl/kgsl-3d0/log_level_mem 0
ctl /sys/kernel/debug/kgsl/kgsl-3d0/log_level_pwr 0

# Turn off a few kernel debuggers for slight boost in both performance and battery life;
ctl /sys/module/bluetooth/parameters/disable_ertm Y
ctl /sys/module/bluetooth/parameters/disable_esco Y
ctl /sys/module/dwc3/parameters/ep_addr_rxdbg_mask 0
ctl /sys/module/dwc3/parameters/ep_addr_txdbg_mask 0
ctl /sys/module/dwc3_msm/parameters/disable_host_mode 0
ctl /sys/module/hid_apple/parameters/fnmode 0
ctl /sys/module/hid/parameters/ignore_special_drivers 0
ctl /sys/module/hid_magicmouse/parameters/emulate_3button N
ctl /sys/module/hid_magicmouse/parameters/emulate_scroll_wheeL N
ctl /sys/module/hid_magicmouse/parameters/scroll_speed 0
ctl /sys/module/mdss_fb/parameters/backlight_dimmer Y
ctl /sys/module/workqueue/parameters/power_efficient Y
ctl /sys/module/sync/parameters/fsync_enabled N
ctl /sys/module/binder/parameters/debug_mask 0
ctl /sys/module/debug/parameters/enable_event_log 0
ctl /sys/module/glink/parameters/debug_mask 0
ctl /sys/module/ip6_tunnel/parameters/log_ecn_error N
ctl /sys/module/subsystem_restart/parameters/enable_ramdumps 0
ctl /sys/module/lowmemorykiller/parameters/debug_level 0
ctl /sys/module/logger/parameters/log_mode 2
ctl /sys/module/msm_show_resume_irq/parameters/debug_mask 0
ctl /sys/module/msm_smd_pkt/parameters/debug_mask 0
ctl /sys/module/sit/parameters/log_ecn_error N
ctl /sys/module/smp2p/parameters/debug_mask 0
ctl /sys/module/usb_bam/parameters/enable_event_log 0
ctl /sys/module/printk/parameters/console_suspend Y
ctl /sys/module/printk/parameters/cpu N
ctl /sys/module/printk/parameters/ignore_loglevel N
ctl /sys/module/printk/parameters/pid N
ctl /sys/module/printk/parameters/time N
ctl /sys/module/service_locator/parameters/enable 0
ctl /sys/module/subsystem_restart/parameters/disable_restart_work 1


for i in $(find /sys/ -name debug_mask); do
ctl $i 0
done
for i in $(find /sys/ -name debug_level); do
ctl $i 0
done
for i in $(find /sys/ -name edac_mc_log_ce); do
ctl $i 0
done
for i in $(find /sys/ -name edac_mc_log_ue); do
ctl $i 0
done
for i in $(find /sys/ -name enable_event_log); do
ctl $i 0
done
for i in $(find /sys/ -name log_ecn_error); do
ctl $i 0
done
for i in $(find /sys/ -name snapshot_crashdumper); do
ctl $i 0
done

# Some Misc
for i in /sys/devices/virtual/block/*/queue/iosched; do
  ctl $i/group_idle 1
done

for i in /sys/devices/virtual/block/*/queue/iosched; do
 ctl $i/low_latency 0
done

for g in /sys/block/*/queue;
do
ctl "${g}"/add_random 0
ctl "${g}"/iostats 0
ctl "${g}"/nomerges 2
ctl "${g}"/rotational 0
ctl "${g}"/rq_affinity 2
ctl "${g}"/iosched/slice_idle 0
ctl "${g}"/iosched/low_latency 0
ctl "${g}"/scheduler cfq
ctl "${g}"/read_ahead_kb 256
ctl "${g}"/nr_requests 8192
done

#am start -a android.intent.action.MAIN -e toasttext "Applying Mount-Related Tweaks..." -n mkadp.toast/.MainActivity
# Remount all partitions with noatime
#for mkk in $($BB mount | grep relatime | cut -d " " -f3);
#do
#$BB mount -o remount,noatime $mkk;
#done

for iosched in /sys/block/*/queue/iosched
do
    ctl "$iosched"/slide_idle 0
    ctl "$iosched"/group_idle 1
done

# Dev Stune Boost
# Fast Sensivity in Game
ctl /dev/stune/background/schedtune.boost 15
ctl /dev/stune/foreground/schedtune.boost 15
ctl /dev/stune/rt/schedtune.boost 1
ctl /dev/stune/top-app/schedtune.boost 25
ctl /dev/stune/schedtune.boost 100
ctl /dev/stune/nnapi-hal/schedtune.boost 1
ctl /dev/stune/nnapi-hal/schedtune.prefer_idle 0
ctl /dev/stune/top-app/schedtune.prefer_idle 0
ctl /dev/stune/background/schedtune.prefer_idle 0
ctl /dev/stune/foreground/schedtune.prefer_idle 0
ctl /dev/stune/rt/schedtune.prefer_idle 0
ctl /dev/stune/schedtune.prefer_idle 0

# Fs
ctl /proc/sys/fs/lease-break-time 5
ctl /proc/sys/kernel/perf_cpu_time_max_percent 15
ctl /proc/sys/kernel/sched_min_task_util_for_colocation 0
ctl /proc/sys/kernel/sched_min_task_util_for_boost 0
ctl /proc/sys/kernel/sched_child_runs_first 0
ctl /proc/sys/kernel/sched_boost_top_app 1
ctl /proc/sys/kernel/sched_walt_rotate_big_tasks 1
ctl /proc/sys/kernel/sched_boost 1

# Boost Control Tweak
# Credits to @Ratoriku
ctl /sys/module/boost_control/parameters/app_launch_boost_ms 3000

# GPU frequency based throttling;
ctl /sys/class/kgsl/kgsl-3d0/throttling 0
ctl /sys/class/kgsl/kgsl-3d0/default_pwrlevel 0
ctl /sys/class/kgsl/kgsl-3d0/bus_split 0

#1028 readahead KB
ctl /sys/block/sde/queue/read_ahead_kb 128
ctl /sys/block/sdf/queue/read_ahead_kb 128

# For Idle battery Life
ctl /sys/class/misc/boeffla_wakelock_blocker/wakelock_blocker "qcom_rx_wakelock;wlan;wlan_wow_wl;wlan_extscan_wl;netmgr_wl;NETLINK;IPA_WS;[timerfd];wlan_ipa;wlan_pno_wl;wcnss_filter_lock;IPCRTR_lpass_rx;hal_bluetooth_lock"

# For Net Speed
for i in $(find /sys/class/net -type l); do
  ctl $i/tx_queue_len 128
done
ctl /sys/module/tcp_cubic/parameters/hystart_detect 2

# Misc Kernel Teaks
ctl /sys/kernel/debug/sched_features NEXT_BUDDY
ctl /sys/kernel/debug/sched_features GENTLE_FAIR_SLEEPERS
ctl /sys/kernel/debug/sched_features TTWU_QUEUE
ctl /sys/kernel/debug/sched_features RT_RUNTIME_SHARE
ctl /sys/kernel/debug/sched_features AFFINE_WAKEUPS

for cpu in /sys/devices/system/cpu/*/sched_load_boost
do
    ctl "$cpu" 1
done

for boost in /sys/devices/system/*/cpu_boost
do
    ctl "$boost"/sched_boost_on_input 1
    ctl "$boost"/sched_boost_on_powerkey_input 1
    ctl "$boost"/input_boost_ms 2000
    ctl "$boost"/powerkey_input_boost_ms 500
done

chmod -h 644 /sys/module/lowmemorykiller/parameters/cost
ctl /sys/module/lowmemorykiller/parameters/cost 16
chmod -h 644 /sys/module/lowmemorykiller/parameters/adj
ctl /sys/module/lowmemorykiller/parameters/adj "0,1,2,4,7,15"

ctl /sys/power/pm_freeze_timeout 25000

# DS

for i in `ls /sys/class/scsi_disk/`; do
  cat /sys/class/scsi_disk/$i/write_protect 2>/dev/null | grep 1 >/dev/null
  if [ $? -eq 0 ]; then
    ctl /sys/class/scsi_disk/$i/cache_type 'temporary none'
  fi
done

# Disabling Debug ( Reduces the Power Usage )
# All Credits to @Bug_Founder_S10_S8 ( Nuked Dev )

for debug in /sys/kernel/debug/tracing/events/*/enable
do
    ctl "$debug" 0
done
for tracing in /sys/kernel/tracing/events/*/enable
do
    ctl "$tracing" 0
done

ctl /sys/wifi/logtrace 0
ctl /sys/wifi/control_logtrace 0
ctl /sys/wifi/logdump_ecntr_enable 0
ctl /sys/power/pm_debug_messages 0
ctl /sys/kernel/debug/debug_enabled N
ctl /sys/kernel/debug/seclog/seclog_debug N
ctl /sys/kernel/debug/tracing/tracing_on 0
ctl /proc/sys/debug/exception-trace 0
ctl /d/tracing/tracing_on 0
ctl /sys/kernel/debug/sched_debug N
ctl /proc/sys/dev/scsi/logging_level 0
ctl /sys/kernel/tracing/options/trace_printk 0
ctl /sys/module/printk/parameters/console_suspend Y
ctl /sys/module/printk/parameters/ignore_loglevel Y
ctl /sys/module/printk/parameters/time N
ctl /proc/sys/kernel/printk 0 0 0 0
ctl /proc/sys/kernel/printk_devkmsg off

for i in ` find /sys/module -name debug_mask`; do  
	ctl $i 0
done

# Adjust a few display props for improved performance as well as overall reduced stuttering and power consumption;
ctl /sys/kernel/debug/mdss_panel_fb0/intf0/mipi/hw_vsync_mode 0
ctl /sys/kernel/debug/mdss_panel_fb0/intf0/mipi/vsync_enable 0
ctl /sys/kernel/debug/mdss_panel_fb0/intf0/bl_max 175
ctl /sys/kernel/debug/mdss_panel_fb0/intf0/brightness_max 175
ctl /sys/kernel/debug/mdss_panel_fb0/intf0/panel_ack_disabled Y
ctl /sys/kernel/debug/mdss_panel_fb0/intf0/partial_update_enabled 1

# Kernel tweaks for overall improved performance;
ctl /proc/sys/kernel/compat-log 0

# Set this as low as possible for performance;
for i in /sys/block/sd*/queue/iosched; do
  ctl $i/back_seek_penalty 1
done;

# Flexibility started from 102+

ctl /proc/sys/fs/dir-notify-enable 0
ctl /proc/sys/fs/lease-break-time 15
ctl /proc/sys/fs/leases-enable 1
ctl /proc/sys/fs/file-max 2097152
ctl /proc/sys/fs/inotify/max_queued_events 131072
ctl /proc/sys/fs/inotify/max_user_watches 131072
ctl /proc/sys/fs/inotify/max_user_instances 1024

#AGG2

# Force all CPUs
ctl /proc/sys/kernel/sched_boost 1
ctl /sys/module/cpu_boost/parameters/input_boost_freq "0:1286400 2:1286400"
ctl /sys/module/cpu_boost/parameters/input_boost_ms 500
ctl /sys/module/cpu_boost/parameters/input_boost_enabled 1
ctl /sys/class/kgsl/kgsl-3d0/default_pwrlevel 6
ctl /sys/class/kgsl/kgsl-3d0/devfreq/governor msm-adreno-tz
ctl /sys/class/kgsl/kgsl-3d0/devfreq/adrenoboost 0
ctl /sys/block/dm-0/queue/scheduler "cfq"
ctl /sys/block/dm-1/queue/scheduler "cfq"
ctl /sys/block/sda/queue/scheduler "cfq"
ctl /sys/block/sde/queue/scheduler "cfq"
ctl /sys/block/dm-0/queue/read_ahead_kb 128
ctl /sys/block/dm-1/queue/read_ahead_kb 128
ctl /sys/block/sda/queue/read_ahead_kb 128
ctl /sys/block/sde/queue/read_ahead_kb 128

ctl /sys/devices/system/cpu/cpu0/online 1
ctl /sys/devices/system/cpu/cpu1/online 1
ctl /sys/devices/system/cpu/cpu2/online 1
ctl /sys/devices/system/cpu/cpu3/online 1
ctl /sys/devices/system/cpu/cpu4/online 1
ctl /sys/devices/system/cpu/cpu5/online 1
ctl /sys/devices/system/cpu/cpu6/online 1
ctl /sys/devices/system/cpu/cpu7/online 1

ctl /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor schedutil
ctl /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor schedutil
ctl /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor schedutil
ctl /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor schedutil
ctl /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor schedutil
ctl /sys/devices/system/cpu/cpu5/cpufreq/scaling_governor schedutil
ctl /sys/devices/system/cpu/cpu6/cpufreq/scaling_governor schedutil
ctl /sys/devices/system/cpu/cpu7/cpufreq/scaling_governor schedutil
ctl /sys/devices/system/cpu/cpufreq/policy0/scaling_governor schedutil
ctl /sys/devices/system/cpu/cpufreq/policy4/scaling_governor schedutil
ctl /sys/devices/system/cpu/cpufreq/policy7/scaling_governor schedutil

ctl /sys/kernel/gpu/gpu_governor performance
ctl /sys/module/adreno_idler/parameters/adreno_idler_active 1
ctl /sys/module/lazyplug/parameters/nr_possible_cores 8
ctl /sys/module/msm_performance/parameters/touchboost 0
ctl /dev/cpuset/foreground/boost/cpus 4-6
ctl /dev/cpuset/foreground/cpus 0-7
ctl /dev/cpuset/top-app/cpus 0-6
DEVICE="$(getprop vendor.product.device)"
if [[ "$DEVICE" == guacamole ]]; then
	am start -a android.intent.action.MAIN -e toasttext "Device detected OP7Pro" -n mkadp.toast/.MainActivity
	ctl /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq 1780000
	ctl /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq 1250000
	ctl /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq 1780000
	ctl /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq 1250000
	ctl /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq 1780000
	ctl /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq 1250000
	ctl /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq 1780000
	ctl /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq 1250000
	ctl /sys/devices/system/cpu/cpufreq/policy0/scaling_max_freq 1780000
	ctl /sys/devices/system/cpu/cpufreq/policy0/scaling_min_freq 1250000
	ctl /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq 2420000
	ctl /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq 1920000
	ctl /sys/devices/system/cpu/cpu5/cpufreq/scaling_max_freq 2420000
	ctl /sys/devices/system/cpu/cpu5/cpufreq/scaling_min_freq 1920000
	ctl /sys/devices/system/cpu/cpu6/cpufreq/scaling_max_freq 2420000
	ctl /sys/devices/system/cpu/cpu6/cpufreq/scaling_min_freq 1920000
	ctl /sys/devices/system/cpu/cpufreq/policy4/scaling_max_freq 2420000
	ctl /sys/devices/system/cpu/cpufreq/policy4/scaling_min_freq 1920000
	ctl /sys/devices/system/cpu/cpu7/cpufreq/scaling_max_freq 2740000
	ctl /sys/devices/system/cpu/cpu7/cpufreq/scaling_min_freq 2340000
	ctl /sys/devices/system/cpu/cpufreq/policy7/scaling_max_freq 2740000
	ctl /sys/devices/system/cpu/cpufreq/policy7/scaling_min_freq 2340000
if

if [[ "$DEVICE" == guacamoleb ]]; then
	am start -a android.intent.action.MAIN -e toasttext "Device detected OP7" -n mkadp.toast/.MainActivity
	ctl /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq 1780000
	ctl /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq 1250000
	ctl /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq 1780000
	ctl /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq 1250000
	ctl /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq 1780000
	ctl /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq 1250000
	ctl /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq 1780000
	ctl /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq 1250000
	ctl /sys/devices/system/cpu/cpufreq/policy0/scaling_max_freq 1780000
	ctl /sys/devices/system/cpu/cpufreq/policy0/scaling_min_freq 1250000
	ctl /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq 2420000
	ctl /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq 1920000
	ctl /sys/devices/system/cpu/cpu5/cpufreq/scaling_max_freq 2420000
	ctl /sys/devices/system/cpu/cpu5/cpufreq/scaling_min_freq 1920000
	ctl /sys/devices/system/cpu/cpu6/cpufreq/scaling_max_freq 2420000
	ctl /sys/devices/system/cpu/cpu6/cpufreq/scaling_min_freq 1920000
	ctl /sys/devices/system/cpu/cpufreq/policy4/scaling_max_freq 2420000
	ctl /sys/devices/system/cpu/cpufreq/policy4/scaling_min_freq 1920000
	ctl /sys/devices/system/cpu/cpu7/cpufreq/scaling_max_freq 2740000
	ctl /sys/devices/system/cpu/cpu7/cpufreq/scaling_min_freq 2340000
	ctl /sys/devices/system/cpu/cpufreq/policy7/scaling_max_freq 2740000
	ctl /sys/devices/system/cpu/cpufreq/policy7/scaling_min_freq 2340000
if

if [[ "$DEVICE" == hotdog ]]; then
	am start -a android.intent.action.MAIN -e toasttext "Device detected OP7TPro" -n mkadp.toast/.MainActivity
	ctl /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq 1780000
	ctl /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq 1250000
	ctl /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq 1780000
	ctl /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq 1250000
	ctl /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq 1780000
	ctl /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq 1250000
	ctl /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq 1780000
	ctl /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq 1250000
	ctl /sys/devices/system/cpu/cpufreq/policy0/scaling_max_freq 1780000
	ctl /sys/devices/system/cpu/cpufreq/policy0/scaling_min_freq 1250000
	ctl /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq 2420000
	ctl /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq 1920000
	ctl /sys/devices/system/cpu/cpu5/cpufreq/scaling_max_freq 2420000
	ctl /sys/devices/system/cpu/cpu5/cpufreq/scaling_min_freq 1920000
	ctl /sys/devices/system/cpu/cpu6/cpufreq/scaling_max_freq 2420000
	ctl /sys/devices/system/cpu/cpu6/cpufreq/scaling_min_freq 1920000
	ctl /sys/devices/system/cpu/cpufreq/policy4/scaling_max_freq 2420000
	ctl /sys/devices/system/cpu/cpufreq/policy4/scaling_min_freq 1920000
	ctl /sys/devices/system/cpu/cpu7/cpufreq/scaling_max_freq 2860000
	ctl /sys/devices/system/cpu/cpu7/cpufreq/scaling_min_freq 2340000
	ctl /sys/devices/system/cpu/cpufreq/policy7/scaling_max_freq 2860000
	ctl /sys/devices/system/cpu/cpufreq/policy7/scaling_min_freq 2440000
if

if [[ "$DEVICE" == hotdogg ]]; then
	am start -a android.intent.action.MAIN -e toasttext "Device detected OP7TMcLPro" -n mkadp.toast/.MainActivity
	ctl /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq 1780000
	ctl /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq 1250000
	ctl /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq 1780000
	ctl /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq 1250000
	ctl /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq 1780000
	ctl /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq 1250000
	ctl /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq 1780000
	ctl /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq 1250000
	ctl /sys/devices/system/cpu/cpufreq/policy0/scaling_max_freq 1780000
	ctl /sys/devices/system/cpu/cpufreq/policy0/scaling_min_freq 1250000
	ctl /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq 2420000
	ctl /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq 1920000
	ctl /sys/devices/system/cpu/cpu5/cpufreq/scaling_max_freq 2420000
	ctl /sys/devices/system/cpu/cpu5/cpufreq/scaling_min_freq 1920000
	ctl /sys/devices/system/cpu/cpu6/cpufreq/scaling_max_freq 2420000
	ctl /sys/devices/system/cpu/cpu6/cpufreq/scaling_min_freq 1920000
	ctl /sys/devices/system/cpu/cpufreq/policy4/scaling_max_freq 2420000
	ctl /sys/devices/system/cpu/cpufreq/policy4/scaling_min_freq 1920000
	ctl /sys/devices/system/cpu/cpu7/cpufreq/scaling_max_freq 2860000
	ctl /sys/devices/system/cpu/cpu7/cpufreq/scaling_min_freq 2340000
	ctl /sys/devices/system/cpu/cpufreq/policy7/scaling_max_freq 2860000
	ctl /sys/devices/system/cpu/cpufreq/policy7/scaling_min_freq 2440000
if

if [[ "$DEVICE" == hotdogb ]]; then
	am start -a android.intent.action.MAIN -e toasttext "Device detected OP7T" -n mkadp.toast/.MainActivity
	ctl /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq 1780000
	ctl /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq 1250000
	ctl /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq 1780000
	ctl /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq 1250000
	ctl /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq 1780000
	ctl /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq 1250000
	ctl /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq 1780000
	ctl /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq 1250000
	ctl /sys/devices/system/cpu/cpufreq/policy0/scaling_max_freq 1780000
	ctl /sys/devices/system/cpu/cpufreq/policy0/scaling_min_freq 1250000
	ctl /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq 2420000
	ctl /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq 1920000
	ctl /sys/devices/system/cpu/cpu5/cpufreq/scaling_max_freq 2420000
	ctl /sys/devices/system/cpu/cpu5/cpufreq/scaling_min_freq 1920000
	ctl /sys/devices/system/cpu/cpu6/cpufreq/scaling_max_freq 2420000
	ctl /sys/devices/system/cpu/cpu6/cpufreq/scaling_min_freq 1920000
	ctl /sys/devices/system/cpu/cpufreq/policy4/scaling_max_freq 2420000
	ctl /sys/devices/system/cpu/cpufreq/policy4/scaling_min_freq 1920000
	ctl /sys/devices/system/cpu/cpu7/cpufreq/scaling_max_freq 2860000
	ctl /sys/devices/system/cpu/cpu7/cpufreq/scaling_min_freq 2340000
	ctl /sys/devices/system/cpu/cpufreq/policy7/scaling_max_freq 2860000
	ctl /sys/devices/system/cpu/cpufreq/policy7/scaling_min_freq 2440000
if

ctl /sys/devices/system/cpu/cpu0/core_ctl/busy_down_thres 40
ctl /sys/devices/system/cpu/cpu0/core_ctl/busy_up_thres 10
ctl /sys/devices/system/cpu/cpu4/core_ctl/busy_down_thres 40
ctl /sys/devices/system/cpu/cpu4/core_ctl/busy_up_thres 10
ctl /sys/devices/system/cpu/cpu7/core_ctl/busy_down_thres 0
ctl /sys/devices/system/cpu/cpu7/core_ctl/busy_up_thres 0

ctl /sys/devices/system/cpu/cpu0/core_ctl/max_cpus 4
ctl /sys/devices/system/cpu/cpu0/core_ctl/min_cpus 2
ctl /sys/devices/system/cpu/cpu4/core_ctl/max_cpus 3
ctl /sys/devices/system/cpu/cpu4/core_ctl/min_cpus 1
ctl /sys/devices/system/cpu/cpu7/core_ctl/max_cpus 1
ctl /sys/devices/system/cpu/cpu7/core_ctl/min_cpus 1

# Fequency tweaks to all CPUs
ctl /sys/devices/system/cpu/cpu0/cpufreq/schedutil/down_rate_limit_us 75000
ctl /sys/devices/system/cpu/cpu0/cpufreq/schedutil/up_rate_limit_us 0
ctl /sys/devices/system/cpu/cpu0/cpufreq/schedutil/pl 0

ctl /sys/devices/system/cpu/cpu4/cpufreq/schedutil/down_rate_limit_us 75000
ctl /sys/devices/system/cpu/cpu4/cpufreq/schedutil/up_rate_limit_us 0
ctl /sys/devices/system/cpu/cpu4/cpufreq/schedutil/pl 0

ctl /sys/devices/system/cpu/cpu7/cpufreq/schedutil/down_rate_limit_us 75000
ctl /sys/devices/system/cpu/cpu7/cpufreq/schedutil/up_rate_limit_us 0
ctl /sys/devices/system/cpu/cpu7/cpufreq/schedutil/pl 0

kmsg2 $(date) 
kmsg2 "Applied..."
kmsg2 "----"

am start -a android.intent.action.MAIN -e toasttext "Finally...Kernel/CPU/GPU Tweaks Applied" -n mkadp.toast/.MainActivity

kmsg $(date) 
kmsg "Enabling/Tweaking ZRAM"
kmsg "----"
kmsg2 $(date) 
kmsg2 "Enabling/Tweaking ZRAM"
kmsg2 "----"
#
#swapoff /dev/zram0 > /dev/null 2>&1
#swapoff /dev/block/zram0 > /dev/null 2>&1
#swapoff /dev/block/vnswap0 > /dev/null 2>&1
#ctl /sys/block/zram0/reset 1
#ctl /sys/block/zram0/disksize 0
#ctl /sys/block/vnswap0/reset 1
#ctl /sys/block/vnswap0/disksize 0
#ctl /sys/block/zram0/max_comp_streams $CPUS
#ctl /sys/block/vnswap0/max_comp_streams $CPUS
#ctl /sys/block/zram0/disksize $SIZE
#ctl /sys/block/vnswap0/max_comp_streams $CPUS
mkswap /dev/zram0 > /dev/null 2>&1
mkswap /dev/block/zram0 > /dev/null 2>&1
mkswap /dev/block/vnswap0 > /dev/null 2>&1
swapon /dev/zram0 > /dev/null 2>&1
swapon /dev/block/zram0 > /dev/null 2>&1
swapon /dev/block/vnswap0 > /dev/null 2>&1
#
kmsg $(date) 
kmsg "ZRAM Tweaked"
kmsg "----"
kmsg2 $(date) 
kmsg2 "ZRAM Tweaked"
kmsg2 "----"
#

kmsg2 $(date) 
kmsg2 "All Done."
kmsg2 "Enjoy Aggressive Mode"
kmsg2 "----"

# Push a semi-needed log to the internal storage with a "report" if the script could be executed or not;
kmsg $(date) 
kmsg "MKADP HAS EXECUTED TASK SUCCESSFULLY. ENJOY!"

$BB rm -rf /cache/*	

 su -lp 2000 -c "cmd notification post -S bigtext -t 'OxyPlus Descrete' 'Tag' 'Aggressive Profile finished applying
 At $(date)'"

am start -n com.mkadp.oxyplusd/.activities.LogsActivity
exit 0
