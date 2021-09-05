#!/bin/bash

SRC_DIR=$(cd $(dirname $0) && pwd)
ROOT_UID=0

# Destination directory
  AURORAE_DIR="$HOME/.local/share/aurorae/themes"
  SCHEMES_DIR="$HOME/.local/share/color-schemes"
  PLASMA_DIR="$HOME/.local/share/plasma/desktoptheme"
  LOOKFEEL_DIR="$HOME/.local/share/plasma/look-and-feel"
  KVANTUM_DIR="$HOME/.config/Kvantum"
  WALLPAPER_DIR="$HOME/.local/share/wallpapers"

[[ ! -d ${AURORAE_DIR} ]] && mkdir -p ${AURORAE_DIR}
[[ ! -d ${SCHEMES_DIR} ]] && mkdir -p ${SCHEMES_DIR}
[[ ! -d ${PLASMA_DIR} ]] && mkdir -p ${PLASMA_DIR}
[[ ! -d ${LOOKFEEL_DIR} ]] && mkdir -p ${LOOKFEEL_DIR}
[[ ! -d ${KVANTUM_DIR} ]] && mkdir -p ${KVANTUM_DIR}
[[ ! -d ${WALLPAPER_DIR} ]] && mkdir -p ${WALLPAPER_DIR}

THEME_NAME=Vimix
COLOR_VARIANTS=('' '-Light' '-Dark')
THEME_VARIANTS=('' '-Doder' '-Beryl' '-Ruby' '-Amethyst')

usage() {
  printf "%s\n" "Usage: $0 [OPTIONS...]"
  printf "\n%s\n" "OPTIONS:"
  printf "  %-25s%s\n" "-d, --dest DIR" "Specify theme destination directory (Default: ${DEST_DIR})"
  printf "  %-25s%s\n" "-n, --name NAME" "Specify theme name (Default: ${THEME_NAME})"
  printf "  %-25s%s\n" "-t, --theme VARIANTS" "Specify hue theme variant(s) [standard|doder|beryl|ruby|amethyst] (Default: All variants)"
  printf "  %-25s%s\n" "-b, --blur" "Specify blur theme variants"
  printf "  %-25s%s\n" "-h, --help" "Show this help"
}

install() {
  local name=${1}
  local color=${2}
  local theme=${3}

  if [[ ${color} == '-Light' ]]; then
    local a_color='Light'
  fi

  if [[ ${color} == '-Dark' ]]; then
    local a_color='Dark'
  fi

  if [[ ${theme} == '-Doder' ]]; then
    local a_theme='Doder'
  fi

  if [[ ${theme} == '-Beryl' ]]; then
    local a_theme='Beryl'
  fi

  if [[ ${theme} == '-Ruby' ]]; then
    local a_theme='Ruby'
  fi

  if [[ ${theme} == '-Amethyst' ]]; then
    local a_theme='Amethyst'
  fi

  local AURORAE_THEME="${AURORAE_DIR}/${name}${color}${theme}"
  local PLASMA_THEME="${PLASMA_DIR}/${name}"
  local LOOKFEEL_THEME="${LOOKFEEL_DIR}/com.github.vinceliuice.${name}${color}${theme}"
  local SCHEMES_THEME="${SCHEMES_DIR}/${name}${a_color}${a_theme}.colors"

  [[ -d ${AURORAE_THEME} ]] && rm -rf ${AURORAE_THEME}
  [[ -d ${PLASMA_THEME} ]] && rm -rf ${PLASMA_THEME}
  [[ -d ${LOOKFEEL_THEME} ]] && rm -rf ${LOOKFEEL_THEME}
  [[ -d ${SCHEMES_THEME} ]] && rm -rf ${SCHEMES_THEME}

  if [[ ${color} != '-Light' ]]; then
    cp -rf ${SRC_DIR}/aurorae/${name}${theme}                                           ${AURORAE_DIR}
  else
    cp -rf ${SRC_DIR}/aurorae/${name}-Light                                             ${AURORAE_DIR}
  fi

  cp -rf ${SRC_DIR}/color-schemes/${name}${a_color}${a_theme}.colors                    ${SCHEMES_DIR}
  cp -rf ${SRC_DIR}/Kvantum/*                                                           ${KVANTUM_DIR}

  if [[ ${theme} == '-Beryl' ]]; then
    rm -rf                                                                              ${KVANTUM_DIR}/VimixBeryl
    cp -rf ${SRC_DIR}/Kvantum/VimixDoder                                                ${KVANTUM_DIR}/VimixBeryl
    mv ${KVANTUM_DIR}/VimixBeryl/VimixDoder.kvconfig                                    ${KVANTUM_DIR}/VimixBeryl/VimixBeryl.kvconfig
    mv ${KVANTUM_DIR}/VimixBeryl/VimixDoderDark.kvconfig                                ${KVANTUM_DIR}/VimixBeryl/VimixBerylDark.kvconfig
    mv ${KVANTUM_DIR}/VimixBeryl/VimixDoder.svg                                         ${KVANTUM_DIR}/VimixBeryl/VimixBeryl.svg
    mv ${KVANTUM_DIR}/VimixBeryl/VimixDoderDark.svg                                     ${KVANTUM_DIR}/VimixBeryl/VimixBerylDark.svg
    sed -i "s/#4285f4/#2eb398/g"                                                        ${KVANTUM_DIR}/VimixBeryl/*
  fi

  if [[ ${theme} == '-Amethyst' ]]; then
    rm -rf                                                                              ${KVANTUM_DIR}/VimixAmethyst
    cp -rf ${SRC_DIR}/Kvantum/VimixRuby                                                 ${KVANTUM_DIR}/VimixAmethyst
    mv ${KVANTUM_DIR}/VimixAmethyst/VimixRuby.kvconfig                                  ${KVANTUM_DIR}/VimixAmethyst/VimixAmethyst.kvconfig
    mv ${KVANTUM_DIR}/VimixAmethyst/VimixRubyDark.kvconfig                              ${KVANTUM_DIR}/VimixAmethyst/VimixAmethystDark.kvconfig
    mv ${KVANTUM_DIR}/VimixAmethyst/VimixRuby.svg                                       ${KVANTUM_DIR}/VimixAmethyst/VimixAmethyst.svg
    mv ${KVANTUM_DIR}/VimixAmethyst/VimixRubyDark.svg                                   ${KVANTUM_DIR}/VimixAmethyst/VimixAmethystDark.svg
    sed -i "s/#f0544c/#ab47bc/g"                                                        ${KVANTUM_DIR}/VimixAmethyst/*
  fi

  rm -rf                                                                                ${WALLPAPER_DIR}/Vimix*
  cp -rf ${SRC_DIR}/wallpaper/Vimix*                                                    ${WALLPAPER_DIR}

  cp -rf ${SRC_DIR}/plasma/desktoptheme/${name}                                         ${PLASMA_DIR}
  cp -rf ${SRC_DIR}/plasma/look-and-feel/com.github.vinceliuice.${name}${color}${theme} ${LOOKFEEL_DIR}
}

while [[ $# -gt 0 ]]; do
  case "${1}" in
    -d|--dest)
      dest="${2}"
      if [[ ! -d "${dest}" ]]; then
        echo "ERROR: Destination directory does not exist."
        exit 1
      fi
      shift 2
      ;;
    -n|--name)
      name="${2}"
      shift 2
      ;;
    -t|--theme)
      shift
      for theme in "${@}"; do
        case "${theme}" in
          standard)
            themes+=("${THEME_VARIANTS[0]}")
            shift 1
            ;;
          doder)
            themes+=("${THEME_VARIANTS[1]}")
            shift 1
            ;;
          beryl)
            themes+=("${THEME_VARIANTS[2]}")
            shift 1
            ;;
          ruby)
            themes+=("${THEME_VARIANTS[3]}")
            shift 1
            ;;
          amethyst)
            themes+=("${THEME_VARIANTS[4]}")
            shift 1
            ;;
          -*|--*)
            break
            ;;
          *)
            echo "ERROR: Unrecognized thin variant '$1'."
            echo "Try '$0 --help' for more information."
            exit 1
            ;;
        esac
      done
      ;;
    -c|--color)
      shift
      for color in "${@}"; do
        case "${color}" in
          standard)
            colors+=("${COLOR_VARIANTS[0]}")
            shift 1
            ;;
          light)
            colors+=("${COLOR_VARIANTS[1]}")
            shift 1
            ;;
          dark)
            colors+=("${COLOR_VARIANTS[2]}")
            shift 1
            ;;
          -*|--*)
            break
            ;;
          *)
            echo "ERROR: Unrecognized color variant '$1'."
            echo "Try '$0 --help' for more information."
            exit 1
            ;;
        esac
      done
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "ERROR: Unrecognized installation option '$1'."
      echo "Try '$0 --help' for more information."
      exit 1
      ;;
  esac
done

echo "Installing '${name:-${THEME_NAME}} kde themes'..."

for color in "${colors[@]:-${COLOR_VARIANTS[@]}}"; do
  for theme in "${themes[@]:-${THEME_VARIANTS[@]}}"; do
    install "${name:-${THEME_NAME}}" "${color}" "${theme}"
  done
done

echo "Install finished..."
