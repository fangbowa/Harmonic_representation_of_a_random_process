
%This code exemplifies the procedure to quantify a weakly stationary Gaussian random
%process using spectral representation. The spectral representation are
%essentially sum of many harmonic random processes. It utilizes fourier tranformation
%to tranform the covariance function into power spectral density function.
%The amplitude values in the harmonic function is computed easily by using the
%power spectra density function.



% Book <<Random vibration theory and practice>> by Paul Wirsching et al. is
% followd. See page 92, 124, 127 of the book for details.

% The example below is a low-pass random process with cutting off
% frequency to be 1, and can be found in page 127 of the book.

clc;clear;
marg_mean=0;
marg_std=40;
cut_freq=1;


%generate the covariance function
time_series=0.01:0.01:10;
for count=1:length(time_series)
    corr_exact(count)=marg_std^2*sin(cut_freq*time_series(count))/cut_freq/time_series(count);
end

%%
% analytical form of one-sided power spectral density function
% for general cases, FFT need be performed to get the power spectral density function

delta_w=0.01;
freq_series=0:delta_w:cut_freq;

for count=1:length(freq_series)
   Gx(count)=marg_std^2/cut_freq;
end

%%

% spectral representation computation

for i=1:length(freq_series)
   partial_var=Gx(i)*delta_w;
   harmonic_process(i,:)=[freq_series(i) sqrt(partial_var) sqrt(partial_var)]; 
end

%%

%generate realizations of random process

num=10000;
for i=1:num
    temp_realization=zeros(1,length(time_series));
   for j=1:size(harmonic_process,1) 
       sample1 = normrnd(0,harmonic_process(j,2));
       sample2 = normrnd(0,harmonic_process(j,3));
       temp_realization = temp_realization + sample1*sin(harmonic_process(j,1)*time_series) + sample2*cos(harmonic_process(j,1)*time_series);
       
   end
   total_realizations(i,:)=temp_realization;
   i
    
    
end

%%

% result comparison
for i=1:size(total_realizations,2)
    mean_real(i)=mean(total_realizations(:,i));
    std_real(i)=std(total_realizations(:,i));
    
    tempmat=corrcoef(total_realizations(:,1)', total_realizations(:,i)');
    corr_real(i)=marg_std^2*tempmat(1,2);
    i
end


mean_exact=marg_mean*ones(length(mean_real),1);
std_exact=marg_std*ones(length(mean_real),1);
subplot(3,1,1)
plot(mean_exact); hold on;
plot(mean_real); grid on;
ylim([-4*max(mean_real) 4*max(mean_real)]);
legend('exact-mean','syntheiszed-mean');

subplot(3,1,2)
plot(std_exact); hold on;
plot(std_real); grid on;
ylim([0 2*std_exact(1)]);
legend('exact-std','syntheiszed-std');

subplot(3,1,3)
plot(corr_exact); hold on;
plot(corr_real); grid on;
legend('exact-covar','syntheiszed-covar');






