%% plot luminance calibration figure



cl;

%% first luminance calibration
subj='QL';

taskrun=[1 2 3 4];

filenames=matchfiles('*QL_lum*');

load(filenames{1});
subplot(2,2,1);
myplot(eyelum(:,1),'r-o','lineWidth',2);ylim([0 150]);hold on;
myplot(eyelum(:,2),'g-o','lineWidth',2);ylim([0 150]);hold on;
legend('red (left) eye','blue (right) eye');


load(filenames{2});
subplot(2,2,2);
myplot(eyelum(:,1),'r-o','lineWidth',2);ylim([0 150]);hold on;
myplot(eyelum(:,2),'g-o','lineWidth',2);ylim([0 150]);hold on;
legend('red (left) eye','blue (right) eye');


%% const test
filenames=matchfiles('*QL_const*');
load(filenames{1});
subplot(2,2,[3 4]);
myplot(catconst(:,1),'r-o','lineWidth',2);ylim([0 1.5]);hold on;
myplot(catconst(:,2),'g-o','lineWidth',2);ylim([0 1.5]);hold on;
myplot(catconst(:,3),'b-o','lineWidth',2);ylim([0 1.5]);hold on;
legend({'F','H','C'});
xlabel('trials');
ylabel('contrast');