
function [ffs, freq] = fftseries(field,N,varargin)
%% [ffs, freq] = fftseries(field,N,varargin)
%       field = timeseries
%       N = number of discrete frequencies to plot
%       varargin{1} = 'lopass' or 'hipass' or 'bandpass'
%       varargin{2} = threshold or vector of bandpass thresholds
%

N = 2^nextpow2(N);
ff = fft(field,N)/N;
N = length(ff);
freq = (1:(N/2+1))/N;
ffs = 2*abs(ff(1:N/2+1));

if nargin > 2
    switch upper(varargin{1})
        case 'LOPASS'
            disp('LOPASS')
            % lowpass filter line
            lo = varargin{2};
            ffs(1./freq <= lo) = 0;
        case 'HIPASS'
            % hipass filter line
            hi = varargin{2};
            ffs(1./freq >= hi) = 0;
        case 'BANDPASS'
            % bandpass filter line
            band = varargin{2};
            ffs(1./freq >= band(2) & 1./freq <= band(1)) = 0;
    end
end

far = trapz(freq,ffs);
%plot(1./freq,ffs/far)
ffs = ffs/far;

end