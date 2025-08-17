# MATLAB Redshift (H‑Alpha)

Compute the redshift and recession speed of a star using the hydrogen‑alpha (Hα) absorption line. The project plots the star's spectrum, locates the Hα minimum, and reports the redshift \( z = \frac{\lambda_{Ha}}{\lambda_0} - 1 \) and speed \( v = z\,c \).

- **Rest wavelength**: \( \lambda_0 = 656.28 \) nm
- **Speed of light**: \( c = 299\,792.458 \) km/s

## Features
- Clean function API: `analyze_redshift` (optionally plots and saves figures)
- Works with real data (`starData.mat`) **or** generates synthetic spectra if data is absent
- MATLAB **and** GNU Octave compatible

## Quick Start
```matlab
% From project root
addpath src scripts
scripts/demo_redshift
