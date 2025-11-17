ifeq ($(APP_PARAM), )
    APP_PARAM:=../Makefile.param
    include $(APP_PARAM)
endif

export LC_ALL=C
SHELL:=/bin/bash
# default build adbd with static link
# PKG_WPA_RTK_BUILD_STATIC ?= -static -pthread
# arch=arm default use thumb-2 compile
ifeq ($(RK_APP_ARCH_TYPE),arm)
PKG_USE_THUMB2 ?= YES
endif

CURRENT_DIR := $(shell pwd)
PKG_TARBALL_WPA_RTK_TOOLS := wpa_supplicant_hostapd-0.8_rtw-2-ga8ef7c824.20200911.tar.gz
PKG_NAME_WPA_RTK_TOOLS:= wpa_supplicant_hostapd-0.8_rtw-2-ga8ef7c824.20200911
PKG_NAME_WPA_TOOLS:= wpa_supplicant-2.6
PKG_NAME_HOSTAPD_TOOLS:= hostapd-2.6

PKG_TARBALL_LIBMIRAGE := libmirage-3.2.10.tar.xz
PKG_NAME_LIBMIRAGE := libmirage-3.2.10
ifeq ($(RK_APP_ARCH_TYPE),arm)
PKG_OS_COMPILE_FLAG_OPENSSL := linux-armv4
else
PKG_OS_COMPILE_FLAG_OPENSSL := linux-aarch64
endif

PKG_BIN := out
PKG_BIN_INSTALL_DIR := install_out
PKG_BIN_INSTALL := $(PKG_BIN_INSTALL_DIR)/root

PKG_CONF_OPTS += $(RK_APP_OPTS) -Os \
				 -I $(CURRENT_DIR)/$(PKG_BIN)/include/libmirage3 \
				 -L $(CURRENT_DIR)/$(PKG_BIN)/lib \
				 -l nl-3 \
				 -l nl-genl-3
ifeq ($(RK_APP_CHIP),rv1126)
PKG_CONF_OPTS += -lpthread
endif
ifeq ($(PKG_USE_THUMB2),YES)
PKG_CONF_OPTS += -mthumb -Wa,-mimplicit-it=thumb -mthumb-interwork
endif

#ifeq ($(RK_ENABLE_CDEMU),y)
#PKG_TARGET += build-cdemu
#else
#ifneq (, $(filter RK_CDEMU_APP,$(RK_APP_TYPE)))
#PKG_TARGET += build-cdemu
#endif
#endif
PKG_TARGET += build-cdemu

all: $(PKG_TARGET)
	@echo "build cdemu app done"

build-cdemu: libmirage
	@test -f $(CURRENT_DIR)/$(PKG_BIN)/bin/wpa_supplicant_rtk || (\
	rm -rf $(CURRENT_DIR)/$(PKG_NAME_WPA_RTK_TOOLS); \
	tar -xf $(PKG_TARBALL_WPA_RTK_TOOLS); \
	mkdir -p $(CURRENT_DIR)/$(PKG_NAME_WPA_RTK_TOOLS)/$(PKG_BIN); \
	mkdir -p $(CURRENT_DIR)/$(PKG_BIN)/bin; \
	pushd $(CURRENT_DIR)/$(PKG_NAME_WPA_RTK_TOOLS)/; \
		CC="$(RK_APP_CROSS)-gcc" GCC="$(RK_APP_CROSS)-gcc" CXX="$(RK_APP_CROSS)-g++" CPP="$(RK_APP_CROSS)-cpp" \
		CFLAGS="$(PKG_CONF_OPTS)" CPPFLAGS="$(PKG_CONF_OPTS)" \
		CXXFLAGS="$(PKG_CONF_OPTS)" LDFLAGS="$(PKG_CONF_OPTS) $(PKG_WPA_RTK_BUILD_STATIC)" \
		make -j$(RK_APP_JOBS) -C $(CURRENT_DIR)/$(PKG_NAME_WPA_RTK_TOOLS)/wpa_supplicant/ ;\
		cp -f $(CURRENT_DIR)/$(PKG_NAME_WPA_RTK_TOOLS)/wpa_supplicant/wpa_supplicant $(CURRENT_DIR)/$(PKG_BIN)/bin/wpa_supplicant_nl80211_rtk ; \
		cp -f $(CURRENT_DIR)/$(PKG_NAME_WPA_RTK_TOOLS)/wpa_supplicant/wpa_cli $(CURRENT_DIR)/$(PKG_BIN)/bin/wpa_cli_rtk ; \
		make -j$(RK_APP_JOBS) -C $(CURRENT_DIR)/$(PKG_NAME_WPA_RTK_TOOLS)/wpa_supplicant/ clean ;\
		sed -i 's/CONFIG_DRIVER_NL80211=y/#CONFIG_DRIVER_NL80211=y/g' $(CURRENT_DIR)/$(PKG_NAME_WPA_RTK_TOOLS)/wpa_supplicant/.config ; \
		CC="$(RK_APP_CROSS)-gcc" GCC="$(RK_APP_CROSS)-gcc" CXX="$(RK_APP_CROSS)-g++" CPP="$(RK_APP_CROSS)-cpp" \
		CFLAGS="$(PKG_CONF_OPTS)" CPPFLAGS="$(PKG_CONF_OPTS)" \
		CXXFLAGS="$(PKG_CONF_OPTS)" LDFLAGS="$(PKG_CONF_OPTS) $(PKG_WPA_RTK_BUILD_STATIC)" \
		make -j$(RK_APP_JOBS) -C $(CURRENT_DIR)/$(PKG_NAME_WPA_RTK_TOOLS)/wpa_supplicant/ ;\
		cp -f $(CURRENT_DIR)/$(PKG_NAME_WPA_RTK_TOOLS)/wpa_supplicant/wpa_supplicant $(CURRENT_DIR)/$(PKG_BIN)/bin/wpa_supplicant_rtk ; \
	popd; )
	@test -f $(CURRENT_DIR)/$(PKG_BIN)/bin/wpa_supplicant || (\
	mkdir -p $(CURRENT_DIR)/$(PKG_NAME_WPA_TOOLS)/$(PKG_BIN); \
	pushd $(CURRENT_DIR)/$(PKG_NAME_WPA_TOOLS)/; \
		CC="$(RK_APP_CROSS)-gcc" GCC="$(RK_APP_CROSS)-gcc" CXX="$(RK_APP_CROSS)-g++" CPP="$(RK_APP_CROSS)-cpp" \
		CFLAGS="$(PKG_CONF_OPTS)" CPPFLAGS="$(PKG_CONF_OPTS)" \
		CXXFLAGS="$(PKG_CONF_OPTS)" LDFLAGS="$(PKG_CONF_OPTS) $(PKG_WPA_RTK_BUILD_STATIC)" \
		make -j$(RK_APP_JOBS) -C $(CURRENT_DIR)/$(PKG_NAME_WPA_TOOLS)/wpa_supplicant/ ;\
		cp -f $(CURRENT_DIR)/$(PKG_NAME_WPA_TOOLS)/wpa_supplicant/wpa_supplicant $(CURRENT_DIR)/$(PKG_BIN)/bin/ ; \
		cp -f $(CURRENT_DIR)/$(PKG_NAME_WPA_TOOLS)/wpa_supplicant/wpa_cli $(CURRENT_DIR)/$(PKG_BIN)/bin/ ; \
		cp -f $(CURRENT_DIR)/$(PKG_NAME_WPA_TOOLS)/wpa_supplicant/libwpa_client.so $(CURRENT_DIR)/$(PKG_BIN)/lib/ ; \
	popd; )
	@test -f $(CURRENT_DIR)/$(PKG_BIN)/bin/hostapd || (\
	mkdir -p $(CURRENT_DIR)/$(PKG_NAME_HOSTAPD_TOOLS)/$(PKG_BIN); \
	pushd $(CURRENT_DIR)/$(PKG_NAME_HOSTAPD_TOOLS)/; \
		CC="$(RK_APP_CROSS)-gcc" GCC="$(RK_APP_CROSS)-gcc" CXX="$(RK_APP_CROSS)-g++" CPP="$(RK_APP_CROSS)-cpp" \
		CFLAGS="$(PKG_CONF_OPTS)" CPPFLAGS="$(PKG_CONF_OPTS)" \
		CXXFLAGS="$(PKG_CONF_OPTS)" LDFLAGS="$(PKG_CONF_OPTS) $(PKG_WPA_RTK_BUILD_STATIC)" \
		make -j$(RK_APP_JOBS) -C $(CURRENT_DIR)/$(PKG_NAME_HOSTAPD_TOOLS)/hostapd/ ;\
		cp -f $(CURRENT_DIR)/$(PKG_NAME_HOSTAPD_TOOLS)/hostapd/hostapd_cli $(CURRENT_DIR)/$(PKG_BIN)/bin/ ; \
		cp -f $(CURRENT_DIR)/$(PKG_NAME_HOSTAPD_TOOLS)/hostapd/hostapd $(CURRENT_DIR)/$(PKG_BIN)/bin/ ; \
	popd; )

	#build test app
	make -C $(CURRENT_DIR)/cdemu/ clean;
	@CC="$(RK_APP_CROSS)-gcc" GCC="$(RK_APP_CROSS)-gcc" \
	CXX="$(RK_APP_CROSS)-g++" CPP="$(RK_APP_CROSS)-cpp" \
	make -C $(CURRENT_DIR)/cdemu/;

	$(RK_APP_CROSS)-strip -s $(CURRENT_DIR)/$(PKG_BIN)/bin/wpa_supplicant ;
	$(RK_APP_CROSS)-strip -s $(CURRENT_DIR)/$(PKG_BIN)/bin/wpa_cli ;
	$(RK_APP_CROSS)-strip -s $(CURRENT_DIR)/$(PKG_BIN)/bin/wpa_supplicant_rtk ;
	$(RK_APP_CROSS)-strip -s $(CURRENT_DIR)/$(PKG_BIN)/bin/wpa_supplicant_nl80211_rtk ;
	$(RK_APP_CROSS)-strip -s $(CURRENT_DIR)/$(PKG_BIN)/bin/wpa_cli_rtk ;

	$(RK_APP_CROSS)-strip -s $(CURRENT_DIR)/cdemu/test/rkcdemu_server ;
	@chmod +x $(CURRENT_DIR)/cdemu/test/rkcdemu_server ;
	@mkdir -p $(CURRENT_DIR)/$(PKG_BIN_INSTALL) \
		$(CURRENT_DIR)/$(PKG_BIN_INSTALL)/etc \
		$(CURRENT_DIR)/$(PKG_BIN_INSTALL)/usr/bin \
		$(CURRENT_DIR)/$(PKG_BIN_INSTALL)/usr/lib;
	@cp -fa $(CURRENT_DIR)/$(PKG_BIN)/bin/wpa_supplicant \
		$(CURRENT_DIR)/$(PKG_BIN)/bin/wpa_cli \
		$(CURRENT_DIR)/$(PKG_BIN)/bin/wpa_supplicant_rtk \
		$(CURRENT_DIR)/$(PKG_BIN)/bin/wpa_supplicant_nl80211_rtk \
		$(CURRENT_DIR)/$(PKG_BIN)/bin/wpa_cli_rtk \
		$(CURRENT_DIR)/$(PKG_BIN_INSTALL)/usr/bin;
ifeq ($(RK_APP_CHIP),rv1126)
	@cp -fa $(CURRENT_DIR)/wpa_supplicant_rv1126.conf $(CURRENT_DIR)/$(PKG_BIN_INSTALL)/etc/wpa_supplicant.conf;
else
	@cp -fa $(CURRENT_DIR)/wpa_supplicant.conf $(CURRENT_DIR)/$(PKG_BIN_INSTALL)/etc;
endif
	@cp -fa $(CURRENT_DIR)/cdemu/test/rkcdemu_server $(CURRENT_DIR)/$(PKG_BIN_INSTALL)/usr/bin;
	@cp -fa $(CURRENT_DIR)/bin/cdemu_start.sh $(CURRENT_DIR)/$(PKG_BIN_INSTALL)/usr/bin;
	@cp -fa $(CURRENT_DIR)/cdemu/librkcdemubt.so $(CURRENT_DIR)/$(PKG_BIN_INSTALL)/usr/lib;
	@cp -fa $(CURRENT_DIR)/$(PKG_BIN)/lib/libwpa_client.so $(CURRENT_DIR)/$(PKG_BIN_INSTALL)/usr/lib;

ifneq ($(findstring $(RK_ENABLE_CDEMU_CHIP),"AP6XXX"),)
	@mkdir -p $(CURRENT_DIR)/$(PKG_BIN_INSTALL)/vendor/etc/firmware;
	@cp -fa $(CURRENT_DIR)/AP6256/nvram_ap6256.txt $(CURRENT_DIR)/$(PKG_BIN_INSTALL)/vendor/etc/firmware;
	@cp -fa $(CURRENT_DIR)/AP6256/fw_bcm43456c5_ag.bin $(CURRENT_DIR)/$(PKG_BIN_INSTALL)/vendor/etc/firmware;
endif

ifeq ($(RK_APP_CHIP),rv1106)
	@cp -fa $(CURRENT_DIR)/cdemu/test/rkcdemu_server $(CURRENT_DIR)/$(PKG_BIN_INSTALL)/usr/bin;
	$(RK_APP_CROSS)-strip -s $(CURRENT_DIR)/$(PKG_BIN)/bin/hostapd ;
	@cp -fa $(CURRENT_DIR)/$(PKG_BIN)/bin/hostapd $(CURRENT_DIR)/$(PKG_BIN_INSTALL)/usr/bin;
	@cp -fa $(CURRENT_DIR)/precompile/$(RK_APP_CROSS)/lib/* $(CURRENT_DIR)/$(PKG_BIN_INSTALL)/usr/lib;
	@cp -fa $(CURRENT_DIR)/precompile/$(RK_APP_CROSS)/bin/iperf $(CURRENT_DIR)/$(PKG_BIN_INSTALL)/usr/bin/;
	@cp -fa $(CURRENT_DIR)/precompile/$(RK_APP_CROSS)/bin/dnsmasq $(CURRENT_DIR)/$(PKG_BIN_INSTALL)/usr/bin/;
endif

	$(call MAROC_COPY_PKG_TO_APP_OUTPUT, $(RK_APP_OUTPUT), $(PKG_BIN_INSTALL_DIR))

libmirage:
	@test -f $(CURRENT_DIR)/$(PKG_BIN)/lib/libmirage.so || (\
	rm -rf $(CURRENT_DIR)/$(PKG_BIN); \
	rm -fr $(CURRENT_DIR)/$(PKG_NAME_LIBMIRAGE)/; \
	tar -xf $(PKG_TARBALL_LIBMIRAGE); \
	mkdir -p $(CURRENT_DIR)/$(PKG_BIN); \
	pushd $(CURRENT_DIR)/$(PKG_NAME_LIBMIRAGE)/; \
		CC="$(RK_APP_CROSS)-gcc" GCC="$(RK_APP_CROSS)-gcc" \
		CXX="$(RK_APP_CROSS)-g++" CPP="$(RK_APP_CROSS)-cpp" \
			cmake -DCMAKE_INSTALL_PREFIX=$(CURRENT_DIR)/$(PKG_BIN) -DCMAKE_BUILD_TYPE=Release . ; \
		make -j$(RK_APP_JOBS) > /dev/null || exit -1; \
		make install > /dev/null; \
		rm $(CURRENT_DIR)/$(PKG_BIN)/lib/lib*0 ;\
	popd; )
#			--prefix=$(CURRENT_DIR)/$(PKG_BIN) --host=arm-linux --enable-static ;\

clean: distclean

distclean:
	@make -j$(RK_APP_JOBS) -C $(CURRENT_DIR)/$(PKG_NAME_WPA_TOOLS)/wpa_supplicant/ clean;
	@make -C $(CURRENT_DIR)/cdemu/ clean;
	@rm -fr $(CURRENT_DIR)/$(PKG_NAME_LIBMIRAGE)/;
	@rm -rf $(PKG_NAME_WPA_RTK_TOOLS);
	@rm -rf $(PKG_BIN);
	@rm -rf $(PKG_BIN_INSTALL_DIR);
	@rm -rf $(PKG_NAME_WPA_TOOLS)/$(PKG_BIN);

info:
ifneq ($(RK_ENABLE_CDEMU),)
	@echo -e "$(C_YELLOW)-------------------------------------------------------------------------$(C_NORMAL)"
	@echo -e "$(C_YELLOW)-------------------------------------------------------------------------$(C_NORMAL)"
endif
