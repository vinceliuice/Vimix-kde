#!/bin/bash

SRC_DIR=$(cd $(dirname $0) && pwd)

PLASMA_VERSION=$(plasmashell --version | awk '{ print $2 }')
PLASMA_LIMIT_VERSION='5.18'

# # if the plasma is 5.18.3 ou higher, the install path is set to /usr/share/color-schemes/
if [[ $(awk 'BEGIN {print ('$PLASMA_VERSION' >= '$PLASMA_LIMIT_VERSION') ? "1" : "0"}') == '1' ]]; then
    SCHEMES_DIR="/usr/share/color-schemes"
# # if lower '5.18', $HOME/.local/share/color-schemes.
elif [[ $(awk 'BEGIN {print ('$PLASMA_VERSION' <= '$PLASMA_LIMIT_VERSION') ? "1" : "0"}') == '1' ]]; then
# # If there is a per-user path to the 'color-schemes' folder, this script MUST be updated!
    SCHEMES_DIR="$HOME/.local/share/color-schemes"
fi
 
AURORAE_DIR="$HOME/.local/share/aurorae/themes"
SCHEMES_DIR="$HOME/.local/share/color-schemes"
PLASMA_DIR="$HOME/.local/share/plasma/desktoptheme"
LOOKFEEL_DIR="$HOME/.local/share/plasma/look-and-feel"
KVANTUM_DIR="$HOME/.config/Kvantum"

[[ ! -d ${AURORAE_DIR} ]] && sudo mkdir -p ${AURORAE_DIR}
[[ ! -d ${SCHEMES_DIR} ]] && sudo mkdir -p ${SCHEMES_DIR}
[[ ! -d ${PLASMA_DIR} ]] && sudo mkdir -p ${PLASMA_DIR}
[[ ! -d ${LOOKFEEL_DIR} ]] && sudo mkdir -p ${LOOKFEEL_DIR}
[[ ! -d ${KVANTUM_DIR} ]] && sudo mkdir -p ${KVANTUM_DIR}

THEME_NAME=Vimix
COLOR_VARIANTS=('' '-Light' '-Dark')
THEME_VARIANTS=('' '-Doder' '-Beryl' '-Ruby' '-Amethyst')

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
  local PLASMA_THEME="${PLASMA_DIR}/${name}${theme}"
  local LOOKFEEL_THEME="${LOOKFEEL_DIR}/com.github.vinceliuice.${name}${color}${theme}"
  local SCHEMES_THEME="${SCHEMES_DIR}/${name}${a_color}${a_theme}.colors"
  local KVANTUM_THEME="${KVANTUM_DIR}/${name}${color}${theme}"

  [[ -d ${AURORAE_THEME} ]] && rm -rf ${AURORAE_THEME}
  [[ -d ${PLASMA_THEME} ]] && rm -rf ${PLASMA_THEME}
  [[ -d ${LOOKFEEL_THEME} ]] && rm -rf ${LOOKFEEL_THEME}
  [[ -d ${SCHEMES_THEME} ]] && rm -rf ${SCHEMES_THEME}
  [[ -d ${KVANTUM_THEME} ]] && rm -rf ${KVANTUM_THEME}

  if [[ ${color} != '-Light' ]]; then
    cp -ur ${SRC_DIR}/aurorae/${name}${theme}                                           ${AURORAE_DIR}
  else
    cp -ur ${SRC_DIR}/aurorae/${name}-Light                                             ${AURORAE_DIR}
  fi

  cp -ur ${SRC_DIR}/color-schemes/${name}${a_color}${a_theme}.colors                    ${SCHEMES_DIR}
  cp -ur ${SRC_DIR}/Kvantum/${name}${color}${theme}                                     ${KVANTUM_DIR}
  cp -ur ${SRC_DIR}/plasma/desktoptheme/${name}${theme}                                 ${PLASMA_DIR}
  cp -ur ${SRC_DIR}/plasma/desktoptheme/icons                                           ${PLASMA_THEME}
  cp -ur ${SRC_DIR}/color-schemes/${name}Dark${a_theme}.colors                          ${PLASMA_THEME}/colors
  cp -ur ${SRC_DIR}/plasma/look-and-feel/com.github.vinceliuice.${name}${color}${theme} ${LOOKFEEL_DIR}

  [[ ${blur} = 'true' ]] && \
  cp -r ${SRC_DIR}/plasma/desktoptheme/${name}${theme}-Blur/*                           ${PLASMA_THEME}/
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
    -b|--blur)
      blur='true'
      shift 1
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
