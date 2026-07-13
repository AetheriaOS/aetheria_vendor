function bloom()
{
    local codename=$1
    local variant=${2:-userdebug}

    if [ -z "$codename" ]; then
        echo "Usage: bloom <device-codename> [variant]"
        return 1
    fi

    lunch aetheria_${codename}-bp4a-${variant}
}
