function saveFormats(plotname,processedFilename,directory, dpi)
   if nargin < 3
       directory = './'
   end

   if length(dir(directory))  == 0
       mkdir(directory);
   end

   if strcmp(processedFilename,'') == 1
       pathandnametosave = [directory  plotname];
   else
       pathandnametosave = [directory  plotname '_' processedFilename];
       pathandnametosave = [directory  processedFilename];
   end
   try
       disp(['Saving the file ' plotname]);
%     set(gcf,'PaperPositionMode','auto')
%    saveas(gcf,[pathandnametosave '.fig'],'fig');
%      saveas(gcf,[pathandnametosave '.jpg'],'jpg');
%      saveas(gcf,[directory plotname '_' processedFilename '.eps'],'eps');


   % Backup previous settings
  % dpi = 100;
   handle = gcf;
prePaperType = get(handle,'PaperType');
prePaperUnits = get(handle,'PaperUnits');
preUnits = get(handle,'Units');
prePaperPosition = get(handle,'PaperPosition');
prePaperSize = get(handle,'PaperSize');

% Make changing paper type possible
set(handle,'PaperType','<custom>');

% Set units to all be the same
set(handle,'PaperUnits','inches');
set(handle,'Units','inches');

% Set the page size and position to match the figure's dimensions
paperPosition = get(handle,'PaperPosition');
position = get(handle,'Position');
set(handle,'PaperPosition',[0,0,position(3:4)]);
set(handle,'PaperSize',position(3:4));

% Save the pdf (this is the same method used by "saveas")
%print(handle,'-depsc2',[pathandnametosave '.pdf'],sprintf('-r%d',dpi))
%print(handle,'-dpdf',[pathandnametosave '.pdf'],sprintf('-r%d',dpi))
print(handle,'-dpng',[pathandnametosave '.png'],sprintf('-r%d',dpi))

% Restore the previous settings
set(handle,'PaperType',prePaperType);
set(handle,'PaperUnits',prePaperUnits);
set(handle,'Units',preUnits);
set(handle,'PaperPosition',prePaperPosition);
set(handle,'PaperSize',prePaperSize);

catch MException

disp(['Caught Exception ' MException.message]);
end

end