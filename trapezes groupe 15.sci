function q = trapezes(t,y)
    n = length(t) - 1;
    q = 0;
    for i = 1:n
        h = t(i+1) - t(i);
        if h <= 0 then error("Temps non croissants."); end
        aire = h * (y(i) + y(i+1)) / 2
        q = q + aire;
    end
endfunction
