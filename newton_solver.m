%Root finding function via Newton's method
%INPUTS:
%   fun: the function we are computing the root of
%   Note that fun(x) should output [f,dfdx], where dfdx is the derivative of f
%   (see test_func01 below for example)
%   x0: initial guess for Newton's method
%   dxtol: termination threshold (stop when interval abs(x_{i+1}-x_i) < dxtol)
%   ftol: termination threshold (stop when abs(f(x_{i}))<ftol
%   max_iter: maximum iteration limit
%   dxmax: threshold for checking for a divide by zero error: 
%   terminate when abs(x_{i+1}-x_i) > dxmax, where dxmax is a very large number
%OUTPUTS
%   x: estimate for root of fun
%   exit_flag: an integer indicating whether or not the solver succeeded
function [x, exit_flag] = newton_solver(fun,x0,dxtol,ftol,max_iter,dxmax)
    
    % increment the max_iter input down every iteration
    max_iter = max_iter - 1;
   
    % calculate the current y value and derivative at the old x guess
    [fval,dfdx] = fun(x0);

    % if the y value is extremely close to 0, within the tolerance, exit
    if (abs(fval) <= ftol)
        x = x0;
        exit_flag = 1;
        return
    end

    % if the derivative at the point is 0, break
    if dfdx == 0
        x = x0;
        exit_flag = 0;
        return
    end
    
    % calculate the new x value using Newton's Method
    x = x0 - (fval / dfdx);
    
    % check for division by zero
    if (abs(x - x0) > dxmax)
        exit_flag = 0;
        return
    % check if interval is very small and hasn't converged properly
    elseif (abs(x - x0) <= dxtol)
        exit_flag = 0;
        return
    % check if we have went through too many iterations
    elseif (max_iter == 0)
        exit_flag = 0;
        return
    else
        % if no flags have popped up, send the new x guess into the solver
        [x, exit_flag] = newton_solver(fun, x, dxtol, ftol, max_iter, dxmax);
    end

end
