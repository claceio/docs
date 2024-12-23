#!/bin/sh

# Copyright (c) ClaceIO, LLC
# SPDX-License-Identifier: Apache-2.0

set -e

main() {
    LATEST_VERSION=$(curl -s https://api.github.com/repos/claceio/clace/releases/latest | grep tag_name | cut -d '"' -f 4)
    os=$(uname -s | tr '[:upper:]' '[:lower:]')
    arch=$(uname -m)

    if test $arch = "x86_64"; then
        arch="amd64"
    fi

    if test $arch = "aarch64"; then
        arch="arm64"
    fi

    version=${1:-${LATEST_VERSION}}
    target="clace-${version}-${os}-${arch}"
    clace_uri="https://github.com/claceio/clace/releases/download/$version/${target}.tar.gz"
    clace_install="${CL_HOME:-$HOME/clhome}"

    bin_dir="$clace_install/bin"
    tmp_dir="$clace_install/tmp"
    exe="$bin_dir/clace"

    mkdir -p "$bin_dir"
    mkdir -p "$tmp_dir"

    curl -q --fail --location --progress-bar --output "$tmp_dir/clace.tar.gz" "$clace_uri" || (echo "Error downloading $clace_uri"; exit 1)
    # extract to tmp dir so we don't open existing executable file for writing
    tar -C "$tmp_dir" -xzf "$tmp_dir/clace.tar.gz"
    chmod +x "$tmp_dir/${target}/clace"
    mv "$tmp_dir/${target}/clace" "$exe"
    rm "$tmp_dir/clace.tar.gz"

    echo ""
    echo "clace was installed successfully to $exe"

    if test ! -s $clace_install/clace.toml; then
        echo ""
        $exe password > $clace_install/clace.toml 
            echo ""
            echo "Password config has been setup, save the above password for app access with admin account"
    fi

    case $SHELL in
    /bin/zsh) shell_profile=".zshrc" ;;
    *) shell_profile=".bash_profile" ;;
    esac

    echo "export CL_HOME=\"$clace_install\"" > $bin_dir/clace.env
    echo "export PATH=\"\$CL_HOME/bin:\$PATH\"" >> $bin_dir/clace.env

    echo "Manually add the following to your \$HOME/$shell_profile (or similar). Also run it now for this session:"
    echo ""
    echo "  source \"$bin_dir/clace.env\""
    echo ""

    echo "See https://clace.io/docs/quickstart for quick start guide."
}

main "$1"
