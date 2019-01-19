function abs_dispersion_uvw_seas_bc(grdnum,f,level,seas)

%% Calculate absolute dispersion of Lagrangian particles from residual velocities

if f == 1 & level > 1; return; end

disp([grdnum f level])

HR_version = 1;
%seas = 1; % 1 = JJAS; 2 = NDJFM;
seas_in = 0;

% constants
%Lt = zeros(3,2,4); Lt(:,1,1) = [5,0,3]; Lt(1,2,:) = [7,7,9,15]; Lt(3,2,:) = [3,3,3,7];
%dt = 0.25; % timestep

if seas_in == 0
    seas_str = '';
else str = monthstr(seas_in); 
    if length(seas_in) == 1;
        seas_str = ['_',str]; 
    else seas_str = ['_',str(:,1)'];
    end 
end

if grdnum == 1;
    timestrvec = {'1999M08' '1999M11' '2000M02' '2000M05'};
    %grd = rnt_gridload('soatl1');
    npart = 6482;
elseif grdnum == 3;
    if HR_version == 1
        timestrvec = {'1999M08' '1999M09' '1999M10' '1999M11' '1999M12' '2000M01'...
            '2000M02' '2000M03' '2000M04' '2000M05' '2000M06' '2000M07'};
    elseif HR_version == 2
        timestrvec = {'1999M08D01' '1999M08D06' '1999M08D11' '1999M08D16' '1999M08D21' ...
            '1999M08D26' '1999M08D31' '1999M09D05' '1999M09D10' '1999M09D15' '1999M09D20' ...
            '1999M09D25' '1999M09D30' '1999M10D05' '1999M10D10' '1999M10D15' '1999M10D20' ...
            '1999M10D25' '1999M10D30' '1999M11D04' '1999M11D09' '1999M11D14' '1999M11D19' ...
            '1999M11D24' '1999M11D29' '1999M12D04' '1999M12D09' '1999M12D14' '1999M12D19' ...
            '1999M12D24' '1999M12D29' '2000M01D03' '2000M01D08' '2000M01D13' '2000M01D18' ...
            '2000M01D23' '2000M01D28' '2000M02D02' '2000M02D07' '2000M02D12' '2000M02D17' ...
            '2000M02D22' '2000M02D27' '2000M03D03' '2000M03D08' '2000M03D13' '2000M03D18' ...
            '2000M03D23' '2000M03D28' '2000M04D02' '2000M04D07' '2000M04D12' '2000M04D17' ...
            '2000M04D22' '2000M04D27' '2000M05D02' '2000M05D07' '2000M05D12' '2000M05D17' ...
            '2000M05D22' '2000M05D27' '2000M06D01' '2000M06D06' '2000M06D11' '2000M06D16' ...
            '2000M06D21' '2000M06D26' '2000M07D01' '2000M07D06' '2000M07D11' '2000M07D16' ...
            '2000M07D21' '2000M07D26'};
    end
    npart = 4980;
end

flstrvec = {'2d_z15m' '3d'};
flstr = flstrvec{f};

ttt = 1461; rr = length(timestrvec);

% dispu = zeros(ttt-1,npart,rr); dispv = zeros(ttt-1,npart,rr); dispw = zeros(ttt-1,npart,rr);
% ndata = zeros(ttt-1,npart,rr);

for r = 1:rr
%for r = 12
    timestr = timestrvec{r};
    disp(timestr)
    
    try lag_field = lag_load(grdnum,f,r,level,seas_in,1,1,0,1);
    catch; continue; end
        
    pp = size(lag_field.lon,3);
    t_size = size(lag_field.lon,1);
    
    lon = lag_field.lon;
    lat = lag_field.lat;
    
    %seas code
    timevec = lag_field.datenum;
    [~,mo,~,~,~,~] = datevec(timevec);
    if seas == 1
        s = 6:9; str = 'JJAS';
    elseif seas == 2
        s = [11,12,1,2,3]; str = 'NDJFM';
    end
    t_end = find(sq(nanmean(isnan(lag_field.lon),3)) == 1,1,'first');
    if isempty(t_end); t_end = length(mo); end
    if ~any(s == mo(1)) & ~any(s == mo(t_end)) & t_end < 500; 
        disp('Release not in season'); continue; end
    
    u_primes = lag_field.u - lag_field.useas;
    v_primes = lag_field.v - lag_field.vseas;
    w_primes = lag_field.w - lag_field.wseas;
    
    dispu = zeros(ttt-1,npart); dispv = zeros(ttt-1,npart); dispw = zeros(ttt-1,npart);
    disp2d = zeros(ttt-1,npart); nlag = zeros(ttt-1,npart);
    disput = zeros(ttt-1,1); dispvt = zeros(ttt-1,1); dispwt = zeros(ttt-1,1);
    disp2dt = zeros(ttt-1,1); nlagt = zeros(ttt-1,1);
    
    if grdnum == 1 && seas == 1
        if r == 1
            sed(1) = 1;
            est(1) = find(mo ~= s(1) & mo ~= s(2) & mo ~= s(3) & mo ~= s(4),1,'first');
            sed(2) = find(mo ~= s(1) & mo ~= s(2) & mo ~= s(3) & mo ~= s(4),1,'last');
            est(2) = t_size;
            j = 2;
        elseif r == 2 || r == 3
            sed(1) = find(mo ~= s(1) & mo ~= s(2) & mo ~= s(3) & mo ~= s(4),1,'last');
            est(1) = t_size;
            j = 1;
        elseif r == 4
            sed(1) = 1; est(1) = t_size;
            j = 1;
        end
    else
        for i = 1:length(s)
            st = find(mo == s(i),1,'first');
            if ~isempty(st); start(i) = st; else start(i) = t_size; end
        end
        sed = min(start);
        if seas == 2 && grdnum == 1
            est = find(mo ~= s(1) & mo ~= s(2) & mo ~= s(3) & mo ~= s(4) & mo ~= s(5),1,'first');
        elseif seas == 1 && r < 4;
            est = find(mo ~= s(1) & mo ~= s(2) & mo ~= s(3) & mo ~= s(4),1,'first');
        elseif seas == 2 && r >= 4;
            est = find(mo ~= s(1) & mo ~= s(2) & mo ~= s(3) & mo ~= s(4) & mo ~= s(5)...
                ,1,'first');
        else
            est = t_size;
        end
        j = 1;
    end
    
    matlabpool(12)
    tic;
    parfor p = 1:pp
        for i = 1:j
            se = sed(i); es = est(i);
            t_temp = find(isnan(sq(lon(se:es,1,p))) == 1,1,'first');
            if ~isempty(t_temp); tt = t_temp - 1; else tt = es-se+1; end
            disp(['Particle ',num2str(p),' life = ',num2str(tt)])
            if tt < 40; continue; end
            upts = sq(u_primes(se:es,1,p)); vpts = sq(v_primes(se:es,1,p));
            wpts = sq(w_primes(se:es,1,p));
            
            ub = filtering1(upts,grdnum,0);
            vb = filtering1(vpts,grdnum,0);
            wb = wpts;
            [disput,dispvt,dispwt,disp2dt,nlagt] = ...
                calc_disp(upts,vpts,wpts,tt,mo,s,lon(se:es,1,p),lat(se:es,1,p));
            dispu(:,p) = dispu(:,p) + disput;
            dispv(:,p) = dispv(:,p) + dispvt;
            dispw(:,p) = dispw(:,p) + dispwt;
            disp2d(:,p) = disp2d(:,p) + disp2dt;
            nlag(:,p) = nlag(:,p) + nlagt;
        end
        %[disprelwr(:,p),dispabswr(:,p),ndatar(:,p)] = ...
        %    calc_disp(sq(w_prime(:,1,p)),sq(w_abs(:,1,p)),tt);
    end
    %dispabsw(:,:,r) = dispabswr; disprelw(:,:,r) = disprelwr; ndata(:,:,r) = ndatar;
    toc;
    matlabpool close
    filepath = '/atlas2/kjoshi36/LANL/lagrangian_data/new_stats/';
    filenames = ['dispuvw_seas_bc_10days_',str,'_',flstr(1:2),'_',timestr,'_',num2str(grdnum),num2str(level),seas_str];
    save([filepath,filenames,'.mat'],'dispu','dispv','dispw','disp2d','nlag','timevec')
end

end

function [dispu,dispv,dispw,disp2d,ndata] = calc_disp(upt,vpt,wpt,tt,mo,s,lont,latt)
%calc_disp(p,r,upt,vpt,dispu,dispv,ndata,tt,t_temp,lag_field.lon)
ttt = 1461;
dispu = zeros(ttt-1,1); dispv = zeros(ttt-1,1); dispw = zeros(ttt-1,1); 
disp2d = zeros(ttt-1,1); ndata = zeros(ttt-1,1);

if tt > 2;
    for to = 2:tt-1
        if ~any(s == mo(to)); continue; end;
        if lont(to) < -34; continue; end
        if latt(to) > -10; continue; end
        %disp(to)
        for tf = to+1:tt
            if latt(tf-1) > -10; continue; end
            if lont(tf-1) < -34; continue; end
            if ~any(s == mo(tf-1)); continue; end;
            %                 if ~isempty(t_temp) & isnan(lag_field.lon(tf+1,1,p));
            %                     break; end
            lag = tf - to;
            % dispersion as a function of lag, p = particle,
            % r = release
            %[dispu,dispv,ndata] = calc_disp(upt,vpt,to,tf,lag,p,r,dispu,dispv,ndata);
            dispu(lag) = dispu(lag) + sum(upt(to:tf-1))^2;
            dispv(lag) = dispv(lag) + sum(vpt(to:tf-1))^2;
            dispw(lag) = dispw(lag) + sum(wpt(to:tf-1))^2;
            disp2d(lag) = disp2d(lag) + sum(upt(to:tf-1))^2 + sum(vpt(to:tf-1))^2;
            ndata(lag) = ndata(lag) + 1;
        end
    end
end
end

function y = filtering1(u,grdnum,speccheck)

if grdnum == 3
d = fdesign.lowpass('Fp,Fst',1/2.33/2,1/2.3/2);
Hd = design(d,'cheby2');
ylo = filtfilt(Hd.sosMatrix,Hd.ScaleValues,u);

d = fdesign.highpass('Fst,Fp',1/1.93/2,1/1.9/2);
Hd = design(d,'cheby2');
yhi = filtfilt(Hd.sosMatrix,Hd.ScaleValues,u);

y = ylo+yhi;
elseif grdnum == 1
d = fdesign.lowpass('Fp,Fst',1/3.6/2,1/3.5/2);
Hd = design(d,'cheby2');
y = filtfilt(Hd.sosMatrix,Hd.ScaleValues,u);
end

if speccheck
    [ffn,frn] = fftseries(y,length(y));
    [ffo,fro] = fftseries(u,length(u));
    figure(3); clf
    plot(1./fro/4,ffo)
    hold on
    plot(1./frn/4,ffn,'r')
    legend('Original Signal','Bandpass Signal')
    xlim([0.5,40])
    set(gca,'xscale','log')
    grid on
end
end