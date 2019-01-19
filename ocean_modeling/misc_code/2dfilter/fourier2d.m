function [LO, HI] = fourier2d(field,low,hi,space, filterswitch)

%% fourier2d: 2D fourier lowpass filter
% fourier2d(field,low,hi,space,filterswitch)
%
% Calculates the lowpass and highpass fields for any 2D field and returns
% as output
%
%
% INPUTS: field:    2D field
%         low:      lowpass threshold in any units (km in this case)
%         hi:       highpass threshold
%         space:    grid resolution in any units (km)
%         filterswitch: 1 to calcualte filtered field, 2 to only calculate
%         power spectrum
%
% OUTPUTS: LO: lowpass filtered 2D field
%          HI: highpass filtered 2D field
%
% Example: fourier2d(field,60,60,space,1)
% field and space are calculated by submeso_filter
%
%   SEE also SUBMESO_FILTER


%parameters/switches to EDIT
psdswitch = 7; % 1 plots power spectrum; 2 plots 
bins = 1000:-1:1;

ff = fftshift(fft2(field));
[Nx Ny] = size(field);
k = -Nx/2:1:Nx/2-1;
l = -Ny/2:1:Ny/2-1;
[kk ll] = meshgrid(l,k);
%add in the discrepancy in the average grid spacing here!
kl = sqrt(kk.^2+ll.^2);

if filterswitch == 1
low = space*2*max(kl(:))/low;
hi = space*2*max(kl(:))/hi;

% bandpass options
%band = space*2*max(kl(:))/700;
%lopass = ff.*(kl<=low & kl >= band);

lopass = ff.*(kl<=low);
hipass = ff.*(kl>hi);
else 
    %when only using this function to plot spectrum and not to filter
    lopass = fftshift(fft2(low)); hipass = fftshift(fft2(hi));
end 
    
%freq = max(kl(:))*exp((x-length(x)));
width = 2*(max(kl(:))-min(kl(:)))./bins;
%width = 1000./bins;
%freq = min(kl(:)):width:max(kl(:));
freq = repmat(min(kl(:)),1,length(bins))+width;

% w = 1./bins;
% dist = 0:w:length(field)*space;
% freq =

if psdswitch == 1
    figure(3); clf;
    %figure;
    psdspec(hipass,freq,kl,space);
    psdspec(lopass,freq, kl,space);
    %psdspec(ff,freq, kl);
    legend('mesoscale','submesoscale')
    xlabel('km')
elseif psdswitch == 2
    figure(3); clf;
    abspec(hipass,freq,kl,space);
    abspec(lopass,freq, kl,space);
    %psdspec(ff,freq, kl);
    legend('mesoscale','submesoscale')
    xlabel('km')
end

LO = real(ifft2(ifftshift(lopass)));
HI = real(ifft2(ifftshift(hipass)));
% freq1 = freq(1:end-1)/(2*max(kl(:)));
% plot(1./freq1,his)
% plot(kl_avg,his);


end

function psd = psdspec(fff, freq, kl,space)

for i = 1:length(freq)-1
    xx = find(kl<freq(i+1) & kl>=freq(i));
    his(i) = sum(abs(fff(xx)));
    kl_avg(i) = mean(kl(xx));
    %     if i == 1
    %      his(i) = sum(abs(ff(kl<freq(i))));
    %      elseif i == bins
    %      his(i) = sum(abs(ff(kl>=freq(i))));
    %     else
    %     his(i) = sum(abs(ff(kl<freq(i+1) & kl>=freq(i))));
    %     end
    
    %j = j+width;
end
hold on; plot(2*space*max(kl(:))./kl_avg,his,'Linestyle','-','Marker','.','color',rand(1,3));
axes = axis; axis([0 200 axes(3) axes(4)]);
psd.his = his; psd.kl_avg = kl_avg;
end

function his = abspec(fff, freq, kl,space)
fff = fff.*conj(fff);
for i = 1:length(freq)-1
    xx = find(kl<freq(i+1) & kl>=freq(i));
    his(i) = sum(abs(fff(xx)));
    kl_avg(i) = mean(kl(xx));
end
hold on; plot(2*space*max(kl(:))./kl_avg,his,'color',rand(1,3));
end