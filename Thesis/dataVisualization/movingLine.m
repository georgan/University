function movingLine(fhandle, x, fs)

%   MOVINGLINE(fhandle,x,fs) creates a moving line on the current axis of
%   figure with handle fhandle, and at the same time plays audio signal x,
%   of sampling frequency fs.
% 
%   Example:
%       fs = 8000;
%       t = 1/fs:1/fs:2;
%       s = chirp(t,200,1,800);
%       
%       spec = abs(spectrogram(s,240,200,512,fs));
%       figure;
%       imagesc([0 t(end)], [0 fs/2], spec);
%       xlabel('Time (sec)'); ylabel('Frequency (Hz)');
%       set(gca, 'YDir', 'Normal');
%       movingLine(gcf,s,fs);


global h

if ishandle(h)
    delete(h)
end

ahandle = get(fhandle, 'CurrentAxes');
if isempty(ahandle)
    error('No axis on this figure.')
end

xlim = get(ahandle, 'XLim');
ylim = get(ahandle, 'YLim');
dur = length(x)/fs;


h = line('Xdata', xlim(1)*[1 1], 'Ydata', ylim);
set(h, 'LineWidth', 2, 'Color', 'r');
pause(.1);

figure(fhandle);
sound(x, fs);
t0 = tic;
t1= xlim(1)+toc(t0)*(xlim(2)-xlim(1))/dur;

while t1 < xlim(2)
    set(h, 'Xdata', t1*[1 1]);
    drawnow;
    t1 = xlim(1)+toc(t0)*(xlim(2)-xlim(1))/dur;
end


delete(h);
