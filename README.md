# Evaluation of Foundational MLIPs for Migration Barrier Prediction
This repository reports Nudged Elastic Band (NEB) results obtained with machine-learned interatomic potentials (MLIPs) namely, MACE-MP-0, SevenNet, Orb-v3, CHGNet, and M3GNet. Our primary goals are to assess how well these MLIPs predict migration barriers when coupled with NEB and to determine whether they yield superior initial guesses for the minimum-energy path (MEP). We also introduce a new metric for comparing MLIP-predicted geometries.

The repository comprises three folders: Dataset-1, Dataset-2, and codes. "Dataset-1" and "Dataset-2" contain NEB results for each MLIP (organized by model name). The "codes" folder provides (i) a Python implementation of the geometry metric defined in Equation 1 of the paper and (ii) model-specific notebooks for running NEBs with each universal potential; each notebook is named after its corresponding potential.

In case you use any of the data here, we would appreciate a citation to our manuscript <link of arxiv/journal paper>
