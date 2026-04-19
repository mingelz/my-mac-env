#!/bin/bash

# ==============================================================================
# macOS Clean Script (Final Enhanced Version)
# Description: Safely cleans user-level caches using native tools where possible.
# Warning: This script deletes data. Please review before running.
# ==============================================================================

set -euo pipefail # Exit on error, undefined vars, and pipe failures

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
DRY_RUN=false

# Function to print info
info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

# Function to print warning
warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

# Function to print error
error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

# Function to print action
action() {
    if [ "$DRY_RUN" = true ]; then
        echo -e "${BLUE}[DRY-RUN]${NC} Would execute: $1"
    else
        echo -e "${BLUE}[ACTION]${NC} Executing: $1"
    fi
}

# Safe remove function for specific paths
safe_rm() {
    local path="$1"
    if [ -e "$path" ] || [ -L "$path" ]; then
        if [ "$DRY_RUN" = true ]; then
            echo -e "${BLUE}[DRY-RUN]${NC} Would delete: $path"
        else
            echo -e "${BLUE}[ACTION]${NC} Deleting: $path"
            rm -rf "$path"
        fi
    fi
}

# Safe remove for glob patterns
safe_rm_glob() {
    local pattern="$1"
    shopt -s nullglob
    for path in $pattern; do
        if [ "$DRY_RUN" = true ]; then
            echo -e "${BLUE}[DRY-RUN]${NC} Would delete: $path"
        else
            echo -e "${BLUE}[ACTION]${NC} Deleting: $path"
            rm -rf "$path"
        fi
    done
    shopt -u nullglob
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run|-n)
            DRY_RUN=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [--dry-run]"
            exit 0
            ;;
        *)
            error "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Check if running as root
if [ "$(whoami)" == "root" ]; then
    error "Do NOT run this script as root."
    exit 1
fi

# Confirm action
if [ "$DRY_RUN" = false ]; then
    echo -e "${RED}WARNING: This script will permanently delete history, caches, and temporary files.${NC}"
    read -p "Are you sure you want to proceed? (y/N): " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        info "Aborted."
        exit 0
    fi
else
    warn "Running in DRY-RUN mode. No files will be deleted."
fi

info "Starting cleanup..."

# ------------------------------------------------------------------------------
# 1. Homebrew Cleanup
# ------------------------------------------------------------------------------
if command -v brew &> /dev/null; then
    info "Cleaning Homebrew..."
    if [ "$DRY_RUN" = false ]; then
        brew cleanup --prune=all 2>/dev/null || warn "Homebrew cleanup encountered issues."
    else
        action "brew cleanup --prune=all"
    fi
fi

# ------------------------------------------------------------------------------
# 2. Shell History
# ------------------------------------------------------------------------------
info "Cleaning shell history..."
safe_rm ~/.bash_history
safe_rm ~/.zsh_history
safe_rm ~/.zsh_sessions
safe_rm ~/.bash_sessions
safe_rm ~/.sh_history
safe_rm ~/.python_history # Python REPL history

# ------------------------------------------------------------------------------
# 3. Node.js / NPM (Using Native Command)
# ------------------------------------------------------------------------------
info "Cleaning Node.js / NPM..."
if command -v npm &> /dev/null; then
    if [ "$DRY_RUN" = false ]; then
        # Native command is safer than rm -rf ~/.npm
        npm cache clean --force 2>/dev/null || warn "NPM cache clean failed."
    else
        action "npm cache clean --force"
    fi
fi
# Clean specific node temp files that npm cache clean might miss
safe_rm ~/.node-gyp
safe_rm ~/.node_repl_history

# ------------------------------------------------------------------------------
# 4. Python / Pip (Using Native Command)
# ------------------------------------------------------------------------------
info "Cleaning Python / Pip..."
if command -v pip &> /dev/null; then
    if [ "$DRY_RUN" = false ]; then
        # Native command handles different OS paths correctly
        pip cache purge 2>/dev/null || warn "Pip cache purge failed (might be old version)."
    else
        action "pip cache purge"
    fi
elif command -v pip3 &> /dev/null; then
    if [ "$DRY_RUN" = false ]; then
        pip3 cache purge 2>/dev/null || warn "Pip3 cache purge failed."
    else
        action "pip3 cache purge"
    fi
else
    warn "Pip not found. Skipping native cache clean."
fi

# Fallback: If pip cache purge is not available (very old pip) or fails,
# we can manually clean known paths.
# Note: Only do this if we really want to be thorough, but native command is preferred.
# safe_rm ~/Library/Caches/pip
# safe_rm ~/.cache/pip

# ------------------------------------------------------------------------------
# 5. Ruby / Gem
# ------------------------------------------------------------------------------
info "Cleaning Ruby / Gem..."
if command -v gem &> /dev/null; then
    if [ "$DRY_RUN" = false ]; then
        # Removes old versions of gems from the installation directory
        gem cleanup 2>/dev/null || warn "Gem cleanup encountered issues."
    else
        action "gem cleanup"
    fi

    # Manually clean gem build cache (no native single command for this)
    safe_rm_glob ~/.gem/ruby/*/cache
    safe_rm ~/.bundle/cache
else
    # Even if gem command is missing, clean folders if they exist
    safe_rm_glob ~/.gem/ruby/*/cache
    safe_rm ~/.bundle/cache
fi

# ------------------------------------------------------------------------------
# 6. Vim/Neovim
# ------------------------------------------------------------------------------
info "Cleaning Vim/Neovim..."
safe_rm ~/.viminfo
safe_rm ~/.vim/undo
safe_rm ~/.local/share/nvim/swap
safe_rm ~/.local/share/nvim/undo

if [ "$DRY_RUN" = false ]; then
    mkdir -p ~/.vim/undo ~/.local/share/nvim/swap ~/.local/share/nvim/undo
fi

# ------------------------------------------------------------------------------
# 7. General macOS Caches
# ------------------------------------------------------------------------------
info "Cleaning general macOS user caches..."
# Warning: This is aggressive. Some apps may need to re-download assets.
safe_rm ~/Library/Caches/*

# Linux-style cache folder (used by some cross-platform apps like Electron, Docker Desktop sometimes)
safe_rm ~/.cache

# Java/SVN leftovers
safe_rm ~/.oracle_jre_usage
# safe_rm ~/.subversion # Uncomment if you want to clear SVN auth

# ------------------------------------------------------------------------------
# Finish
# ------------------------------------------------------------------------------
if [ "$DRY_RUN" = false ]; then
    info "Cleanup completed successfully."
    info "Note: Restart your terminal to refresh history state."
else
    info "Dry run finished."
fi
