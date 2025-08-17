## src/analyze_redshift.m
```matlab
function result = analyze_redshift(lambdaStart, lambdaDelta, spectra, starCol, varargin)
%ANALYZE_REDSHIFT  Compute H-alpha redshift for one star spectrum column.
%
% result = analyze_redshift(lambdaStart, lambdaDelta, spectra, starCol, ...)
%   Reconstructs the wavelength axis, finds the H-alpha minimum, computes
%   redshift z and recession speed v, and (optionally) plots & saves a figure.
%
% Required inputs
%   lambdaStart  - starting wavelength (nm)
%   lambdaDelta  - wavelength step (nm)
%   spectra      - nObs x nStars intensity matrix
%   starCol      - column index to analyze
%
% Name-value pairs
%   'Lambda0'    - rest wavelength (nm), default 656.28
%   'Plot'       - logical, default true
%   'SaveFigure' - logical, default false
%   'FigurePath' - folder to save figures (created if missing), default 'figures'
%
% Returns a struct with fields: lambda, s, sHa, idx, lambdaHa, z, speed

% ---- Parse options ----
p = inputParser;
addParameter(p, 'Lambda0', 656.28, @(x)isnumeric(x)&&isscalar(x));
addParameter(p, 'Plot', true, @(x)islogical(x)||ismember(x,[0 1]));
addParameter(p, 'SaveFigure', false, @(x)islogical(x)||ismember(x,[0 1]));
addParameter(p, 'FigurePath', 'figures', @(x)ischar(x)||isstring(x));
parse(p, varargin{:});
opt = p.Results;

% ---- Basic checks ----
assert(starCol>=1 && starCol<=size(spectra,2), 'starCol out of range.');

% ---- Build wavelength axis ----
nObs = size(spectra,1);
lambdaEnd = lambdaStart + (nObs-1)*lambdaDelta;
lambda = (lambdaStart:lambdaDelta:lambdaEnd).';

% ---- Extract spectrum and locate H-alpha minimum ----
s = spectra(:, starCol);
[sHa, idx] = min(s);
lambdaHa = lambda(idx);

% ---- Redshift and speed ----
z = lambdaHa/opt.Lambda0 - 1;
speed = z * 299792.458; % km/s

% ---- Plotting (optional) ----
if opt.Plot
    f = figure('Color','w');
    plot(lambda, s, '.-'); grid on; hold on
    xlabel('Wavelength (nm)'); ylabel('Intensity');
    title(sprintf('Star spectrum (column %d)', starCol));
    plot(lambdaHa, sHa, 'rs', 'MarkerSize', 8);
    legend('Spectrum','H\alpha minimum','Location','best');
    hold off

    if opt.SaveFigure
        if ~exist(opt.FigurePath, 'dir'), mkdir(opt.FigurePath); end
        out = fullfile(opt.FigurePath, sprintf('redshift_star_%d.png', starCol));
        exportgraphics(f, out, 'Resolution', 150);
    end
end

% ---- Package outputs ----
result = struct('lambda',lambda, 's',s, 'sHa',sHa, 'idx',idx, ...
                'lambdaHa',lambdaHa, 'z',z, 'speed',speed);
end
