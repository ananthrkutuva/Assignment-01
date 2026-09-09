%Root finding function via secant method
%INPUTS:
%   fun: the function we are computing the root of
%   x0: first guess for secant method
%   x1: second guess for secant method
%   dxtol: termination threshold (stop when interval abs(x_{i+1}-x_i) < dxtol)
%   ftol: termination threshold (stop when abs(f(x_{i}))<ftol
%   max_iter: maximum iteration limit
%   dxmax: threshold for checking for a divide by zero error: 
%   terminate when abs(x_{i+1}-x_i) > dxmax, where dxmax is a very large number
%OUTPUTS
%   x: estimate for root of fun
%   exit_flag: an integer indicating whether or not the solver succeeded
function [x, exit_flag] = secant_solver(fun, x0, x1, dxtol, ftol, max_iter, dxmax)
    max_iter = max_iter - 1;
    
    x = x1 - (fun(x1) * ((x1 - x0) / (fun(x1) - fun(x0))));  
  
    if (abs(fun(x)) <= ftol)
        exit_flag = 1;
        return
    elseif (abs(x - x1) > dxmax)
        exit_flag = 0;
        return
    elseif (abs(x - x1) <= dxtol)
        exit_flag = 0;
        return
    elseif (max_iter == 0)
        exit_flag = 0;
        return
    else
        [x, exit_flag] = secant_solver(fun, x1, x, dxtol, ftol, max_iter, dxmax);
    end
end