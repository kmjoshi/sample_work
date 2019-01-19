function FTLE_FSLE_subplot(grdnum,rr,le,le_num,ifsave)
%% grdnum = 1; le = 'fsle'; le_num = 60; % in kilometres or days 
%
ifw = 0;

if ifw == 1
    wstr = 'w';
else wstr = '';
end

figure;
if grdnum == 1;
    timestrvec = {'1999M08' '1999M11' '2000M02' '2000M05'};
    lvec = {'15m' '30m' '60m' '150m'};
    subplot1(5,2);
    cvec = [-6,8]*1e-6;
    subplot1(1)
    numnum = FTLE_FSLE(grdnum,1,rr(1),1,0,le,le_num,0);
    if strcmp(le,'fsle');
        if ifw; lestr = [le,'_',num2str(numnum),'m'];
        else lestr = [le,'_',num2str(numnum),'km'];
        end
    elseif strcmp(le,'ftle'); lestr = [le,'_',num2str(numnum),'days'];
    end
    %h1 = colorbar('EastOutside');
    %a1 = get(h1,'Position'); set(h1,'Position',[0.1,0.52,0.84,0.048])
    %set(h1,'Position',[a(1),0.5,a(3)+0.7,a(4)])
    caxis(cvec)
    title(timestrvec{rr(1)})
    ylabel('2d 15m')
    for i = 1:4
        subplot1(i*2+1)
        FTLE_FSLE(grdnum,2,rr(1),i,0,le,le_num,0);
        caxis(cvec)
        ylabel(['3d ',lvec{i}])
        if i == 4; h = colorbar('Location','SouthOutside');
        set(h,'Position',[0.1,0.04,0.84,0.02])
        %a = get(h,'Position'); set(h,'Position',[a(1)+0.04,a(2),a(3),a(4)])
        end
    end
    subplot1(2)
    FTLE_FSLE(grdnum,1,rr(2),1,0,le,le_num,0);
    %h2 = colorbar('SouthOutside');
    %a2 = get(h2,'Position'); set(h2,'Position',[0.1,0.06,0.84,0.048])
    %set(h2,'Position',[a(1),0,a(3)+0.7,a(4)])
    caxis(cvec)
    title(timestrvec{rr(2)})
    for i = 1:4
        subplot1(i*2+2)
        FTLE_FSLE(grdnum,2,rr(2),i,0,le,le_num,0);
        caxis(cvec)
        %if i == 4; h = colorbar('Location','East');
        %a = get(h,'Position'); set(h,'Position',[a(1)+0.06,a(2),a(3),a(4)])
        %end
    end
elseif grdnum == 3;
    timestrvec = {'1999M08' '1999M09' '1999M10' '1999M11' '1999M12' '2000M01'...
        '2000M02' '2000M03' '2000M04' '2000M05' '2000M06' '2000M07'};
    subplot1(2,5);
    cvec = [0,2.5];
    subplot1(1)
    numnum = FTLE_FSLE(grdnum,1,rr(1),1,0,le,le_num);
    if strcmp(le,'fsle'); 
        if ifw; lestr = [le,'_',num2str(numnum),'m'];
        else lestr = [le,'_',num2str(numnum),'km'];
        end
    elseif strcmp(le,'ftle'); lestr = [le,'_',num2str(numnum),'days'];
    end
    h1 = colorbar('SouthOutside');
    a1 = get(h1,'Position'); set(h1,'Position',[0.1,0.52,0.84,0.048])
    %set(h1,'Position',[a(1),0.5,a(3)+0.7,a(4)])
    caxis(cvec)
    ylabel(timestrvec{rr(1)})
    for i = 1:4
        subplot1(i+1)
        FTLE_FSLE(grdnum,2,rr(1),i,0,le,le_num);
        caxis(cvec)
        %if i == 4; h = colorbar('Location','East');
        %a = get(h,'Position'); set(h,'Position',[a(1)+0.04,a(2),a(3),a(4)])
        %end
    end
    cvec = [0,1];
    subplot1(6)
    FTLE_FSLE(grdnum,1,rr(2),1,0,le,le_num);
    h2 = colorbar('SouthOutside');
    a2 = get(h2,'Position'); set(h2,'Position',[0.1,0.06,0.84,0.048])
    %set(h2,'Position',[a(1),0,a(3)+0.7,a(4)])
    caxis(cvec)
    ylabel(timestrvec{rr(2)})
    title('')
    for i = 1:4
        subplot1(i+6)
        FTLE_FSLE(grdnum,2,rr(2),i,0,le,le_num);
        caxis(cvec)
        title('')
        %if i == 4; h = colorbar('Location','East');
        %a = get(h,'Position'); set(h,'Position',[a(1)+0.06,a(2),a(3),a(4)])
        %end
    end
end
if ifsave
export_fig(gcf,[lestr,wstr,'_',cpstr(grdnum,1),'.png'],'-m2','-r72','-q95','-transparent')
end
end