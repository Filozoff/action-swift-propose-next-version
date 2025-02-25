#!/usr/bin/env bash

set -Eeuo pipefail
trap 'error_handler ${FUNCNAME-main context} ${LINENO} $?' ERR

# CONSTANTS

readonly CALL_DIR="$PWD"
readonly MANIFEST_NAME="Package.swift"
readonly SCRIPT_NAME=$(basename -s ".sh" "$0")
readonly TEMP_DIRECTORY="tmp$RANDOM"

# FUNCTIONS

function main() {
    cat <<< "1.0.0"
}

# ENTRY POINT

while [[ $# -gt 0 ]]; do
    case $1 in
        # Device for which public interface is created. Use value supported by `-destination` argument in `xcodebuild archive`.
        # E.g. `platform=iOS Simulator,name=iPhone 14,OS=17.0`.
        -d|--device)
            DESTINATION=${2}
            shift 2
        ;;
        # Derived data path (optional).
        -r|--derived-data-path)
            DERIVED_DATA_PATH=${2}
            ARCHIVE_PATH="$DERIVED_DATA_PATH/archive"
            shift 2
        ;;
        # Package scheme name. For packages with multiple targets, it may be required to add `-Package` suffix.
        # Example: your package is named `ClientService` and has two targets inside: `ClientServiceDTOs` and `ClientServiceAPI`.
        # Then, your target would be `ClientService-Package`.
        -s|--scheme)
            SCHEME=${2}
            shift 2
        ;;
        *)
            echo "Unknown parameter: '${1}'. Please use supported parameters: '-d|--device', '-r|--derived-data-path', '-s|--scheme'."
            exit 1
        ;;
    esac
done

main
