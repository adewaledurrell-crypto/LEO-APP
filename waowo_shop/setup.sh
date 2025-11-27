#!/bin/bash

# WaowoShop - Script d'Installation et de Build
# Ce script automatise le processus de configuration et de build de l'application

set -e

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║           WaowoShop - E-Commerce Mobile App                 ║"
echo "║                    Installation & Build                      ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

# Couleurs pour l'output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fonctions utiles
print_section() {
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

# Vérifier les prérequis
check_requirements() {
    print_section "Vérification des Prérequis"
    
    # Vérifier Flutter
    if ! command -v flutter &> /dev/null; then
        print_error "Flutter n'est pas installé"
        echo "Téléchargez-le depuis: https://flutter.dev/docs/get-started/install"
        exit 1
    fi
    print_success "Flutter trouvé"
    
    # Vérifier Dart
    if ! command -v dart &> /dev/null; then
        print_error "Dart n'est pas installé"
        exit 1
    fi
    print_success "Dart trouvé"
    
    # Vérifier git
    if ! command -v git &> /dev/null; then
        print_error "Git n'est pas installé"
        exit 1
    fi
    print_success "Git trouvé"
    
    echo ""
}

# Initialiser le projet
setup_project() {
    print_section "Configuration du Projet"
    
    # Nettoyer les builds précédentes
    print_info "Nettoyage de la build précédente..."
    flutter clean > /dev/null 2>&1 || true
    print_success "Nettoyé"
    
    # Récupérer les dépendances
    print_info "Installation des dépendances..."
    flutter pub get
    print_success "Dépendances installées"
    
    echo ""
}

# Générer le code
generate_code() {
    print_section "Génération du Code"
    
    print_info "Exécution du build_runner..."
    flutter pub run build_runner build --delete-conflicting-outputs 2>/dev/null || true
    print_success "Code généré"
    
    echo ""
}

# Vérifier les appareils
check_devices() {
    print_section "Appareils Disponibles"
    
    if flutter devices | grep -q "no device found"; then
        print_error "Aucun appareil trouvé"
        echo "Connectez un appareil Android ou lancez un émulateur"
        echo ""
        echo "Pour créer un émulateur:"
        echo "  flutter emulators --create --name my_emulator"
        echo "  flutter emulators --launch my_emulator"
        return 1
    else
        flutter devices
        return 0
    fi
}

# Build et installation
build_and_install() {
    local build_type="${1:-release}"
    
    print_section "Build de l'APK ($build_type)"
    
    if [ "$build_type" = "debug" ]; then
        print_info "Build en mode debug..."
        flutter build apk --debug
        APK_PATH="build/app/outputs/flutter-apk/app-debug.apk"
    else
        print_info "Build en mode release..."
        flutter build apk --release
        APK_PATH="build/app/outputs/flutter-apk/app-release.apk"
    fi
    
    if [ -f "$APK_PATH" ]; then
        SIZE=$(du -h "$APK_PATH" | cut -f1)
        print_success "APK généré avec succès!"
        echo "Chemin: $APK_PATH"
        echo "Taille: $SIZE"
    else
        print_error "Erreur lors de la génération de l'APK"
        exit 1
    fi
    
    echo ""
}

# Menu principal
show_menu() {
    echo ""
    echo "Que voulez-vous faire?"
    echo ""
    echo "  1) Configuration complète (setup + build release)"
    echo "  2) Configuration complète (setup + build debug)"
    echo "  3) Setup uniquement (sans build)"
    echo "  4) Build release (sans setup)"
    echo "  5) Build debug (sans setup)"
    echo "  6) Lancer sur un appareil"
    echo "  7) Analyser le code"
    echo "  8) Exécuter les tests"
    echo "  0) Quitter"
    echo ""
    read -p "Sélection: " choice
    
    case $choice in
        1)
            check_requirements
            setup_project
            generate_code
            build_and_install "release"
            ;;
        2)
            check_requirements
            setup_project
            generate_code
            build_and_install "debug"
            ;;
        3)
            check_requirements
            setup_project
            generate_code
            ;;
        4)
            check_requirements
            build_and_install "release"
            ;;
        5)
            check_requirements
            build_and_install "debug"
            ;;
        6)
            print_section "Lancer sur Appareil"
            if check_devices; then
                print_info "Lancement de l'application..."
                flutter run -v
            fi
            ;;
        7)
            print_section "Analyse du Code"
            flutter analyze
            ;;
        8)
            print_section "Tests"
            flutter test
            ;;
        0)
            echo "Au revoir!"
            exit 0
            ;;
        *)
            print_error "Sélection invalide"
            show_menu
            ;;
    esac
}

# Main
main() {
    # Si des arguments sont passés, exécuter en mode batch
    if [ $# -gt 0 ]; then
        case "$1" in
            setup)
                check_requirements
                setup_project
                generate_code
                print_success "Setup terminé!"
                ;;
            build)
                build_type="${2:-release}"
                check_requirements
                build_and_install "$build_type"
                ;;
            run)
                check_requirements
                setup_project
                print_info "Lancement de l'application..."
                flutter run -v
                ;;
            *)
                print_error "Commande inconnue: $1"
                echo "Commandes disponibles: setup, build [debug|release], run"
                exit 1
                ;;
        esac
    else
        # Mode interactif
        show_menu
    fi
}

# Lancer le script
main "$@"
