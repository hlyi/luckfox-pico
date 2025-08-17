#!/bin/sh

TIMEZONE=`cat /etc/timezone`

	
# Update package repositories and system
apk update

# Install and configure OpenRC
apk add openrc
rc-update add devfs boot
rc-update add procfs boot
rc-update add sysfs boot
rc-update add ubiattach boot
chmod a+x /etc/local.d/crond.start
rc-update add local default
rc-update add networking default


# Configure timezone
apk add tzdata && \

echo $TIMEZONE > /etc/timezone
cp /usr/share/zoneinfo/$TIMEZONE /etc/localtime && apk del tzdata

# Configure terminal
apk add agetty && printf "luckfox\nluckfox\n" | passwd root && \
	sed -i 's|ttyFIQ0::respawn:/bin/sh -l|ttyFIQ0::respawn:/sbin/agetty --noclear ttyFIQ0 115200|' /etc/inittab

# Install and configure bash
apk add bash && \
sed -i 's|root:x:0:0:root:/root:/bin/sh|root:x:0:0:root:/root:/bin/bash|' /etc/passwd

# Install and configure SSH
apk add openssh && \
sed -i 's/#PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
sed -i 's/#PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
rc-update add sshd default

# Install additional utilities
apk add util-linux dialog dtc i2c-tools mtd-utils
apk add btop ncurses ncurses-terminfo-base 
# apk add musl-locales
apk add sqlite
# apk add python3 py3-pip py3-smbus
# apk add gcc musl-dev build-base gcompat linux-headers
# apk add speedtest-cli

# Remove dev dependency
sed -i 's/need sysfs dev/need sysfs/' /etc/init.d/hwdrivers
sed -i 's/need sysfs dev/need sysfs/' /etc/init.d/machine-id

rootfsname="$1"
ownership="$2"
cd /
mkdir /my-rootfs/$rootfsname

tar c bin etc lib root sbin usr |tar x -C /my-rootfs/$rootfsname
for dir in dev proc run sys var; do mkdir /my-rootfs/$rootfsname/${dir}; done
cd /my-rootfs && tar czf ${rootfsname}.tar $rootfsname
rm -rf $rootfsname
chown $ownership ${rootfsname}.tar
exit 0
