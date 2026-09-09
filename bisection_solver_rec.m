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
function [x_final, exit_flag, x_list] = bisection_solver_rec(fun, x_left, x_right, dxtol, ftol, max_iter, x_discarded)
    % calculates the midpoint
    x = (x_left + x_right) / 2;

    % decrement the max iteration
    max_iter = max_iter - 1;
    
    % if there is no zero crossing between the left and right, end fail
    if fun(x_left) * fun(x_right) > 0
        exit_flag = 0;
        % records the final x midpoint even if it wasn't the root
        x_final = x;
        x_list = x_discarded;
        return
    end
    
    % if either the left or right guess is already within tolerance of
    % being 0, end and success
    if (abs(fun(x_left)) <= ftol)
        exit_flag = 1;
        x_final = x_left;
        % the number that was most recently discarded gets recorded into 
        % the x_list to be brought up the recursion stack and combined into
        % the full list
        x_list = x_discarded;
        return;
    elseif (abs(fun(x_right)) <= ftol)
        exit_flag = 1;
        x_final = x_right;
        x_list = x_discarded;
        return;
    end
    
    % if y value of next x is close to 0, success
    if (abs(fun(x)) <= ftol) 
        exit_flag = 1;
        x_final = x;
        x_list = x_discarded;
        return
    % if the interval gets really small and converges no on zero, fail
    elseif (abs(x_right - x_left) <= dxtol) && (abs(fun(x)) > ftol) 
        exit_flag = 0;
        x_final = x;
        x_list = x_discarded;
        return
     % if the max iterations run out
    elseif (max_iter == 0)
        exit_flag = 0;
        x_final = x;
        x_list = x_discarded;
        return
    end
    
    % if there is a zero crossing on the left side, we use the new interval
    % [x_left x], else we use [x, x_right], the discarded point goes up
    % into the function that called it, either the left or right function
    % as the x_discarded term
    if fun(x) * fun(x_left) < 0
        [x_final, exit_flag, next_x_list] = bisection_solver_rec(fun, x_left, x, dxtol, ftol, max_iter, x_right);
        x_list = [x_right, next_x_list];
    else
        [x_final, exit_flag, next_x_list] = bisection_solver_rec(fun, x, x_right, dxtol, ftol, max_iter, x_left);
        x_list = [x_left, next_x_list];
    end
end