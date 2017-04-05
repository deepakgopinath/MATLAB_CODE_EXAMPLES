run('robot-9.10/rvctools/startup_rvc.m');

mdl_wam

wam
wamTest;
n = wam.n;
k = 10;
stepSize = 0.01;
Q = zeros(k, n);
BigQ = [];

JAMatrix = JMatFixedWam;
% JAMatrix = JMatBodyWam;

for i=1:size(JAMatrix, 1)-1
    q0 = JAMatrix(i, :);
    qf = JAMatrix(i+1, :);
    for j = 1:n
       Q(:,j) = linspace(q0(j), qf(j), k);
    end
    BigQ = [BigQ; Q];
end
BigQ;
wam.plot(BigQ);
% wam.plot(BigQ, 'movie', 'wam_imgs')