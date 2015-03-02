# Include the common stuff
include $(LOCAL_PATH)/common.mk

# List of modules to include in the the add-on system image
#PRODUCT_PACKAGES += 

# The name of this add-on (for the SDK)
PRODUCT_SDK_ADDON_NAME := alpha_sdk_addon

# Copy the following files for this add-on's SDK
PRODUCT_SDK_ADDON_COPY_FILES := \
	$(LOCAL_PATH)/sdk_addon/source.properties:source.properties \
	$(LOCAL_PATH)/sdk_addon/manifest.ini:manifest.ini \
	$(LOCAL_PATH)/sdk_addon/hardware.ini:hardware.ini

# The add-on system image doesn't explicitly copy the kernel for us
PRODUCT_SDK_ADDON_COPY_FILES += $(LOCAL_KERNEL):images/x86/kernel-qemu

# Copy the jar files for the libraries (APIs) exposed in this add-on's SDK
PRODUCT_SDK_ADDON_COPY_MODULES := \
	com.marakana.android.lib.log:libs/com.marakana.android.lib.log.jar \
	com.marakana.android.service.log:libs/com.marakana.android.service.log.jar

PRODUCT_SDK_ADDON_STUB_DEFS := $(LOCAL_PATH)/sdk_addon/alpha_sdk_addon_stub_defs.txt

# Req'd on Lollipop+, system images are built as a separate package
PRODUCT_SDK_ADDON_SYS_IMG_SOURCE_PROP := $(LOCAL_PATH)/sdk_addon/sys-img/source.prop_template

# Define the name of the documentation to generate for this add-on's SDK
PRODUCT_SDK_ADDON_DOC_MODULES := \
	com.marakana.android.service.log_doc 

# Define a config file for the emulated acceleration
BOARD_EGL_CFG := device/generic/goldfish/opengl/system/egl/egl.cfg

# This add-on extends the default sdk product.
$(call inherit-product, $(SRC_TARGET_DIR)/product/sdk_x86.mk)

# The name of this add-on (for the build system)
# Use 'make PRODUCT-<PRODUCT_NAME>-sdk_addon' to build the an add-on, 
# so in this case, we would run 'make PRODUCT-alpha_sdk_addon-sdk_addon'
PRODUCT_NAME := alpha_sdk_addon
PRODUCT_DEVICE := alpha
PRODUCT_MODEL := NewCircle Alpha SDK Addon Image for Emulator
