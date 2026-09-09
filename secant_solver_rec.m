%Root finding function via secant method FOR RECORDING ALL OUTPUTS
%INPUTS:
% fun: the function we are computing the root of
% x0: first guess for secant method
% x1: second guess for secant method
% dxtol: termination threshold (stop when interval abs(x_{i+1}-x_i) < dxtol)
% ftol: termination threshold (stop when abs(f(x_{i}))<ftol
% max_iter: maximum iteration limit
% dxmax: threshold for checking for a divide by zero error:
% terminate when abs(x_{i+1}-x_i) > dxmax, where dxmax is a very large number
%OUTPUTS
% x: estimate for root of fun
% exit_flag: an integer indicating whether or not the solver succeeded
% x_list: a list of that iterations [x0 x1 xn]
function [x_final, exit_flag, x_list] = secant_solver_rec(fun, x0, x1, dxtol, ftol, max_iter, dxmax)    
    % evaluate left and right guesses initially
    y0 = fun(x0);
    y1 = fun(x1);
    
    % decrement max iteration
    max_iter = max_iter - 1;
    
    % divide by zero protection
    if (y1 - y0) == 0
        x_final = x1;
        exit_flag = 0;
        x_list = [x0, x1];
        return;
    end
    
    % calculate the next iteration
    x = x1 - (y1 * ((x1 - x0) / (y1 - y0)));  
    fx = fun(x);
  
    % terminate if the solver succeeds or fails

    % if y value of next x is close to 0, success
    if (abs(fx) <= ftol)
        exit_flag = 1;
        x_final = x;
        % records this last iteration's x0 x1 and x
        x_list = [x0, x1, x];
        return
    % for divide by zero
    elseif (abs(x - x1) > dxmax)
        exit_flag = 0;
        x_final = x;
        x_list = [x0, x1, x];
        return
    % for if interval gets really small and doesn't converge on correct
    % value
    elseif (abs(x - x1) <= dxtol)
        exit_flag = 0;
        x_final = x;
        x_list = [x0, x1, x];
        return
    % for if the iterations runs out
    elseif (max_iter == 0)
        exit_flag = 0;
        x_final = x;
        x_list = [x0, x1, x];
        return
    else
        % this recursive call receives the last ever iterations x0 x1 and x
        % and adds back on the previous call's x0 to the front of the last 
        % ever iteration as it goes up the stack, eventually ending up with
        % the entire trial's [x0, x1, xn] values leading to a success
        [x_final, exit_flag, next_x_list] = secant_solver_rec(fun, x1, x, dxtol, ftol, max_iter, dxmax);
        x_list = [x0, next_x_list];
    end
end