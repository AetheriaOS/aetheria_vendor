PRODUCT_VERSION_MAJOR = 1
PRODUCT_VERSION_MINOR = 0

ifeq ($(AETHERIA_VERSION_APPEND_TIME_OF_DAY),true)
    AETHERIA_BUILD_DATE := $(shell date -u +%Y%m%d_%H%M%S)
else
    AETHERIA_BUILD_DATE := $(shell date -u +%Y%m%d)
endif

# Set AETHERIA_BUILDTYPE from the env RELEASE_TYPE, for jenkins compat
ifndef AETHERIA_BUILDTYPE
    ifdef RELEASE_TYPE
        # Starting with "AETHERIA_" is optional
        RELEASE_TYPE := $(shell echo $(RELEASE_TYPE) | sed -e 's|^AETHERIA_||g')
        AETHERIA_BUILDTYPE := $(RELEASE_TYPE)
    endif
endif

# Filter out random types, so it'll reset to UNOFFICIAL
ifeq ($(filter RELEASE NIGHTLY SNAPSHOT EXPERIMENTAL,$(AETHERIA_BUILDTYPE)),)
    AETHERIA_BUILDTYPE := UNOFFICIAL
    AETHERIA_EXTRAVERSION :=
endif
ifeq ($(AETHERIA_BUILDTYPE), UNOFFICIAL)
    ifneq ($(TARGET_UNOFFICIAL_BUILD_ID),)
        AETHERIA_EXTRAVERSION := -$(TARGET_UNOFFICIAL_BUILD_ID)
    endif
endif

AETHERIA_VERSION_SUFFIX := $(AETHERIA_BUILD_DATE)-$(AETHERIA_BUILDTYPE)$(AETHERIA_EXTRAVERSION)-$(AETHERIA_BUILD)

# Internal version
AETHERIA_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(AETHERIA_VERSION_SUFFIX)
# Display version
AETHERIA_DISPLAY_VERSION := $(PRODUCT_VERSION_MAJOR)-$(AETHERIA_VERSION_SUFFIX)

# AetheriaOS version properties
PRODUCT_PRODUCT_PROPERTIES += \
    ro.aetheria.version=$(AETHERIA_VERSION) \
    ro.aetheria.display.version=$(AETHERIA_DISPLAY_VERSION) \
    ro.aetheria.build.version=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR) \
    ro.aetheria.releasetype=$(AETHERIA_BUILDTYPE)

# Official devices check
AETHERIA_OFFICIAL_DEVICES_URL := https://raw.githubusercontent.com/AetheriaOS/aetheria_official_devices/main/$(AETHERIA_BUILD).json

AETHERIA_CHECK_OFFICIAL := $(shell curl -s -o /dev/null -w "%{http_code}" $(AETHERIA_OFFICIAL_DEVICES_URL))

ifeq ($(AETHERIA_CHECK_OFFICIAL), 200)
    AETHERIA_BUILDTYPE := OFFICIAL
else
    AETHERIA_BUILDTYPE := UNOFFICIAL
endif

# Maintainer
AETHERIA_MAINTAINER := $(shell curl -s $(AETHERIA_OFFICIAL_DEVICES_URL) | python3 -c "import sys,json; print(json.load(sys.stdin)['maintainer'])" 2>/dev/null || echo "Unknown")

PRODUCT_PRODUCT_PROPERTIES += \
    ro.aetheria.maintainer=$(AETHERIA_MAINTAINER) \
    ro.aetheria.buildtype=$(AETHERIA_BUILDTYPE)
