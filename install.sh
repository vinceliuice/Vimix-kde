#!/bin/bash

SRC_DIR=$(cd $(dirname $0) && pwd)

AURORAE_DIR="$HOME/.local/share/aurorae/themes"
SCHEMES_DIR="$HOME/.local/share/color-schemes"
PLASMA_DIR="$HOME/.local/share/plasma/desktoptheme"
LOOKFEEL_DIR="$HOME/.local/share/plasma/look-and-feel"
KVANTUM_DIR="$HOME/.config/Kvantum"

THEME_NAME=Vimix
COLOR_VARIANTS=('' '-Dark')
THEME_VARIANTS=('' '-Doder' '-Beryl' '-Ruby')

install() {
  local name=${1}
  local theme=${2}
  local color=${3}

  local AURORAE_THEME=${AURPRAE_DIR}/${name}${theme}
  local PLASMA_THEME=${PLASMA_DIR}/${name}${theme}
  local LOOKFEEL_THEME=${LOOKFEEL_DIR}/${name}${theme}
  local SCHEMES_THEME=${SCHEMES_DIR}/${name}${theme}${color}.colors
  local KVANTUM_THEME=${KVANTUM_DIR}/${name}${theme}

  [[ -d ${AURORAE_THEME} ]] && rm -rf ${AURORAE_THEME}
  [[ -d ${PLASMA_THEME} ]] && rm -rf ${PLASMA_THEME}
  [[ -d ${LOOKFEEL_THEME} ]] && rm -rf ${LOOKFEEL_THEME}
  [[ -d ${SCHEMES_THEME} ]] && rm -rf ${SCHEMES_THEME}
  [[ -d ${KVANTUM_THEME} ]] && rm -rf ${KVANTUM_THEME}

  cp -ur ${SRC_DIR}/aurorae/${name}${theme}                                          ${AURORAE_DIR}
  cp -ur ${SRC_DIR}/color-schemes/${name}${theme}${color}.colors                     ${SCHEMES_DIR}
  cp -ur ${SRC_DIR}/Kvantum/${name}${theme}                                          ${KVANTUM_DIR}
  cp -ur ${SRC_DIR}/plasma/desktoptheme/${name}${theme}                              ${PLASMA_DIR}
  cp -ur ${SRC_DIR}/color-schemes/${name}${theme}-Dark.colors                        ${PLASMA_THEME}/colors
  cp -ur ${SRC_DIR}/plasma/look-and-feel/com.github.vinceliuice.${name}${theme}      ${LOOKFEEL_DIR}
}

echo "Installing '${name:-${THEME_NAME}} kde themes'..."

for theme in "${themes[@]:-${THEME_VARIANTS[@]}}"; do
for color in "${colors[@]:-${COLOR_VARIANTS[@]}}"; do
  install "${name:-${THEME_NAME}}" "${theme}" "${color}"
done
done

echo "Install finished..."


