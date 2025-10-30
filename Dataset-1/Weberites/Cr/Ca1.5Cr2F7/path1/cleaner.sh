#!/usr/bin/env bash
# delete_except_vasp.sh
# Recursively delete all files under directories 00..08
# EXCEPT: POSCAR, POSCAR.vasp, CONTCAR, CONTCAR.vasp

set -euo pipefail

DRY_RUN=false   # set to true to preview instead of deleting

for dir in {00..08}; do
  [[ -d "$dir" ]] || continue

  if $DRY_RUN; then
    find "$dir" -type f \
      ! \( -name 'POSCAR' -o -name 'POSCAR.vasp' -o -name 'CONTCAR' -o -name 'CONTCAR.vasp' \) \
      -print
  else
    find "$dir" -type f \
      ! \( -name 'POSCAR' -o -name 'POSCAR.vasp' -o -name 'CONTCAR' -o -name 'CONTCAR.vasp' \) \
      -delete
  fi
done

