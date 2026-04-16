#!/bin/bash

# ╔════════════════════════════════════════════════════════════════════╗
# ║         KoliseuServer Interactive Recompile Script v2.0            ║
# ╚════════════════════════════════════════════════════════════════════╝
#
# Description:
#   Interactive build script with real-time progress visualization
#   Shows live output of CMake configuration and compilation
#
# Usage:
#   ./recompile.sh [options] [vcpkg_base_path] [build_type] [parallel_jobs]
#
# Options:
#   -d, --debug    Força usar o preset linux-debug
#   -r, --release  Força usar o preset linux-release
#   -j, --jobs N   Define quantidade de jobs em paralelo (sobrescreve auto)
#   -h, --help     Mostra esta mensagem de ajuda
#
# Parameters:
#   vcpkg_base_path : Base directory containing vcpkg (default: $HOME)
#   build_type      : CMake preset to use (default: linux-release)
#                     Options: linux-release, linux-debug, linux-test
#   parallel_jobs   : Number of parallel compilation jobs (default: auto)
#                     Use "auto" for automatic detection or a number (1-16)
#                     Use lower numbers (1-4) if system freezes
#
# Examples:
#   ./recompile.sh                           # Auto: usa ~75% dos cores
#   ./recompile.sh --debug                   # Build linux-debug com defaults
#   ./recompile.sh --debug --jobs 4          # Debug forçando 4 cores
#   ./recompile.sh /home/shadowborn linux-debug 4  # Compatível com posição
#
# Features:
#   ✓ Real-time progress bar with percentage
#   ✓ Color-coded output (INFO, WARN, ERROR, VCPKG, BUILD)
#   ✓ Shows vcpkg package installation progress
#   ✓ Displays total build time
#   ✓ Automatic backup of previous build (.old)
#   ✓ Comprehensive logging (cmake_log.txt, build_log.txt)
#   ✓ Smart CPU usage (auto-detects WSL, leaves cores for system)
#   ✓ Reduced process priority (nice) to prevent system freeze
#
# ════════════════════════════════════════════════════════════════════

set -euo pipefail

usage() {
	cat <<EOF
Usage: ./recompile.sh [options] [vcpkg_base_path] [build_type] [parallel_jobs]

Options:
  -d, --debug       Force o preset linux-debug, ideal para gdb
  -r, --release     Force o preset linux-release
  -a, --asan        Force o preset linux-release-asan (detecção de memory leaks)
  -j, --jobs N      Define o número de jobs paralelos (equivalente ao 3º parâmetro)
  -h, --help        Mostra esta ajuda e sai

Exemplos:
  ./recompile.sh --debug
  ./recompile.sh --debug --jobs 4
  ./recompile.sh --asan
  ./recompile.sh /home/user linux-release
EOF
}

FORCED_PRESET=""
JOBS_OVERRIDE=""
POSITIONAL_ARGS=()
while [[ $# -gt 0 ]]; do
	case "$1" in
		-d|--debug)
			FORCED_PRESET="linux-debug"
			shift
			;;
		-r|--release)
			FORCED_PRESET="linux-release"
			shift
			;;
		-a|--asan)
			FORCED_PRESET="linux-release-asan"
			shift
			;;
		-j|--jobs)
			if [[ $# -lt 2 ]]; then
				echo "--jobs requer um valor" >&2
				exit 1
			fi
			JOBS_OVERRIDE="$2"
			shift 2
			;;
		-h|--help)
			usage
			exit 0
			;;
		--)
			shift
			POSITIONAL_ARGS+=("$@")
			break
			;;
		-*)
			echo "Opção desconhecida: $1" >&2
			usage
			exit 1
			;;
		*)
			POSITIONAL_ARGS+=("$1")
			shift
			;;
	esac
done

if [ ${#POSITIONAL_ARGS[@]} -eq 0 ]; then
	set --
else
	set -- "${POSITIONAL_ARGS[@]}"
fi

# Variáveis
VCPKG_BASE=${1:-"$HOME"}
VCPKG_PATH=$VCPKG_BASE/vcpkg/scripts/buildsystems/vcpkg.cmake
BUILD_TYPE_INPUT=${2:-"linux-release"}
PARALLEL_ARG=${3:-""}
BUILD_TYPE=${FORCED_PRESET:-$BUILD_TYPE_INPUT}
ARCHITECTURE=$(uname -m)
ARCHITECTUREVALUE=0

# Performance settings - deixa alguns cores livres para o sistema não travar
TOTAL_CORES=$(nproc)

# Detecta se está rodando no WSL
IS_WSL=0
if grep -qEi "(Microsoft|WSL)" /proc/version 2>/dev/null; then
	IS_WSL=1
fi

# Ajusta jobs baseado no ambiente
if [ $IS_WSL -eq 1 ]; then
	# WSL: usa 50% dos cores (mais conservador)
	AUTO_JOBS=$(( TOTAL_CORES / 2 ))
	AUTO_JOBS=$(( AUTO_JOBS > 0 ? AUTO_JOBS : 1 ))
else
	# Linux nativo: usa 75% dos cores ou deixe pelo menos 2 cores livres
	AUTO_JOBS=$(( TOTAL_CORES > 4 ? TOTAL_CORES - 2 : TOTAL_CORES * 3 / 4 ))
	AUTO_JOBS=$(( AUTO_JOBS > 0 ? AUTO_JOBS : 1 ))
fi

# Permite override manual via parâmetro posicional ou --jobs
if [[ -n "$JOBS_OVERRIDE" ]]; then
	PARALLEL_JOBS=$JOBS_OVERRIDE
else
	PARALLEL_JOBS=${PARALLEL_ARG:-$AUTO_JOBS}
fi

# Se o usuário passar "auto" explicitamente, use o valor auto-calculado
if [[ "$PARALLEL_JOBS" == "auto" ]]; then
	PARALLEL_JOBS=$AUTO_JOBS
fi

# Function to print information messages
info() {
	echo -e "\033[1;34m[INFO]\033[0m $1"
}

# Function to check if a command is available
check_command() {
	if ! command -v "$1" >/dev/null; then
		echo "The command '$1' is not available. Please install it and try again."
		exit 1
	fi
}

check_architecture() {
	if [[ $ARCHITECTURE == "aarch64"* ]]; then
		info "Detected ARM64 architecture: $ARCHITECTURE"
		ARCHITECTUREVALUE=1
	else
		info "Detected x86_64 architecture: $ARCHITECTURE"
	fi
}

# Function to configure Crystal Server
setup_koliseuserver() {
	if [ -d "build" ]; then
		info "Build directory already exists..."
		cd build
	else
		info "Creating build directory..."
		mkdir -p build && cd build
	fi
}

# Function to build Crystal Server
build_koliseuserver() {
	info "Configuring Crystal Server with CMake..."
	echo -e "\033[1;33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"

	if [[ $ARCHITECTUREVALUE == 1 ]]; then
		export VCPKG_FORCE_SYSTEM_BINARIES=1
		info "ARM64 detected - Setting VCPKG_FORCE_SYSTEM_BINARIES=1"
	fi

	# Run CMake configuration with live output
	if ! cmake -DCMAKE_TOOLCHAIN_FILE="$VCPKG_PATH" .. --preset "$BUILD_TYPE" 2>&1 | tee cmake_log.txt; then
		echo -e "\033[31m[ERROR]\033[0m CMake configuration failed!"
		return 1
	fi

	echo -e "\033[1;33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
	info "Starting the build process..."
	info "Using $PARALLEL_JOBS parallel jobs (total cores: $TOTAL_CORES)"
	info "This may take a while - installing dependencies and compiling..."
	echo -e "\033[1;33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
	echo ""

	local total_steps=0
	local progress=0
	local current_step=0
	local last_message=""
	local build_status=0

	# Build with live output and progress tracking
	# nice -n 10 reduz prioridade para não travar o sistema
	# -j $PARALLEL_JOBS limita jobs paralelos
	nice -n 10 cmake --build "$BUILD_TYPE" -j "$PARALLEL_JOBS" 2>&1 | tee build_log.txt | while IFS= read -r line; do
		# Check for build progress [N/M]
		if [[ $line =~ ^\[([0-9]+)/([0-9]+)\][[:space:]]*(.+)$ ]]; then
			current_step=${BASH_REMATCH[1]}
			total_steps=${BASH_REMATCH[2]}
			last_message=${BASH_REMATCH[3]}
			progress=$((current_step * 100 / total_steps))

			# Create progress bar
			local bar_width=40
			local filled=$((progress * bar_width / 100))
			local empty=$((bar_width - filled))
			local bar=$(printf "%${filled}s" | tr ' ' '█')$(printf "%${empty}s" | tr ' ' '░')

			printf "\r\033[1;32m[PROGRESS]\033[0m [%s] %3d%% (%d/%d) " "$bar" "$progress" "$current_step" "$total_steps"

		# Check for vcpkg installing packages
		elif [[ $line =~ [Ii]nstalling.*package ]]; then
			echo -e "\n\033[1;36m[VCPKG]\033[0m $line"

		# Check for vcpkg building packages
		elif [[ $line =~ [Bb]uilding.*package|[Bb]uilding[[:space:]].*:.*$ ]]; then
			echo -e "\n\033[1;35m[BUILD]\033[0m $line"

		# Check for errors
		elif [[ $line =~ [Ee]rror|[Ff]ailed ]]; then
			echo -e "\n\033[1;31m[ERROR]\033[0m $line"

		# Check for warnings
		elif [[ $line =~ [Ww]arning ]]; then
			echo -e "\n\033[1;33m[WARN]\033[0m $line"

		# Show important vcpkg status messages
		elif [[ $line =~ ^Starting\ package|^Elapsed\ time|^Total\ installed ]]; then
			echo -e "\n\033[1;34m[INFO]\033[0m $line"
		fi
	done

	build_status=${PIPESTATUS[0]}

	echo -e "\n"
	echo -e "\033[1;33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"

	if [[ $build_status -eq 0 ]]; then
		echo -e "\033[1;32m✓ Build completed successfully!\033[0m"
		return 0
	else
		echo -e "\033[1;31m✗ Build failed!\033[0m"
		echo -e "\033[1;33m[INFO]\033[0m Check build_log.txt for details"
		return 1
	fi
}

# Verify the generated executable (canary CMake drops it at repo root by default)
move_executable() {
	cd ..

	local target_name="canary"
	if [[ "$BUILD_TYPE" == "linux-debug" ]]; then
		target_name="canary-debug"
	fi

	if [ ! -f "./$target_name" ]; then
		echo -e "\033[31m[ERROR]\033[0m Executable not found at: ./$target_name"
		exit 1
	fi

	chmod +x "./$target_name"
	info "Build completed successfully!"
}

# Main function
main() {
	clear
	echo -e "\033[1;36m╔════════════════════════════════════════════════════════════════════╗\033[0m"
	echo -e "\033[1;36m║         KoliseuServer Build System - Interactive Mode             ║\033[0m"
	echo -e "\033[1;36m╚════════════════════════════════════════════════════════════════════╝\033[0m"
	echo ""
	if [ $IS_WSL -eq 1 ]; then
		info "Environment: WSL detected - using conservative settings"
	fi
	info "Performance Mode: Using $PARALLEL_JOBS/$TOTAL_CORES cores (reduced priority)"
	echo ""

	# Check if vcpkg toolchain file exists
	if [ ! -f "$VCPKG_PATH" ]; then
		echo -e "\033[31m[ERROR]\033[0m vcpkg toolchain file not found at: $VCPKG_PATH"
		echo -e "\033[33m[INFO]\033[0m Please install vcpkg or specify the correct path."
		echo -e "\033[33m[INFO]\033[0m Usage: $0 [vcpkg_base_path] [build_type]"
		echo -e "\033[33m[INFO]\033[0m Example: $0 /home/shadowborn linux-release"
		exit 1
	fi

	info "Using vcpkg from: $VCPKG_PATH"
	info "Build type: $BUILD_TYPE"
	echo ""

	check_command "cmake"
	check_architecture
	echo ""
	setup_koliseuserver
	echo ""

	local start_time=$(date +%s)

	if build_koliseuserver; then
		move_executable
		local end_time=$(date +%s)
		local elapsed=$((end_time - start_time))
		local minutes=$((elapsed / 60))
		local seconds=$((elapsed % 60))

		echo ""
		echo -e "\033[1;36m╔════════════════════════════════════════════════════════════════════╗\033[0m"
		echo -e "\033[1;36m║                    BUILD COMPLETED SUCCESSFULLY!                   ║\033[0m"
		echo -e "\033[1;36m╚════════════════════════════════════════════════════════════════════╝\033[0m"
		echo ""
		echo -e "\033[1;32m✓\033[0m Executable: \033[1;37m$(pwd)/canary\033[0m"
		echo -e "\033[1;32m✓\033[0m Build time: \033[1;37m${minutes}m ${seconds}s\033[0m"
		echo -e "\033[1;32m✓\033[0m Logs saved: \033[1;37mbuild/cmake_log.txt, build/build_log.txt\033[0m"
		echo ""
		echo -e "\033[1;33mTo run the server:\033[0m"
		echo -e "  \033[1;37m./canary\033[0m"
		echo ""
	else
		local end_time=$(date +%s)
		local elapsed=$((end_time - start_time))
		echo ""
		echo -e "\033[1;31m╔════════════════════════════════════════════════════════════════════╗\033[0m"
		echo -e "\033[1;31m║                         BUILD FAILED!                              ║\033[0m"
		echo -e "\033[1;31m╚════════════════════════════════════════════════════════════════════╝\033[0m"
		echo ""
		echo -e "\033[1;33m[INFO]\033[0m Time elapsed: ${elapsed}s"
		echo -e "\033[1;33m[INFO]\033[0m Check logs for details:"
		echo -e "  - build/cmake_log.txt (configuration)"
		echo -e "  - build/build_log.txt (compilation)"
		echo ""
		exit 1
	fi
}

main
