##add the required module filename (without .ko) and the kernel config entry needed for it (XXXXX=m)
opts=""
modules=""

## example: drivers for an I2C RTC and Intel GPIO drivers used in Buffalo NAS devices 
#opts="CONFIG_RTC_DRV_RS5C372=m CONFIG_GPIO_ICH=m"
#modules="rtc-rs5c372 gpio-ich"

num_cpu="$(cat /proc/cpuinfo | grep -e ^processor  | wc -l)"

kernels="$(ls /lib/modules)"

for kernel in $kernels
do
    for module in $modules
    do
        find /lib/modules/$kernel/ | grep $module.ko > /dev/null
        if [ $? -eq 0 ]; then
            continue
        fi
        k_ver="$(echo $kernel | cut -d'.' -f1-2)"
        k_ver_long="$(echo $kernel | cut -d'-' -f1-2)"
        apt-get install -yq linux-headers-$kernel linux-source-$k_ver linux-headers-$k_ver_long-common ##> /dev/null
        cd /usr/src
        cp -rf linux-headers-$kernel build-temp-$kernel
        cd build-temp-$kernel
        cp -rf ../linux-headers-$k_ver_long-common/* .
        src_path="$(tar tf ../linux-source-$k_ver.tar.xz | grep $module)"
	src_dir="$(dirname $src_path)"
        tar xvf ../linux-source-$k_ver.tar.xz --wildcards --strip-components=1 $src_dir/*
        src_dir="${src_dir#*/}"
        make -j $num_cpu M="$src_dir" $opts
        cp -v $src_dir/$module.ko /lib/modules/$kernel/kernel/
        insmod /lib/modules/$kernel/kernel/$module.ko
    done
    dpkg --purge linux-source-$k_ver
    rm -r /usr/src/build-temp-$kernel/
    depmod -a
done
