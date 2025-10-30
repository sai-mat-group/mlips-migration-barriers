#!/usr/bin/env bash
# cleanup_vasp.sh
# 1) In 00..08: delete all files except POSCAR/CONTCAR (+ .vasp variants).
# 2) Top level: delete all directories except 00..08.

set -euo pipefail

DRY_RUN=false   # set to true to preview actions without deleting

# -------- Part 1: file cleanup within 00..08 (recursive) --------
for dir in {00..08}; do
  [[ -d "$dir" ]] || continue

  if $DRY_RUN; then
    echo "[DRY RUN] Files that would be deleted under $dir:"
    find "$dir" -type f \
      ! \( -name 'POSCAR' -o -name 'POSCAR.vasp' -o -name 'CONTCAR' -o -name 'CONTCAR.vasp' \) \
      -print
  else
    find "$dir" -type f \
      ! \( -name 'POSCAR' -o -name 'POSCAR.vasp' -o -name 'CONTCAR' -o -name 'CONTCAR.vasp' \) \
      -delete
  fi
done

# -------- Part 2: remove top-level directories except 00..08 --------
# (Only directories directly in the current working directory)
if $DRY_RUN; then
  echo "[DRY RUN] Directories that would be removed at top level:"
  find . -mindepth 1 -maxdepth 1 -type d \
    ! -name '.' \
    ! -name '00' ! -name '01' ! -name '02' ! -name '03' ! -name '04' \
    ! -name '05' ! -name '06' ! -name '07' ! -name '08' \
    -print
else
  # Use rm -rf via -exec to remove directories not in 00..08
  find . -mindepth 1 -maxdepth 1 -type d \
    ! -name '.' \
    ! -name '00' ! -name '01' ! -name '02' ! -name '03' ! -name '04' \
    ! -name '05' ! -name '06' ! -name '07' ! -name '08' \
    -exec rm -rf {} +
fi

