function [ J ] = calculate_J(q )
%computes the current J from the state of charge q(t)
J=diff(q);
J=[J;J(end)];  %extend by a single element equal to last so we don't shrink the # of timepoints...

end

