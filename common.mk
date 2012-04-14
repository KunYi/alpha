MY_PATH := $(LOCAL_PATH)/../alpha

include $(call all-makefiles-under,$(MY_PATH))

# Enable our custom kernel
LOCAL_KERNEL := $(MY_PATH)/kernel
PRODUCT_COPY_FILES += $(LOCAL_KERNEL):kernel

# Copy our init and ueventd configuration files
PRODUCT_COPY_FILES += $(MY_PATH)/init.marakanaalphaboard.rc:root/init.marakanaalphaboard.rc
PRODUCT_COPY_FILES += $(MY_PATH)/ueventd.marakanaalphaboard.rc:root/ueventd.marakanaalphaboard.rc

PRODUCT_PACKAGES += libmrknlog
PRODUCT_PACKAGES += mrknlog
PRODUCT_PACKAGES += mrknlogd

PRODUCT_PACKAGES += \
	com.marakana.android.lib.log \
	com.marakana.android.lib.log.xml \
	libmrknlog_jni

PRODUCT_PACKAGES += \
	com.marakana.android.service.log \
	com.marakana.android.service.log.xml

PRODUCT_PACKAGES += MrknLogService

