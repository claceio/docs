#!/bin/sh

# Copyright (c) ClaceIO, LLC
# SPDX-License-Identifier: Apache-2.0

set -e

main() {
    LATEST_VERSION=$(curl -sS https://api.github.com/repos/claceio/clace/releases/latest | grep tag_name | cut -d '"' -f 4)
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
    mv -f "$tmp_dir/${target}/clace" "$exe"
    rm -f "$tmp_dir/clace.tar.gz"

    if test ! -s $clace_install/clace.toml; then
        echo ""
        echo "********** Initializing \"admin\" user **********"
        $exe password > $clace_install/clace.toml 
        echo "************ Save this password ***************"
    fi

    profile_file="$HOME/.profile"
    if [ "$SHELL_NAME" = "zsh" ]; then
        profile_file="$HOME/.zshrc"
    elif [ "$SHELL_NAME" = "bash" ]; then
        profile_file="$HOME/.bash_profile"
    fi

    export_cmd="export PATH=\"$bin_dir:\$PATH\""
    if ! grep -Fxq "$export_cmd" "$profile_file" 2>/dev/null; then
        echo "$export_cmd" >> "$profile_file"
    fi

    case ":$PATH:" in
       *":$bin_dir:"*) ;;
       *) export PATH=$bin_dir:$PATH ;;
    esac

    echo "$bin_dir added to PATH. Run \"clace server start\" to start the server."
    echo "See https://clace.io/docs/quickstart for quick start guide."
}

main "$1"
