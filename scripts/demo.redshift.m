clc; clear; close all
addpath ../src

% Parameters for wavelength axis (used whether data is real or synthetic)
lambdaStart = 630.02;  % nm
lambdaDelta = 0.14;    % nm

% Try to load real data if available; otherwise create a synthetic example
spectra = [];
if exist('../data/starData.mat','file')
    S = load('../data/starData.mat');
    if isfield(S,'spectra'), spectra = S.spectra; end
end

if isempty(spectra)
    % --- synthetic fallback to keep the demo reproducible ---
    nObs = 300; nStars = 6;                       % size of demo matrix
    lambdaEnd = lambdaStart + (nObs-1)*lambdaDelta;
    lambda = (lambdaStart:lambdaDelta:lambdaEnd).';

    spectra = zeros(nObs, nStars);
    mu = [656.48, 656.50, 656.30, 656.28, 656.35, 656.62]; % Hα centers
    sigma = 0.25; base = 1.0 + 0.05*randn(nObs,1);
    for k = 1:nStars
        notch = 0.35*exp(-0.5*((lambda - mu(k))/sigma).^2);
        spectra(:,k) = base - notch + 0.02*randn(nObs,1);
    end
end

% --- Analyze star 6 then star 2, saving figures ---
res6 = analyze_redshift(lambdaStart, lambdaDelta, spectra, 6, ...
        'SaveFigure', true, 'FigurePath', '../figures');

res2 = analyze_redshift(lambdaStart, lambdaDelta, spectra, 2, ...
        'SaveFigure', true, 'FigurePath', '../figures');

% Print a compact summary
fprintf('Star 6:  lambda_Ha = %.5f nm, z = %.8f, speed = %.4f km/s\n', ...
        res6.lambdaHa, res6.z, res6.speed);
fprintf('Star 2:  lambda_Ha = %.5f nm, z = %.8f, speed = %.4f km/s\n', ...
        res2.lambdaHa, res2.z, res2.speed);
