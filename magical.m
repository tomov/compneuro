function out = magical(x, r)

rmax = max(r);
rmin = min(r);
xcenter = sum(r .* x') / sum(r);

Ncells = length(r);
out = sum( (r - rmin / (rmax - rmin)) .* (x' - xcenter).^2 ) / Ncells;
