function correlate_loglog(x, y, labels)
if nargin < 3
    labels = [];
end

% use only indices where both x and y are not NaN and non-zero
ind = find(~(isnan(x) + isnan(y) + (x == 0) + (y == 0)));

figure;
hold on;
plot(x(ind), y(ind), 'o');
plot([1e-3, 1e-1], [1e-4, 1], 'k:');
if ~isempty(labels)
    text(x(ind)*1.05, y(ind), labels(ind));
end
set(gca,'xscale','log');
set(gca,'yscale','log');
hold off;
[r_lin,~] = corrcoef([x(ind), y(ind)]);
[r_log,~] = corrcoef([log(x(ind)), log(y(ind))]);

title(sprintf(['r (linear): %.2f\\newline', ...
               'r (log)   : %.2f'], ...
               r_lin(1,2), r_log(1,2)));
