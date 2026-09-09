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
function [x, exit_flag] = bisection_solver(fun, x_left, x_right, dxtol, ftol, max_iter)
    % calculates the midpoint
    x = (x_left + x_right) / 2;

    % decrement the max iteration
    max_iter = max_iter - 1;
    
    % if there is no zero crossing between the left and right, end fail
    if fun(x_left) * fun(x_right) > 0
        exit_flag = 0;
        return
    end
    
    % if either the left or right guess is already within tolerance of
    % being 0, end and success
    if (abs(fun(x_left)) <= ftol)
        x = x_left;
        exit_flag = 1;
        return;
    elseif (abs(fun(x_right)) <= ftol)
        x = x_right;
        exit_flag = 1;
        return;
    end
    
    % if y value of next x is close to 0, success
    if (abs(fun(x)) <= ftol) 
        exit_flag = 1;
        return
    % if the interval gets really small and converges no on zero, fail
    elseif (abs(x_right - x_left) <= dxtol) && (abs(fun(x)) > ftol) 
        exit_flag = 0;
        return
     % if the max iterations run out
    elseif (max_iter == 0)
        exit_flag = 0;
        return
    end
    
    % if there is a zero crossing on the left side, we use the new interval
    % [x_left x], else we use [x, x_right]
    if fun(x) * fun(x_left) < 0
        [x, exit_flag] = bisection_solver(fun,x_left,x,dxtol,ftol,max_iter);
    else
        [x, exit_flag] = bisection_solver(fun,x,x_right,dxtol,ftol,max_iter);
    end
end