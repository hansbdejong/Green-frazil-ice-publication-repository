%Add the current directory here
cd('C:\Users\...')
fileID_15=xlsread('number_of_green_pixels_15.xlsx');
fileID_10=xlsread('number_of_green_pixels_10.xlsx');
fileID_5=xlsread('number_of_green_pixels_5.xlsx');

year=fileID_15(:,1);
month=fileID_15(:,2);
year=year(month==2);

%Divide by 4.66 to produce km squared
green_total_15=fileID_15(:,3)/4.66;             
green_total_10=fileID_10(:,3)/4.66;  
green_total_5=fileID_5(:,3)/4.66;  

%calculate total number of green pixels for the different thresholds
%and months
green_total_15_Feb=green_total_15(month==2);
green_total_15_Mar=green_total_15(month==3);
green_total_15_horzcat=horzcat(green_total_15_Feb, green_total_15_Mar);

green_total_10_Feb=green_total_10(month==2);
green_total_10_Mar=green_total_10(month==3);
green_total_10_horzcat=horzcat(green_total_10_Feb, green_total_10_Mar);

green_total_5_Feb=green_total_5(month==2);
green_total_5_Mar=green_total_5(month==3);
green_total_5_horzcat=horzcat(green_total_5_Feb, green_total_5_Mar);

%----------------------------------------------------------------------------------------
figure

subplot(2,2,1)
bar_handle=bar(year, green_total_15_horzcat, 1)
set(bar_handle(1),'FaceColor',[0.95,0.95,0.95])
set(bar_handle(2),'FaceColor',[0.6,0.6,0.6])
str = {'''03'; '''04'; '''05'; '''06'; '''07'; '''08'; '''09'; '''10'; '''11'; '''12'; '''13'; '''14'; '''15'; '''16'; '''17';};
set(gca, 'XTickLabel',str)
n=get(gca,'Ytick');
set(gca,'yticklabel',sprintf('%d |',n'));
ylabel('Area (km^{2})', 'fontsize', 12)
xlabel('Year', 'fontsize', 12)
text(2002.5, 225000, '(a) Higher Threshold', 'fontsize', 12)


subplot(2,2,2)
bar_handle=bar(year, green_total_10_horzcat, 1)
set(bar_handle(1),'FaceColor',[0.95,0.95,0.95])
set(bar_handle(2),'FaceColor',[0.6,0.6,0.6])
str = {'''03'; '''04'; '''05'; '''06'; '''07'; '''08'; '''09'; '''10';
    '''11'; '''12'; '''13'; '''14'; '''15'; '''16'; '''17';};
set(gca, 'XTickLabel',str)
n=get(gca,'Ytick');
set(gca,'yticklabel',sprintf('%d |',n'));
ylabel('Area (km^{2})', 'fontsize', 12)
xlabel('Year', 'fontsize', 12)
text(2002.5, 540000, '(b) Medium Threshold', 'fontsize', 12)
legend({'Feb', 'Mar'}, 'Location', 'northeast', 'Fontsize', 15)



subplot(2,2,3.5)
bar_handle=bar(year, green_total_5_horzcat, 1)
set(bar_handle(1),'FaceColor',[0.95,0.95,0.95])
set(bar_handle(2),'FaceColor',[0.6,0.6,0.6])
str = {'''03'; '''04'; '''05'; '''06'; '''07'; '''08'; '''09'; '''10'; 
    '''11'; '''12'; '''13'; '''14'; '''15'; '''16'; '''17';};
set(gca, 'XTickLabel',str)
n=get(gca,'Ytick');
set(gca,'yticklabel',sprintf('%d |',n'));
ylabel('Area (km^{2})', 'fontsize', 12)
xlabel('Year', 'fontsize', 12)
text(2002.5, 1800000, '(c) Lower Threshold', 'fontsize', 12)






