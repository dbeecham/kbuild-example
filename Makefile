# override quiet mode by calling "make Q="
Q=@


# include .config, but don't fail if the file does not exist.
# Any config in here can be overwritten by e.g. 
#   make Q= CONFIG_WEBSOCKET_HOST=\"ws.example.com\"
-include .config 


# can do something easy, like
# CFLAGS = -Og -g3
# CFLAGS += -DWEBSOCKET_HOST='$(CONFIG_WEBSOCKET_HOST)'
# ifeq ($(CONFIG_FFAST_MATH),y); 
#   CFLAGS += -ffast-math
# endif


# this is how the kernel does cflags, ldflags
ccflags-y = -Og -g3
ccflags-y += -DWEBSOCKET_HOST='$(CONFIG_WEBSOCKET_HOST)'
ccflags-$(CONFIG_FFAST_MATH) += -ffast-math

ldflags-y = -Og -g3
# ldlibs-$(CONFIG_USE_LIBPNG) += -lpng


# and how it does obj includes
obj-y := hw.o
obj-$(CONFIG_TEST1) += test1.o
obj-$(CONFIG_TEST2) += test2.o


# default target
hw: $(obj-y)


# kbuild/kconfig targets
nconfig:
	$(Q)kconfig-nconf Kconfig

menuconfig:
	$(Q)kconfig-mconf Kconfig

config:
	$(Q)kconfig-conf Kconfig

allnoconfig:
	$(Q)kconfig-conf --allnoconfig Kconfig

allyesconfig:
	$(Q)kconfig-conf --allyesconfig Kconfig

savedefconfig:
	$(Q)kconfig-conf --savedefconfig=$(CONFIG_DEFCONFIG) Kconfig

%_defconfig:
	$(Q)kconfig-conf --defconfig=configs/$@ Kconfig


# source paths
vpath %.c src/


# these implitic rules use ccflags-y, ldflags-y, and ldlibs-y directly; but
# they also provide the usual CFLAGS, LDFLAGS, and LDLIBS. You could add
# ccflags-y to CFLAGS first, which would make CFLAGS override ccflags-y...
%.o: %.c
	@printf "CC $@\n"
	$(Q)$(CC) -c $(ccflags-y) $(CFLAGS) $(CPPFLAGS) -o $@ $^
%: %.o
	@printf "$(LD_COLOR)LD$(NO_COLOR) $@\n"
	$(Q)$(CC) $(ldflags-y) $(LDFLAGS) -o $@ $^ $(LOADLIBES) $(ldlibs-y) $(LDLIBS)

