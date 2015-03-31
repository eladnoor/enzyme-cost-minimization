function correlate_loglog(x, y, labels, plot_title)
if nargin < 4
    plot_title = 'correlation';
end
ind = intersect(find(~isnan(x)), find(~isnan(y)));

figure;
hold on;
plot(x(ind), y(ind), 'o');
plot([1e-3, 1e-1], [1e-4, 1], 'k:');
text(x(ind)*1.05, y(ind), labels(ind));
set(gca,'xscale','log');
set(gca,'yscale','log');
hold off;
[r_lin,~] = corrcoef([x(ind), y(ind)]);
[r_log,~] = corrcoef([log(x(ind)), log(y(ind))]);

title(sprintf(['\\fontsize{14}%s\\fontsize{9}',...
               '\\newline r (linear): ', ...
               '%.2f\\newline r (log): %.2f'], ...
              plot_title, r_lin(1,2), r_log(1,2)));
