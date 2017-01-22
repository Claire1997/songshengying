filename = 'traffic_400.mat';
time_now = yyyymmdd(datetime('now'));
[hh,mm,~] = hms(datetime('now'));
filename = ['../../figure/',filename,num2str(time_now),'_',num2str(hh),'_',num2str(mm)];
if exist(filename,'dir')==0
    mkdir(filename);
end

for loop = 1:28
    set(gcf,'Visible','off');
    
    subplot(6,2,1);
    plot(all_info_matrice(:,loop,1));
    title('posx');
    
    subplot(6,2,2);
    plot(all_info_matrice(:,loop,2));
    title('posy');
    
    subplot(6,2,3);
    plot(all_info_matrice(:,loop,3));
    title('speed');
    
    subplot(6,2,4);
    plot(all_info_matrice(:,loop,4));
    title('angle');
    
    subplot(6,2,5);
    plot(all_info_matrice(:,loop,7));
    title('acc_(inter) x');
    
    subplot(6,2,6);
    plot(all_info_matrice(:,loop,8));
    title('acc_(inter) y');
    
    subplot(6,2,7);
    plot(all_info_matrice(:,loop,9));
    title('acc_(road) x');
    
    subplot(6,2,8);
    plot(all_info_matrice(:,loop,10));
    title('acc_(road) y');
    
    subplot(6,2,9);
    plot(all_info_matrice(:,loop,11));
    title('acc_(will) x');
    
    subplot(6,2,10);
    plot(all_info_matrice(:,loop,12));
    title('acc_(will) y');
    
    subplot(6,2,11);
    plot(all_info_matrice(:,loop,5));
    title('type');
    
    subplot(6,2,12);
    plot(all_info_matrice(:,loop,6));
    title('AI');
    
    print ([filename, '/', num2str(loop), '.png'],'-dpng');
end