%Root finding function via bisection algorithm
%INPUTS:
%   fun: the function we are computing the root of
%   x_left: left guess
%   x_right: right guess
%   note that f(x_left) and f(x_right) should have different signs
%   dxtol: termination threshold (stop when interval x_right-x_left < dxtol)
%   ftol: termination threshold (stop when abs(f(x_guess))<ftol
%   max_iter: maximum iteration limit
%OUTPUTS
%   x: estimate for root of fun
%   exit_flag: an integer indicating whether or not the solver succeeded
function [x, exit_flag] = bisection_solver(fun,x_left,x_right,dxtol,ftol,max_iter)
    x = (x_left + x_right) / 2;
    max_iter = max_iter - 1;

    if fun(x_left) * fun(x_right) > 0
        exit_flag = 0;
        return
    end

    if fun(x_left) == 0
        x = x_left;
        exit_flag = 1;
        return;
    elseif fun(x_right) == 0
        x = x_right;
        exit_flag = 1;
        return;
    end

    if (abs(fun(x)) <= ftol) 
        exit_flag = 1;
        return
    elseif (abs(x_right - x_left) <= dxtol) && (abs(fun(x)) > ftol) 
        exit_flag = 0;
        return
    elseif (max_iter == 0)
        exit_flag = 0;
        return
    end

    if fun(x) * fun(x_left) < 0
        [x, exit_flag] = bisection_solver(fun,x_left,x,dxtol,ftol,max_iter);
    else
        [x, exit_flag] = bisection_solver(fun,x,x_right,dxtol,ftol,max_iter);
    end
end