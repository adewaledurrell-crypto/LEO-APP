#!/bin/bash

# WaowoShop - Build Script
# Ce script automatise le processus de build pour WaowoShop

set -e

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Variables
PROJECT_NAME="WaowoShop"
BUILD_TYPE="${1:-release}"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Fonctions
print_header() {
    echo -e "\n${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

check_flutter() {
    print_header "Vérification de Flutter"
    
    if ! command -v flutter &> /dev/null; then
        print_error "Flutter n'est pas installé!"
        exit 1
    fi
    
    flutter_version=$(flutter --version | head -n 1)
    print_success "Flutter trouvé: $flutter_version"
    
    flutter doctor
}

check_android_sdk() {
    print_header "Vérification d'Android SDK"
    
    if [ -z "$ANDROID_SDK_ROOT" ]; then
        print_warning "ANDROID_SDK_ROOT non défini"
        print_warning "Veuillez configurer: export ANDROID_SDK_ROOT=~/Android/Sdk"
    else
        print_success "ANDROID_SDK_ROOT trouvé: $ANDROID_SDK_ROOT"
    fi
}

clean_build() {
    print_header "Nettoyage des builds précédents"
    
    flutter clean
    print_success "Build nettoyé"
}

get_dependencies() {
    print_header "Installation des dépendances"
    
    flutter pub get
    print_success "Dépendances installées"
}

analyze_code() {
    print_header "Analyse du code"
    
    flutter analyze
    print_success "Analyse terminée"
}

format_code() {
    print_header "Formatage du code"
    
    flutter format lib/
    print_success "Code formaté"
}

run_tests() {
    print_header "Exécution des tests"
    
    if [ -d "test" ]; then
        flutter test
        print_success "Tests passés"
    else
        print_warning "Aucun répertoire 'test' trouvé"
    fi
}

build_apk() {
    local build_type=$1
    
    print_header "Build APK - Mode: $build_type"
    
    if [ "$build_type" == "release" ]; then
        flutter build apk --release
        APK_PATH="build/app/outputs/flutter-apk/app-release.apk"
    elif [ "$build_type" == "debug" ]; then
        flutter build apk --debug
        APK_PATH="build/app/outputs/flutter-apk/app-debug.apk"
    elif [ "$build_type" == "split" ]; then
        flutter build apk --split-per-abi --release
        APK_PATH="build/app/outputs/flutter-apk/"
    else
        print_error "Type de build inconnu: $build_type"
        exit 1
    fi
    
    if [ -f "$APK_PATH" ] || [ -d "$APK_PATH" ]; then
        print_success "APK builded avec succès"
    else
        print_error "Erreur lors du build APK"
        exit 1
    fi
}

build_appbundle() {
    print_header "Build App Bundle (pour Google Play)"
    
    flutter build appbundle --release
    BUNDLE_PATH="build/app/outputs/bundle/release/app-release.aab"
    
    if [ -f "$BUNDLE_PATH" ]; then
        print_success "App Bundle builded avec succès"
    else
        print_error "Erreur lors du build App Bundle"
        exit 1
    fi
}

get_apk_size() {
    print_header "Information de Taille"
    
    if [ -f "$APK_PATH" ]; then
        size=$(du -h "$APK_PATH" | cut -f1)
        echo -e "${GREEN}Taille APK: $size${NC}"
    elif [ -d "$APK_PATH" ]; then
        echo -e "${GREEN}Fichiers APK:${NC}"
        ls -lh "$APK_PATH"*.apk 2>/dev/null || echo "Aucun APK trouvé"
    fi
}

install_apk() {
    print_header "Installation sur appareil"
    
    devices=$(adb devices | grep -v "List" | grep "device$" | wc -l)
    
    if [ "$devices" -eq 0 ]; then
        print_error "Aucun appareil Android connecté!"
        exit 1
    fi
    
    if [ -f "$APK_PATH" ]; then
        adb install -r "$APK_PATH"
        print_success "APK installé avec succès"
    else
        print_error "Fichier APK non trouvé: $APK_PATH"
        exit 1
    fi
}

show_help() {
    echo -e "${BLUE}WaowoShop - Build Script${NC}"
    echo ""
    echo "Usage: ./build.sh [command] [options]"
    echo ""
    echo "Commands:"
    echo "  release         Build APK de release (défaut)"
    echo "  debug           Build APK de debug"
    echo "  split           Build APK divisés par architecture"
    echo "  bundle          Build App Bundle (Google Play)"
    echo "  full            Build complet (clean, analyze, test, build)"
    echo "  install         Installer APK sur appareil connecté"
    echo "  size            Afficher la taille APK"
    echo "  help            Afficher cette aide"
    echo ""
    echo "Examples:"
    echo "  ./build.sh                  # Build APK release"
    echo "  ./build.sh debug            # Build APK debug"
    echo "  ./build.sh full             # Build complet"
    echo "  ./build.sh bundle           # Build pour Google Play"
}

# Script principal
main() {
    local command="${1:-release}"
    
    case "$command" in
        release)
            check_flutter
            check_android_sdk
            clean_build
            get_dependencies
            analyze_code
            build_apk "release"
            get_apk_size
            print_success "Build release terminé!"
            ;;
        debug)
            check_flutter
            clean_build
            get_dependencies
            analyze_code
            build_apk "debug"
            get_apk_size
            print_success "Build debug terminé!"
            ;;
        split)
            check_flutter
            check_android_sdk
            clean_build
            get_dependencies
            build_apk "split"
            get_apk_size
            print_success "Build split terminé!"
            ;;
        bundle)
            check_flutter
            check_android_sdk
            clean_build
            get_dependencies
            analyze_code
            build_appbundle
            print_success "Build App Bundle terminé!"
            ;;
        full)
            check_flutter
            check_android_sdk
            clean_build
            get_dependencies
            analyze_code
            format_code
            run_tests
            build_apk "release"
            get_apk_size
            print_success "Build complet terminé!"
            ;;
        install)
            if [ -z "$APK_PATH" ]; then
                print_error "APK_PATH non défini. Exécutez d'abord un build."
                exit 1
            fi
            install_apk
            ;;
        size)
            get_apk_size
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            print_error "Commande inconnue: $command"
            echo ""
            show_help
            exit 1
            ;;
    esac
}

# Lancer le script
main "$@"
