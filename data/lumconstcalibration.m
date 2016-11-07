%% plot lum and contrast calibration results
% This script is to analyze behavioral results of a subject.
clear all;close all;clc

subj='MH1';

%% plot luminance and const
H(1)=figure(1);
filenames=matchfiles(sprintf('*%s_lum*',subj));
load(filenames{1});
ax(1)=subplot(2,1,1);
myplot(eyelum(:,1),'r-o','lineWidth',2);ylim([0 150]);hold on;
myplot(eyelum(:,2),'g-o','lineWidth',2);ylim([0 150]);hold on;
ylabel('luminance');
xlabel('trial');
legend('red (left) eye','green (right) eye','Location','southwest');

filenames=matchfiles(sprintf('*%s_const*',subj));
load(filenames{1});
ax(2)=subplot(2,1,2);
myplot(catconst(:,1),'r-o','lineWidth',2);ylim([0 2]);hold on;
myplot(catconst(:,2),'g-o','lineWidth',2);ylim([0 2]);hold on;
myplot(catconst(:,3),'b-o','lineWidth',2);ylim([0 2]);hold on;
legend({'F','H','C'},'Location','southwest');
xlabel('trials');
ylabel('contrast');

set(H(1),'Position',[75 300 569 782]);
mysuptitle('Subject TZ');
figrmwhitespace(ax,2,1,[0 0 0 0.1]);