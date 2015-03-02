# Include all makefiles in sub-directories (one level deep)
include $(call all-subdir-makefiles)

# These are the hardware-specific features
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/handheld_core_hardware.xml:system/etc/permissions/handheld_core_hardware.xml

# Enable overlays
DEVICE_PACKAGE_OVERLAYS := $(MY_PATH)/overlay

# Enable our custom kernel
LOCAL_KERNEL := $(LOCAL_PATH)/kernel
PRODUCT_COPY_FILES += $(LOCAL_KERNEL):kernel

# Copy our init, ueventd, and fstab configuration files to the root
# file system (ramdisk.img -> boot.img)
PRODUCT_COPY_FILES += $(LOCAL_PATH)/init.goldfish.rc:root/init.goldfish.rc

# Include all packages from this file
include $(LOCAL_PATH)/packages.mk
