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

## The demo will:

Load data/starData.mat if present (expects a matrix spectra of size nObs×nStars).

Otherwise, create a realistic synthetic dataset so the example is reproducible.

Analyze star column 6 (then 2), plot spectra, and save figures under figures/.

Inputs & Data Format

spectra: nObs × nStars matrix; each column is one star’s spectrum (intensity vs wavelength).

Wavelength axis is reconstructed from lambdaStart, lambdaDelta, and nObs.

Function API
result = analyze_redshift(lambdaStart, lambdaDelta, spectra, starCol, varargin)

Required

lambdaStart (nm), lambdaDelta (nm), spectra (nObs×nStars), starCol (column index)

Name‑value options

'Lambda0' (default 656.28) — rest wavelength in nm

'Plot' (true/false, default true)

'SaveFigure' (true/false, default false)

'FigurePath' (default 'figures')

Returns result struct with fields:

lambda (nObs×1), s (nObs×1), sHa, idx, lambdaHa, z, speed

Example
addpath src
lambdaStart = 630.02; lambdaDelta = 0.14;
load data/starData.mat % if available
result = analyze_redshift(lambdaStart, lambdaDelta, spectra, 6, 'SaveFigure', true);
