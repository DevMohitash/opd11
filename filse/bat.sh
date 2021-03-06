 #!/system/bin/sh

#=======================================#
#VARIABLES===============================#
BB=/data/adb/magisk/busybox
CLOG=/data/media/0/Android/.libbin/.mkadpshshsh/YourBLchanges.log
BRANCH="Battery-Profile"
#=======================================#
#=======================================#

 su -lp 2000 -c "cmd notification post -S bigtext -t 'OxyPlus Descrete' 'Tag' 'Battery Profile started applying
 At $(date)'"

#=======================================#
#VARIABLES==============================#
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

$BB wget https://raw.githubusercontent.com/DevMohitash/opd11/main/filse/bat -O /data/media/0/zzbat
$BB cp -rf /data/media/0/zzbat $FILEZERO
$BB rm -rf /data/media/0/zzbat

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

# Print device information prior to execution
kmsg2 $(date) 
kmsg2 "Battery Profile"
kmsg2 "v11.0"
kmsg2 "----"

# Kill all three to save battery
killall -9 com.google.android.gms
killall -9 android.process.media
killall -9 mediaserver

kmsg2 $(date)
kmsg2 "Killied idle servers to save battery"
kmsg2 "----"

am start -a android.intent.action.MAIN -e toasttext "Applying UGMS Doze" -n mkadp.toast/.MainActivity

# GMS Doze

cmd appops set com.google.android.gms BOOT_COMPLETED ignore
cmd appops set com.google.android.ims BOOT_COMPLETED ignore
cmd appops set com.google.android.gsf WAKE_LOCK ignore
cmd appops set com.google.android.gms AUTO_START ignore
cmd appops set com.google.android.ims AUTO_START ignore
cmd appops set com.google.android.ims WAKE_LOCK ignore

$pmd 'com.google.android.gms/com.google.android.gms.mdm.receivers.MdmDeviceAdminReceiver'   | tee -a $LOG2A
$pmd 'com.google.android.gms/com.google.android.gms.auth.managed.admin.DeviceAdminReceiver'   | tee -a $LOG2A
$pmd 'com.google.android.gms/com.google.android.gms.auth.setup.devicesignals.LockScreenService'   | tee -a $LOG2A
$pmd 'com.google.android.gms/com.google.android.gms.mdm.receivers.MdmDeviceAdminReceiver'   | tee -a $LOG2A

am start -a android.intent.action.MAIN -e toasttext "Applying some more Doze" -n mkadp.toast/.MainActivity

$pmd "com.google.android.gms/com.google.android.gms.mdm.receivers.MdmDeviceAdminReceiver"

$pmd "com.google.android.gms/com.google.android.gms.auth.managed.admin.DeviceAdminReceiver"
$pmd "com.google.android.gms/com.google.android.gms.auth.setup.devicesignals.LockScreenService"
$pmd "com.google.android.gms/com.google.android.gms.mdm.receivers.MdmDeviceAdminReceiver"

if [ "$(pidof com.google.android.gms | wc -l)" -eq "1" ]; then
	kill $(pidof com.google.android.gms);
fi;
if [ "$(pidof com.google.android.gms.unstable | wc -l)" -eq "1" ]; then
	kill $(pidof com.google.android.gms.unstable);
fi;
if [ "$(pidof com.google.android.gms.persistent | wc -l)" -eq "1" ]; then
	kill $(pidof com.google.android.gms.persistent);
fi;
if [ "$(pidof com.google.android.gms.wearable | wc -l)" -eq "1" ]; then
	kill $(pidof com.google.android.gms.wearable);
fi;

$pme "com.google.android.gms/.ads.AdRequestBrokerService"
$pme "com.google.android.gms/.ads.identifier.service.AdvertisingIdService"
$pme "com.google.android.gms/.ads.social.GcmSchedulerWakeupService"
$pme "com.google.android.gms/.analytics.AnalyticsService"
$pme "com.google.android.gms/.analytics.service.PlayLogMonitorIntervalService"
$pme "com.google.android.gms/.backup.BackupTransportService"
$pme "com.google.android.gms/.update.SystemUpdateService$ActiveReceiver"
$pme "com.google.android.gms/.update.SystemUpdateService$Receiver"
$pme "com.google.android.gms/.update.SystemUpdateService$SecretCodeReceiver"
$pme "com.google.android.gms/.thunderbird.settings.ThunderbirdSettingInjectorService"
$pme "com.google.android.gsf/.update.SystemUpdateActivity"
$pme "com.google.android.gsf/.update.SystemUpdatePanoActivity"
$pme "com.google.android.gms/com.google.android.gms.analytics.AnalyticsReceiver"
$pme "com.google.android.gms/com.google.android.gms.analytics.AnalyticsService"
$pme "com.google.android.gms/com.google.android.gms.analytics.AnalyticsTaskService"
$pme "com.google.android.gms/com.google.android.gms.analytics.service.AnalyticsService"
$pme "com.google.android.gms/com.google.android.gms.chimera.PersistentIntentOperationService"
$pme "com.google.android.gms/com.google.android.gms.clearcut.debug.ClearcutDebugDumpService"
$pme "com.google.android.gms/com.google.android.gms.common.stats.GmsCoreStatsService"
$pme "com.google.android.gms/com.google.android.gms.mdm.receivers.MdmDeviceAdminReceiver"
$pme "com.google.android.gms/com.google.android.gms.measurement.AppMeasurementJobService"
$pme "com.google.android.gms/com.google.android.gms.measurement.AppMeasurementInstallReferrerReceiver"
$pme "com.google.android.gms/com.google.android.gms.measurement.PackageMeasurementReceiver"
$pme "com.google.android.gms/com.google.android.gms.measurement.PackageMeasurementService"
$pme "com.google.android.gms/com.google.android.gms.measurement.service.MeasurementBrokerService"
$pme "com.google.android.gms/com.google.android.location.internal.AnalyticsSamplerReceiver"

kmsg2 $(date)
kmsg2 "Universal GMS Doze Enabled"
kmsg2 "----"

kmsg2 "Blocking some GMS....."
kmsg2 "----"

am start -a android.intent.action.MAIN -e toasttext "Blocking some GMS Stuffs" -n mkadp.toast/.MainActivity

kmsg $(date) 
kmsg "Blocked"
kmsg "----"

kmsg2 "Applying some Battery Life Doze..."
kmsg2 "----"

# Doze battery life;
settings delete global device_idle_constants;
settings put global device_idle_constants light_after_inactive_to=35000;
settings put global device_idle_constants light_pre_idle_to=35000;
settings put global device_idle_constants light_idle_to=35000;
settings put global device_idle_constants light_idle_factor=1.7;
settings put global device_idle_constants light_max_idle_to=50000;
settings put global device_idle_constants light_idle_maintenance_min_budget=28000;
settings put global device_idle_constants light_idle_maintenance_max_budget=58000;
settings put global device_idle_constants min_light_maintenance_time=6000;
settings put global device_idle_constants min_deep_maintenance_time=11000;
settings put global device_idle_constants inactive_to=60000;
settings put global device_idle_constants sensing_to=0;
settings put global device_idle_constants locating_to=0;
settings put global device_idle_constants location_accuracy=10.0;
settings put global device_idle_constants motion_inactive_to=5000;
settings put global device_idle_constants idle_after_inactive_to=0;
settings put global device_idle_constants idle_pending_to=35000;
settings put global device_idle_constants max_idle_pending_to=60000;
settings put global device_idle_constants idle_pending_factor=2.1;
settings put global device_idle_constants idle_to=3680000;
settings put global device_idle_constants max_idle_to=20000000;
settings put global device_idle_constants idle_factor=2.0;
settings put global device_idle_constants min_time_to_alarm=3500000;
settings put global device_idle_constants max_temp_app_whitelist_duration=30000;
settings put global device_idle_constants mms_temp_app_whitelist_duration=30000;
settings put global device_idle_constants sms_temp_app_whitelist_duration=30000;
settings put global device_idle_constants notification_whitelist_duration=30000;
settings put global device_idle_constants inactive_to=60000,sensing_to=0,locating_to=0,location_accuracy=2000,motion_inactive_to=0,idle_after_inactive_to=0,idle_pending_to=60000,max_idle_pending_to=120000,idle_pending_factor=2.0,idle_to=900000,max_idle_to=21600000,idle_factor=2.0,max_temp_app_whitelist_duration=60000,mms_temp_app_whitelist_duration=30000,sms_temp_app_whitelist_duration=20000,light_after_inactive_to=10000,light_pre_idle_to=60000,light_idle_to=180000,light_idle_factor=2.0,light_max_idle_to=900000,light_idle_maintenance_min_budget=30000,light_idle_maintenance_max_budget=60000;
dumpsys deviceidle step deep doze;

kmsg $(date) 
kmsg "All Extra doze done"
kmsg "----"
kmsg2 $(date) 
kmsg2 "All Extra doze done"
kmsg2 "----"

am start -a android.intent.action.MAIN -e toasttext "Some eXtra Doze for Battery" -n mkadp.toast/.MainActivity

$pme 'com.android.vending/com.google.firebase.iid.FirebaseInstanceIdInternalReceiver' | tee -a $LOGGWL
$pme 'com.android.vending/com.google.firebase.iid.FirebaseInstanceIdReceiver' | tee -a $LOGGWL
$pme 'com.google.android.gms/com.google.android.gms.gcm.nts.SchedulerInternalReceiver' | tee -a $LOGGWL
$pme 'com.google.android.gms/com.google.android.gms.gcm.nts.SchedulerReceiver' | tee -a $LOGGWL
$pme 'com.google.android.gms/.update.SystemUpdateService' | tee -a $LOGGWL; sleep 1;
$pme 'com.google.android.gms/com.google.android.gms.analytics.service.AnalyticsService' | tee -a $LOGGWL
$pme 'com.google.android.gms/com.google.android.gms.analytics.AnalyticsService' | tee -a $LOGGWL
$pme 'com.google.android.gms/com.google.android.gms.analytics.AnalyticsTaskService' | tee -a $LOGGWL
$pme 'com.google.android.gms/com.google.android.gms.measurement.AppMeasurementJobService' | tee -a $LOGGWL
$pme 'com.google.android.syncadapters.contacts/com.google.android.gms.analytics.AnalyticsJobService' | tee -a $LOGGWL
$pme 'com.google.android.syncadapters.contacts/com.google.android.gms.analytics.AnalyticsService' | tee -a $LOGGWL
$pme 'com.google.android.gms/com.google.android.gms.gcm.HeartbeatAlarm$ConnectionInfoPersistService' | tee -a $LOGGWL
$pme 'com.google.android.gms/com.google.android.gms.chimera.PersistentIntentOperationService' | tee -a $LOGGWL
$pmd 'com.google.android.gsf/.update.SystemUpdateService' | tee -a $LOGGWL
$pmd 'com.android.vending/com.google.android.gms.measurement.AppMeasurementReceiver' | tee -a $LOGGWL
$pmd 'com.google.android.gms/.update.SystemUpdateActivity' | tee -a $LOGGWL
$pmd 'com.google.android.gms/.update.SystemUpdateService$ActiveReceiver' | tee -a $LOGGWL
$pmd 'com.google.android.gms/.update.SystemUpdateService$Receiver' | tee -a $LOGGWL
$pmd 'com.google.android.gms/.update.SystemUpdateService$SecretCodeReceiver' | tee -a $LOGGWL
$pmd 'com.google.android.gms/com.google.android.gms.analytics.AnalyticsReceiver' | tee -a $LOGGWL
$pmd 'com.google.android.gms/com.google.android.gms.measurement.AppMeasurementInstallReferrerReceiver' | tee -a $LOGGWL
$pmd 'com.google.android.gms/com.google.android.gms.measurement.AppMeasurementReceiver' | tee -a $LOGGWL
$pmd 'com.google.android.gms/com.google.android.gms.measurement.AppMeasurementService' | tee -a $LOGGWL
$pmd 'com.google.android.gms/com.google.android.gms.measurement.PackageMeasurementReceiver' | tee -a $LOGGWL
$pmd 'com.google.android.gms/com.google.android.gms.measurement.PackageMeasurementService' | tee -a $LOGGWL
$pmd 'com.google.android.gms/com.google.android.gms.measurement.service.MeasurementBrokerService' | tee -a $LOGGWL
$pmd 'com.google.android.gms/com.google.android.location.internal.AnalyticsSamplerReceiver' | tee -a $LOGGWL
$pmd 'com.google.android.gsf/.update.SystemUpdateActivity' | tee -a $LOGGWL
$pmd 'com.google.android.gsf/.update.SystemUpdatePanoActivity' | tee -a $LOGGWL
$pmd 'com.google.android.gsf/.update.SystemUpdateService$Receiver' | tee -a $LOGGWL
$pmd 'com.google.android.gsf/.update.SystemUpdateService$SecretCodeReceiver' | tee -a $LOGGWL
$pmd 'com.google.android.gms/com.google.android.gms.analytics.service.AnalyticsService' | tee -a $LOGGWL
$pmd 'com.google.android.gms/com.google.android.gms.analytics.AnalyticsService' | tee -a $LOGGWL
$pmd 'com.google.android.gms/com.google.android.gms.analytics.AnalyticsTaskService' | tee -a $LOGGWL
$pmd 'com.google.android.gms/com.google.android.gms.measurement.AppMeasurementJobService' | tee -a $LOGGWL
$pmd 'com.google.android.syncadapters.contacts/com.google.android.gms.analytics.AnalyticsJobService' | tee -a $LOGGWL
$pmd 'com.google.android.syncadapters.contacts/com.google.android.gms.analytics.AnalyticsService' | tee -a $LOGGWL
$pmd 'com.google.android.gms/com.google.android.gms.gcm.HeartbeatAlarm$ConnectionInfoPersistService' | tee -a $LOGGWL
$pmd 'com.google.android.gms/com.google.android.gms.chimera.PersistentIntentOperationService' | tee -a $LOGGWL

kmsg2 "Applied Google Wakelocks Tweaks..."
kmsg2 "----"

kmsg $(date) 
kmsg "GWakelocks Tweaked."
kmsg "----"

kmsg $(date) 
kmsg "Kernel and CPU Level Tweaks Started"
kmsg "----"

kmsg2 $(date) 
kmsg2 "Kernel and CPU Level Tweaks"
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
ctl /proc/sys/net/core/netdev_max_backlog 128
ctl /proc/sys/net/core/netdev_tstamp_prequeue 0
ctl /proc/sys/net/ipv4/ipfrag_time 24
ctl /proc/sys/net/ipv4/tcp_congestion_control westwood
ctl /proc/sys/net/ipv4/tcp_ecn 1
ctl /proc/sys/net/ipv4/tcp_fastopen 3
ctl /proc/sys/net/ipv4/tcp_sack 1
ctl /proc/sys/net/ipv4/tcp_fack 1
ctl /proc/sys/net/ipv4/tcp_tw_reuse 1
ctl /proc/sys/net/ipv4/tcp_dsack 1
ctl /proc/sys/net/ipv4/tcp_fwmark_accept 0
ctl /proc/sys/net/ipv4/tcp_keepalive_intvl 320
ctl /proc/sys/net/ipv4/tcp_keepalive_time 21600
ctl /proc/sys/net/ipv4/tcp_no_metrics_save 1
ctl /proc/sys/net/ipv4/tcp_slow_start_after_idle 0
ctl /proc/sys/net/ipv6/ip6frag_time 48
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
ctl /proc/sys/vm/vfs_cache_pressure 94
ctl /proc/sys/vm/overcommit_ratio 50
ctl /proc/sys/vm/extra_free_kbytes 24300
ctl /proc/sys/kernel/random/read_wakeup_threshold 64
ctl /proc/sys/kernel/random/write_wakeup_threshold 890
ctl /sys/module/lowmemorykiller/parameters/minfree "21816,29088,36360,43632,50904,65448"
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
ctl "${g}"/rq_affinity 0
ctl "${g}"/iosched/slice_idle 0
ctl "${g}"/iosched/low_latency 0
ctl "${g}"/scheduler cfq
ctl "${g}"/read_ahead_kb 128
ctl "${g}"/nr_requests 4096
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
ctl /dev/stune/background/schedtune.boost 9
ctl /dev/stune/foreground/schedtune.boost 9
ctl /dev/stune/rt/schedtune.boost 0
ctl /dev/stune/top-app/schedtune.boost 25
ctl /dev/stune/schedtune.boost 5
ctl /dev/stune/nnapi-hal/schedtune.boost 0
ctl /dev/stune/nnapi-hal/schedtune.prefer_idle 1
ctl /dev/stune/top-app/schedtune.prefer_idle 1
ctl /dev/stune/background/schedtune.prefer_idle 1
ctl /dev/stune/foreground/schedtune.prefer_idle 1
ctl /dev/stune/rt/schedtune.prefer_idle 1
ctl /dev/stune/schedtune.prefer_idle 1

# Fs
ctl /proc/sys/fs/lease-break-time 80
ctl /proc/sys/kernel/perf_cpu_time_max_percent 95
ctl /proc/sys/kernel/sched_min_task_util_for_colocation 1000
ctl /proc/sys/kernel/sched_min_task_util_for_boost 1000
ctl /proc/sys/kernel/sched_child_runs_first 0
ctl /proc/sys/kernel/sched_boost_top_app 0
ctl /proc/sys/kernel/sched_walt_rotate_big_tasks 0
ctl /proc/sys/kernel/sched_boost 0

# Boost Control Tweak
# Credits to @Ratoriku
ctl /sys/module/boost_control/parameters/app_launch_boost_ms 0

# GPU frequency based throttling;
ctl /sys/class/kgsl/kgsl-3d0/throttling 1
ctl /sys/class/kgsl/kgsl-3d0/default_pwrlevel 5
ctl /sys/class/kgsl/kgsl-3d0/bus_split 1

#1028 readahead KB
ctl /sys/block/sde/queue/read_ahead_kb 1028
ctl /sys/block/sdf/queue/read_ahead_kb 1028

# For Idle battery Life
ctl /sys/class/misc/boeffla_wakelock_blocker/wakelock_blocker "qcom_rx_wakelock;wlan;wlan_wow_wl;wlan_extscan_wl;netmgr_wl;NETLINK;IPA_WS;[timerfd];wlan_ipa;wlan_pno_wl;wcnss_filter_lock;IPCRTR_lpass_rx;hal_bluetooth_lock"

# For Net Speed
for i in $(find /sys/class/net -type l); do
  ctl $i/tx_queue_len 128
done
ctl /sys/module/tcp_cubic/parameters/hystart_detect 2

# Misc Kernel Teaks
ctl /sys/kernel/debug/sched_features NO_NEXT_BUDDY
ctl /sys/kernel/debug/sched_features NO_GENTLE_FAIR_SLEEPERS
ctl /sys/kernel/debug/sched_features NO_TTWU_QUEUE
ctl /sys/kernel/debug/sched_features NO_RT_RUNTIME_SHARE
ctl /sys/kernel/debug/sched_features NO_AFFINE_WAKEUPS

for cpu in /sys/devices/system/cpu/*/sched_load_boost
do
    ctl "$cpu" 0
done

for boost in /sys/devices/system/*/cpu_boost
do
    ctl "$boost"/sched_boost_on_input 0
    ctl "$boost"/sched_boost_on_powerkey_input 0
    ctl "$boost"/input_boost_ms 0
    ctl "$boost"/powerkey_input_boost_ms 0
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

# Flexibility started from 102+

ctl /proc/sys/fs/dir-notify-enable 0
ctl /proc/sys/fs/lease-break-time 15
ctl /proc/sys/fs/leases-enable 1
ctl /proc/sys/fs/file-max 2097152
ctl /proc/sys/fs/inotify/max_queued_events 131072
ctl /proc/sys/fs/inotify/max_user_watches 131072
ctl /proc/sys/fs/inotify/max_user_instances 1024

#BAT2

ctl /proc/sys/kernel/sched_boost 1
ctl /sys/module/cpu_boost/parameters/input_boost_freq "0:1036800 2:1036800"
ctl /sys/module/cpu_boost/parameters/input_boost_ms 500
ctl /sys/module/cpu_boost/parameters/input_boost_enabled 0
ctl /sys/class/kgsl/kgsl-3d0/default_pwrlevel 7
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
ctl /sys/devices/system/cpu/cpu6/online 0
ctl /sys/devices/system/cpu/cpu7/online 0

ctl /proc/sys/kernel/sched_boost 0
ctl /sys/module/cpu_boost/parameters/input_boost_freq "0:1036800 2:1036800"
ctl /sys/module/cpu_boost/parameters/input_boost_ms 500
ctl /sys/module/cpu_boost/parameters/input_boost_enabled 0
ctl /sys/class/kgsl/kgsl-3d0/default_pwrlevel 7
ctl /sys/class/kgsl/kgsl-3d0/devfreq/governor powersave
ctl /sys/class/kgsl/kgsl-3d0/devfreq/adrenoboost 0
ctl /sys/block/dm-0/queue/scheduler "noop"
ctl /sys/block/dm-1/queue/scheduler "noop"
ctl /sys/block/sda/queue/scheduler "noop"
ctl /sys/block/sde/queue/scheduler "noop"
ctl /sys/block/dm-0/queue/read_ahead_kb 2048
ctl /sys/block/dm-1/queue/read_ahead_kb 2048
ctl /sys/block/sda/queue/read_ahead_kb 2048
ctl /sys/block/sde/queue/read_ahead_kb 2048

# Force cluster CPUs
ctl /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor conservative
ctl /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor conservative
ctl /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor conservative
ctl /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor conservative
ctl /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor powersave
ctl /sys/devices/system/cpu/cpu5/cpufreq/scaling_governor powersave
ctl /sys/devices/system/cpu/cpu6/cpufreq/scaling_governor powersave
ctl /sys/devices/system/cpu/cpu7/cpufreq/scaling_governor powersave
ctl /sys/devices/system/cpu/cpufreq/policy0/scaling_governor conservative
ctl /sys/devices/system/cpu/cpufreq/policy4/scaling_governor powersave
ctl /sys/devices/system/cpu/cpufreq/policy7/scaling_governor powersave

ctl /sys/kernel/gpu/gpu_governor powersave
ctl /sys/module/adreno_idler/parameters/adreno_idler_active 1
ctl /sys/module/lazyplug/parameters/nr_possible_cores 6
ctl /sys/module/msm_performance/parameters/touchboost 0
ctl /dev/cpuset/foreground/boost/cpus 0-3
ctl /dev/cpuset/foreground/cpus 0-5
ctl /dev/cpuset/top-app/cpus 0-5
DEVICE="$(getprop vendor.product.device)"
if [[ "$DEVICE" == guacamole ]]; then
am start -a android.intent.action.MAIN -e toasttext "Device detected OP7Pro" -n mkadp.toast/.MainActivity
	ctl /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq 1382400
	ctl /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq 300000
	ctl /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq 1382400
	ctl /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq 300000
	ctl /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq 1382400
	ctl /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq 300000
	ctl /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq 1382400
	ctl /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq 300000
	ctl /sys/devices/system/cpu/cpufreq/policy0/scaling_max_freq 1382400
	ctl /sys/devices/system/cpu/cpufreq/policy0/scaling_min_freq 300000

	ctl /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq 2131200
	ctl /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq 710400
	ctl /sys/devices/system/cpu/cpu5/cpufreq/scaling_max_freq 2131200
	ctl /sys/devices/system/cpu/cpu5/cpufreq/scaling_min_freq 710400
	ctl /sys/devices/system/cpu/cpu6/cpufreq/scaling_max_freq 2131200
	ctl /sys/devices/system/cpu/cpu6/cpufreq/scaling_min_freq 710400
	ctl /sys/devices/system/cpu/cpufreq/policy4/scaling_max_freq 2131200
	ctl /sys/devices/system/cpu/cpufreq/policy4/scaling_min_freq 710400

	ctl /sys/devices/system/cpu/cpu7/cpufreq/scaling_max_freq 1990000
	ctl /sys/devices/system/cpu/cpu7/cpufreq/scaling_min_freq 210400
	ctl /sys/devices/system/cpu/cpufreq/policy7/scaling_max_freq 1990000
	ctl /sys/devices/system/cpu/cpufreq/policy7/scaling_min_freq 210400
fi

if [[ "$DEVICE" == guacamoleb ]]; then
am start -a android.intent.action.MAIN -e toasttext "Device detected OP7" -n mkadp.toast/.MainActivity
	ctl /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq 1382400
	ctl /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq 300000
	ctl /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq 1382400
	ctl /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq 300000
	ctl /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq 1382400
	ctl /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq 300000
	ctl /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq 1382400
	ctl /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq 300000
	ctl /sys/devices/system/cpu/cpufreq/policy0/scaling_max_freq 1382400
	ctl /sys/devices/system/cpu/cpufreq/policy0/scaling_min_freq 300000

	ctl /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq 2131200
	ctl /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq 710400
	ctl /sys/devices/system/cpu/cpu5/cpufreq/scaling_max_freq 2131200
	ctl /sys/devices/system/cpu/cpu5/cpufreq/scaling_min_freq 710400
	ctl /sys/devices/system/cpu/cpu6/cpufreq/scaling_max_freq 2131200
	ctl /sys/devices/system/cpu/cpu6/cpufreq/scaling_min_freq 710400
	ctl /sys/devices/system/cpu/cpufreq/policy4/scaling_max_freq 2131200
	ctl /sys/devices/system/cpu/cpufreq/policy4/scaling_min_freq 710400

	ctl /sys/devices/system/cpu/cpu7/cpufreq/scaling_max_freq 1990000
	ctl /sys/devices/system/cpu/cpu7/cpufreq/scaling_min_freq 210400
	ctl /sys/devices/system/cpu/cpufreq/policy7/scaling_max_freq 1990000
	ctl /sys/devices/system/cpu/cpufreq/policy7/scaling_min_freq 210400
fi

if [[ "$DEVICE" == hotdog ]]; then
am start -a android.intent.action.MAIN -e toasttext "Device detected OP7TPro" -n mkadp.toast/.MainActivity
	ctl /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq 1382400
	ctl /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq 300000
	ctl /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq 1382400
	ctl /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq 300000
	ctl /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq 1382400
	ctl /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq 300000
	ctl /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq 1382400
	ctl /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq 300000
	ctl /sys/devices/system/cpu/cpufreq/policy0/scaling_max_freq 1382400
	ctl /sys/devices/system/cpu/cpufreq/policy0/scaling_min_freq 300000

	ctl /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq 2131200
	ctl /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq 710400
	ctl /sys/devices/system/cpu/cpu5/cpufreq/scaling_max_freq 2131200
	ctl /sys/devices/system/cpu/cpu5/cpufreq/scaling_min_freq 710400
	ctl /sys/devices/system/cpu/cpu6/cpufreq/scaling_max_freq 2131200
	ctl /sys/devices/system/cpu/cpu6/cpufreq/scaling_min_freq 710400
	ctl /sys/devices/system/cpu/cpufreq/policy4/scaling_max_freq 2131200
	ctl /sys/devices/system/cpu/cpufreq/policy4/scaling_min_freq 710400

	ctl /sys/devices/system/cpu/cpu7/cpufreq/scaling_max_freq 1990000
	ctl /sys/devices/system/cpu/cpu7/cpufreq/scaling_min_freq 210400
	ctl /sys/devices/system/cpu/cpufreq/policy7/scaling_max_freq 2110000
	ctl /sys/devices/system/cpu/cpufreq/policy7/scaling_min_freq 210400
fi

if [[ "$DEVICE" == hotdogg ]]; then
am start -a android.intent.action.MAIN -e toasttext "Device detected OP7TProMclrn" -n mkadp.toast/.MainActivity
	ctl /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq 1382400
	ctl /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq 300000
	ctl /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq 1382400
	ctl /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq 300000
	ctl /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq 1382400
	ctl /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq 300000
	ctl /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq 1382400
	ctl /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq 300000
	ctl /sys/devices/system/cpu/cpufreq/policy0/scaling_max_freq 1382400
	ctl /sys/devices/system/cpu/cpufreq/policy0/scaling_min_freq 300000

	ctl /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq 2131200
	ctl /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq 710400
	ctl /sys/devices/system/cpu/cpu5/cpufreq/scaling_max_freq 2131200
	ctl /sys/devices/system/cpu/cpu5/cpufreq/scaling_min_freq 710400
	ctl /sys/devices/system/cpu/cpu6/cpufreq/scaling_max_freq 2131200
	ctl /sys/devices/system/cpu/cpu6/cpufreq/scaling_min_freq 710400
	ctl /sys/devices/system/cpu/cpufreq/policy4/scaling_max_freq 2131200
	ctl /sys/devices/system/cpu/cpufreq/policy4/scaling_min_freq 710400

	ctl /sys/devices/system/cpu/cpu7/cpufreq/scaling_max_freq 1990000
	ctl /sys/devices/system/cpu/cpu7/cpufreq/scaling_min_freq 210400
	ctl /sys/devices/system/cpu/cpufreq/policy7/scaling_max_freq 2110000
	ctl /sys/devices/system/cpu/cpufreq/policy7/scaling_min_freq 210400
fi

if [[ "$DEVICE" == hotdogb ]]; then
am start -a android.intent.action.MAIN -e toasttext "Device detected OP7T" -n mkadp.toast/.MainActivity
	ctl /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq 1382400
	ctl /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq 300000
	ctl /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq 1382400
	ctl /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq 300000
	ctl /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq 1382400
	ctl /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq 300000
	ctl /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq 1382400
	ctl /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq 300000
	ctl /sys/devices/system/cpu/cpufreq/policy0/scaling_max_freq 1382400
	ctl /sys/devices/system/cpu/cpufreq/policy0/scaling_min_freq 300000

	ctl /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq 2131200
	ctl /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq 710400
	ctl /sys/devices/system/cpu/cpu5/cpufreq/scaling_max_freq 2131200
	ctl /sys/devices/system/cpu/cpu5/cpufreq/scaling_min_freq 710400
	ctl /sys/devices/system/cpu/cpu6/cpufreq/scaling_max_freq 2131200
	ctl /sys/devices/system/cpu/cpu6/cpufreq/scaling_min_freq 710400
	ctl /sys/devices/system/cpu/cpufreq/policy4/scaling_max_freq 2131200
	ctl /sys/devices/system/cpu/cpufreq/policy4/scaling_min_freq 710400

	ctl /sys/devices/system/cpu/cpu7/cpufreq/scaling_max_freq 1990000
	ctl /sys/devices/system/cpu/cpu7/cpufreq/scaling_min_freq 210400
	ctl /sys/devices/system/cpu/cpufreq/policy7/scaling_max_freq 2110000
	ctl /sys/devices/system/cpu/cpufreq/policy7/scaling_min_freq 210400
fi

ctl /sys/devices/system/cpu/cpu0/core_ctl/busy_down_thres 25
ctl /sys/devices/system/cpu/cpu0/core_ctl/busy_up_thres 60
ctl /sys/devices/system/cpu/cpu4/core_ctl/busy_down_thres 25
ctl /sys/devices/system/cpu/cpu4/core_ctl/busy_up_thres 60
ctl /sys/devices/system/cpu/cpu7/core_ctl/busy_down_thres 25
ctl /sys/devices/system/cpu/cpu7/core_ctl/busy_up_thres 60

ctl /sys/devices/system/cpu/cpu0/core_ctl/max_cpus 4
ctl /sys/devices/system/cpu/cpu0/core_ctl/min_cpus 1
ctl /sys/devices/system/cpu/cpu4/core_ctl/max_cpus 2
ctl /sys/devices/system/cpu/cpu4/core_ctl/min_cpus 1
ctl /sys/devices/system/cpu/cpu7/core_ctl/max_cpus 0
ctl /sys/devices/system/cpu/cpu7/core_ctl/min_cpus 0

am start -a android.intent.action.MAIN -e toasttext "Finally...Kernel/CPU/GPU Tweaks Applied" -n mkadp.toast/.MainActivity

kmsg2 $(date) 
kmsg2 "Applied..."
kmsg2 "----"

#
kmsg $(date) 
kmsg "Disabling ZRAM"
kmsg "----"
#
kmsg2 $(date) 
kmsg2 "Disabling ZRAM"
kmsg2 "If not already"
kmsg2 "----"
#
swapoff /dev/zram0
swapoff /dev/block/zram0
swapoff /dev/block/vnswap0
ctl /sys/block/zram0/reset 1
ctl /sys/block/zram0/disksize 0
ctl /sys/block/vnswap0/reset 1
ctl /sys/block/vnswap0/disksize 0
ctl /proc/sys/vm/swappiness 0
#
kmsg $(date) 
kmsg "ZRAM Disabled"
kmsg "----"
#
kmsg2 $(date) 
kmsg2 "ZRAM Disable"
kmsg2 "----"
#

kmsg2 $(date) 
kmsg2 "All Done."
kmsg2 "Enjoy Battery"
kmsg2 "----"

# Push a semi-needed log to the internal storage with a "report" if the script could be executed or not;
kmsg $(date) 
kmsg "MKADP HAS EXECUTED TASK SUCCESSFULLY. ENJOY!" 

$BB rm -rf /cache/*	

am start -a android.intent.action.MAIN -e toasttext "All Done. Thankyou for your patience" -n mkadp.toast/.MainActivity

dumpsys deviceidle enable all;
dumpsys deviceidle enabled all;
dumpsys deviceidle enable;
dumpsys deviceidle enabled;
dumpsys deviceidle force-idle
settings put global aggressive_idle_enabled "1"
settings put global aggressive_standby_enabled "1"

 su -lp 2000 -c "cmd notification post -S bigtext -t 'OxyPlus Descrete' 'Tag' 'Battery Profile applied without any error
 At $(date)'"

am start -n com.mkadp.oxyplusd/.activities.LogsActivity
exit 0
