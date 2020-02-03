hold off
firstind=30;
lind=110;
plot([firstind:lind]/scale_factor,data_archive(firstind:lind,1)/max(data_archive(:,1))-.01,'r', 'LineWidth', 2)
hold on
plot([firstind:lind]/scale_factor,data_archive(firstind:lind,2)/qmax,'g', 'LineWidth', 2)
plot([firstind:lind]/scale_factor,f(firstind:lind)/f0, 'k', 'LineWidth', 2)
cpwr=controlled_pwr(f,data_archive,h0);
plot([firstind:lind]/scale_factor,cpwr(firstind:lind)/f0,'m',  'LineWidth', 2 )
legend ('inverter control function', 'battery charge', ...
    'uncontrolIled power', 'controlled power', 'Location','NorthEast')
xlabel('minutes','FontName', 'Arial', 'FontSize', 12 )
ylabel('response ratio', 'FontName', 'Arial', 'FontSize', 14)
title(['Ramp Rate Limit ', num2str(100*rr_requirement),  ' %   Battery Power  ',  ...
    num2str(scale_factor*100*Currentmax/f0), ' % of PV;   Forecast Time = ' ...
   , num2str((th-3)), '  Min'], 'FontName', 'Arial', 'FontSize', 14);
hold off