function aether()
{
    T=$(gettop)
    if [ -z "$T" ]; then
        echo "Error: source build/envsetup.sh first"
        return 1
    fi

    # Set device kalau ada argument
    if [ -n "$1" ]; then
        breakfast $1
    fi

    mka bacon
}
