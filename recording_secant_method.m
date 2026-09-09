function recording_secant_method()
    close all;
    %Initial guess near the root we are analyzing convergence behavior
    %(you will need to change this depending on the test function and root)
    x0_ref = 0.5;
    target_root = fzero(@test_func01,x0_ref);
    
    % solver parameters
    dxtol = 1e-14;
    ftol = 1e-14;
    max_iter = 10000;
    dxmax = 1e7; %Newton and Secant only
    
    % setting number of iterations for the sweep and the sweep bounds
    num_iter = 1000;
    x0_list = linspace(-5, 0.6, num_iter);
    x1_list = linspace(0.8, 5, num_iter);
    
    %list of estimate at current iteration (x_{n})
    %compiled across all trials
    x_current_list = [];
    
    %list of estimate at next iteration (x_{n+1})
    %compiled across all trials
    x_next_list = [];
    
    %keeps track of which iteration (n) in a trial
    %each data point was collected from
    index_list = [];
    
    for n = 1:num_iter
        % sets the first x0 and x1 to use for that iteration
        x0 = x0_list(n);
        x1 = x1_list(n);
        
        % runs the solver
        [~, ~, x_list] = secant_solver_rec(@test_func01, x0, x1, dxtol, ftol, max_iter, dxmax);
        
        % adds the current x, next x and its index to their lists
        x_current_list = [x_current_list, x_list(1:end-1)];
        x_next_list = [x_next_list, x_list(2:end)];
        index_list = [index_list, 1:length(x_list)-1];
    end
    
    % calculating current and next error
    e_n = abs(x_current_list - target_root);
    e_n1 = abs(x_next_list - target_root);
    
    % trim boundaries
    xmin = 1.4e-8;
    xmax = 0.011;
    
    % mask to remove all values outside boundary
    mask = (e_n >= xmin) & (e_n <= xmax);
    
    % new trimmed error values to use for fit line
    e_n_new = e_n(mask);
    e_n1_new = e_n1(mask);
    
    % plotting the full secant method plot
    figure;
    loglog(e_n, e_n1, 'r.', 'MarkerSize', 10, 'DisplayName', 'Secant Method Raw Error');
    hold on;
    
    % plotting the fit line on top of the plot
    [p, k] = generate_error_fit(e_n_new, e_n1_new);
    fit_line_x = 10.^(-8:.01:-1);
    fit_line_y = k * fit_line_x .^ p;
    loglog(fit_line_x,fit_line_y,'k-','linewidth', 3, 'DisplayName', 'Filtered Convergence Fit Line')
    hold off;
    ax = gca;
    ax.FontSize = 30;
    title("Secant Method Convergence Rate Plot")
    xlabel("\epsilon_{n} (-)")
    ylabel("\epsilon_{n+1} (-)")
    legend(location="southeast")
end

% test function
function [fval,dfdx] = test_func01(x)
    fval = (x.^3)/100 - (x.^2)/8 + 2*x + 6*sin(x/2+6) -.7 - exp(x/6);
    dfdx = 3*(x.^2)/100 - 2*x/8 + 2 +(6/2)*cos(x/2+6) - exp(x/6)/6;
end