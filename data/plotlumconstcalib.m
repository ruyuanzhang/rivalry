%% plot luminance calibration figure



cl;

%% first luminance calibration
subj='KK';

%taskrun=[1 2 3 4];

filenames=matchfiles(sprintf('*%s_lum*',subj));

load(filenames{1});
subplot(2,2,1);
myplot(eyelum(:,1),'r-o','lineWidth',2);ylim([0 150]);hold on;
myplot(eyelum(:,2),'g-o','lineWidth',2);ylim([0 150]);hold on;
legend('red (left) eye','blue (right) eye');
xlabel('Trials');
ylabel('Luminance');

load(filenames{2});
subplot(2,2,2);
myplot(eyelum(:,1),'r-o','lineWidth',2);ylim([0 150]);hold on;
myplot(eyelum(:,2),'g-o','lineWidth',2);ylim([0 150]);hold on;
legend('red (left) eye','blue (right) eye');
xlabel('Trials');
ylabel('Luminance');

%% const test
filenames=matchfiles(sprintf('*%s_const*',subj));
load(filenames{1});
subplot(2,2,3);
myplot(catconst(:,1),'r-o','lineWidth',2);ylim([0 1.5]);hold on;
myplot(catconst(:,2),'g-o','lineWidth',2);ylim([0 1.5]);hold on;
myplot(catconst(:,3),'b-o','lineWidth',2);ylim([0 1.5]);hold on;
legend({'F','H','C'});
xlabel('trials');
ylabel('contrast');

filenames=matchfiles(sprintf('*%s_const*',subj));
load(filenames{2});
subplot(2,2,4);
myplot(catconst(:,1),'r-o','lineWidth',2);ylim([0 1.5]);hold on;
myplot(catconst(:,2),'g-o','lineWidth',2);ylim([0 1.5]);hold on;
myplot(catconst(:,3),'b-o','lineWidth',2);ylim([0 1.5]);hold on;
legend({'F','H','C'});
xlabel('trials');
ylabel('contrast');