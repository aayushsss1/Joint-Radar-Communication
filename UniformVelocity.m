clc;
clear;
clear all;

fc = 60e9;
c = 3e8;
lambda = c/fc;

range_max = 200;
tm = 5.5*range2time(range_max,c);

range_res = 1;
bw = rangeres2bw(range_res,c);
sweep_slope = bw/tm;

fr_max = range2beat(range_max,sweep_slope,c);

v_max = 230*1000/3600;
fd_max = speed2dop(2*v_max,lambda);
fb_max = fr_max+fd_max;

fs = max(2*fb_max,bw);

waveform = phased.FMCWWaveform('SweepTime',tm,'SweepBandwidth',bw, ...
    'SampleRate',fs);


sig = waveform();
% figure(1);
% subplot(211); plot(0:1/fs:tm-1/fs,real(sig));
% xlabel('Time (s)'); ylabel('Amplitude (v)');
% title('FMCW signal'); axis tight;
% subplot(212); spectrogram(sig,32,16,32,fs,'yaxis');
% title('FMCW signal spectrogram');
sig = sig + transpose((1/sqrt(2)).*(randn(1,1100) + 1i*randn(1,1100)));
figure(1);
subplot(211); 
plot(0:1/fs:tm-1/fs,real(sig));
xlabel('Time (s)'); ylabel('Amplitude (v)');
title('FMCW signal'); axis tight;
subplot(212); spectrogram(sig,32,16,32,fs,'yaxis');
title('FMCW signal spectrogram');

v_abs = zeros(1,10);

i = 0;

for car_dist=10:10:100
    
   
% car_dist = 60; %[1.2130, 1.2187,  1.2276, 1.2450, 1.2818, 1.3265, 1.4313, 1.5658, 1.7842, 2.0489], [1.2122, 1.2133, 1.2191, 1.2264, 1.2448, 1.2896]

    car_speed = 96*1000/3600;
    car_rcs = db2pow(min(10*log10(car_dist)+5,20));
    cartarget = phased.RadarTarget('MeanRCS',car_rcs,'PropagationSpeed',c,...
        'OperatingFrequency',fc);
    carmotion = phased.Platform('InitialPosition',[car_dist;0;0.5],...
        'Velocity',[car_speed;0;0]);
    
    
    channel = phased.FreeSpace('PropagationSpeed',c,...
        'OperatingFrequency',fc,'SampleRate',fs,'TwoWayPropagation',true);
    
    ant_aperture = 6.06e-4;                         % in square meter
    ant_gain = aperture2gain(ant_aperture,lambda);  % in dB
    
    tx_ppower = db2pow(5)*1e-3;                     % in watts
    tx_gain = 9+ant_gain;                           % in dB
    
    rx_gain = 15+ant_gain;                          % in dB
    rx_nf = 4.5;                                    % in dB
    
    transmitter = phased.Transmitter('PeakPower',tx_ppower,'Gain',tx_gain);
    receiver = phased.ReceiverPreamp('Gain',rx_gain,'NoiseFigure',rx_nf,...
        'SampleRate',fs);
    
    radar_speed = 100*1000/3600;
    radarmotion = phased.Platform('InitialPosition',[0;0;0.5],...
        'Velocity',[radar_speed;0;0]);
    
    %specanalyzer = dsp.SpectrumAnalyzer('SampleRate',fs,...
    %   'PlotAsTwoSidedSpectrum',true,...
    % 'Title','Spectrum for received and dechirped signal',...
    % 'ShowLegend',true);
        
    
    rng(2012);
    Nsweep = 100000;
    xr = complex(zeros(waveform.SampleRate*waveform.SweepTime,Nsweep));
    
    for m = 1:Nsweep
        [radar_pos,radar_vel] = radarmotion(waveform.SweepTime);
        [tgt_pos,tgt_vel] = carmotion(waveform.SweepTime);
        sig = waveform();
        txsig = transmitter(sig);
        txsig = txsig + transpose((1/sqrt(2)).*(randn(1,1100) + 1i*randn(1,1100)));
        txsig = channel(txsig,radar_pos,tgt_pos,radar_vel,tgt_vel);
        txsig = cartarget(txsig);
        txsig = txsig + transpose((1/sqrt(2)).*(randn(1,1100) + 1i*randn(1,1100)));
        txsig = receiver(txsig);  
        dechirpsig = dechirp(txsig,sig);
        %specanalyzer([txsig dechirpsig]);
        xr(:,m) = dechirpsig;
    end
    
    waveform_tr = clone(waveform);
    release(waveform_tr);
    tm = 2e-3;
    waveform_tr.SweepTime = tm;
    sweep_slope = bw/tm;
    
    waveform_tr.SweepDirection = 'Triangle';
    
    Nsweep = 16;
    xr = helperFMCWSimulate(Nsweep,waveform_tr,radarmotion,carmotion,...
        transmitter,channel,cartarget,receiver);
    
    fbu_rng = rootmusic(pulsint(xr(:,1:2:end),'coherent'),1,fs);
    fbd_rng = rootmusic(pulsint(xr(:,2:2:end),'coherent'),1,fs);
    
    
    rng_est = beat2range([fbu_rng fbd_rng],sweep_slope,c);
    
    fd = -(fbu_rng+fbd_rng)/2;
    v_est = dop2speed(fd,lambda)/2;
    
    v_abs(i+1) = v_est;
    
    disp(v_est);

    i = i + 1;


end 

v_abs = v_abs - 1.11;

figure(2);
subplot(211); 
plot(10:10:100,v_abs);
ylim([0.0001 1]);
xlabel('Distance (m)'); ylabel('Velocity Error');
title('Uniform Velocity'); axis tight;

% 100000 - [0.1018    0.1025    0.1066    0.1081    0.1221    0.1428    0.1686    0.2157    0.2636    0.3463]
% 1000000 - [] 

