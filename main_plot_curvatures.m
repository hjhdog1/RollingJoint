i = 1;

fc = links{i}.child_curv_func;
fp = links{i+1}.parent_curv_func;

s = linspace(-15,15, 100);

curv_c = zeros(size(s));
curv_p = zeros(size(s));

for i = 1:length(s)
    curv_c(i) = fc(s(i));
    curv_p(i) = fp(s(i));
    
end

plot(s, curv_c, s, curv_p)
legend('c', 'p')
    