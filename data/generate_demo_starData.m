% --- Try to load course data. If missing, synthesize a similar dataset ---
dataLoaded = false;
try
    load starData              % should define `spectra`
    dataLoaded = true;
catch
    warning('starData.mat not found. Generating demo data so the script can run.')


    lambdaStart = 630.02;      % nm
    lambdaDelta = 0.14;        % nm
    nObs = 300;                % number of wavelength samples (rows)

    % Build wavelength axis
    lambdaEnd = lambdaStart + (nObs-1)*lambdaDelta;
    lambda = lambdaStart:lambdaDelta:lambdaEnd;
    lambda = lambda(:);        % column vector

    % Make 6 fake star spectra with absorption dips (Gaussian notches)
    nStars = 6;                                % columns
    spectra = zeros(nObs, nStars);

    % Star 6: H-alpha around 656.62 nm
    mu6 = 656.62;  % center
    % Star 2: slightly different redshift so you'll modify later
    mu2 = 656.50;

    % Width and depth of lines
    sigma = 0.25;                 % width (nm)
    base  = 1.0 + 0.05*randn(nObs,1);  % noisy continuum

    for k = 1:nStars
        % choose center: use mu6 for col 6, mu2 for col 2, random near 656.3 otherwise
        if k == 6, mu = mu6;
        elseif k == 2, mu = mu2;
        else, mu = 656.28 + 0.3*(rand-0.5);
        end
        notch = 0.35*exp(-0.5*((lambda - mu)/sigma).^2); % absorption dip
        spectra(:,k) = base - notch + 0.02*randn(nObs,1);
    end
end

% If the real data was loaded, define lambda from its dimensions
if dataLoaded
    nObs = size(spectra,1);
    lambdaStart = 630.02;
    lambdaDelta = 0.14;
    lambdaEnd = lambdaStart + (nObs-1)*lambdaDelta;
    lambda = (lambdaStart:lambdaDelta:lambdaEnd).';
end


starCol = 2;              % <-- change to 2 later to compare the results
s = spectra(:, starCol);  % extract column to vector s

plot(lambda, s, '.-');           % plot with points and line
xlabel("Wavelength");
ylabel("Intensity");
title(sprintf("Star spectrum (column %d)", starCol));
grid on; hold on

% find min value and its index
[sHa, idx] = min(s);
lambdaHa = lambda(idx);

% mark the H-alpha point as red square, size 8
plot(lambdaHa, sHa, 'rs', 'MarkerSize', 8);
hold off

% compute redshift and speed
z = lambdaHa/656.28 - 1;
speed = z * 299792.458;   % km/s

% Print results nicely
fprintf('H-alpha wavelength λ_Ha = %.5f nm\n', lambdaHa);
fprintf('Redshift factor z       = %.8f\n', z);
fprintf('Recession speed          = %.4f km/s\n', speed);



