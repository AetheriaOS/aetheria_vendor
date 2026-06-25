# Inherit mobile full common Lineage stuff
$(call inherit-product, vendor/aetheria/config/common_mobile_full.mk)

# Inherit tablet common Lineage stuff
$(call inherit-product, vendor/aetheria/config/tablet.mk)

$(call inherit-product, vendor/aetheria/config/wifionly.mk)
