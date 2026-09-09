function recording_bisection_method()
    close all;
    %Initial guess near the root we are analyzing convergence behavior
    %(you will need to change this depending on the test function and root)
    x0_ref = 0.5;
    target_root = fzero(@test_func01,x0_ref);
    
    % solver parameters
    dxtol = 1e-14;
    ftol = 1e-14;
    max_iter = 10000;
    
    % setting number of iterations for the sweep and the sweep bounds
    num_iter = 1000;
    x_left_list = linspace(-5, 0.6, num_iter);
    x_right_list = linspace(0.8, 5, num_iter);
    
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
        x_left = x_left_list(n);
        x_right = x_right_list(n);
        
        % runs the solver
        [~, ~, x_list] = bisection_solver_rec(@test_func01, x_left, x_right, dxtol, ftol, max_iter, NaN);

        % adds the current x, next x and its index to their lists
        x_current_list = [x_current_list, x_list(1:end-1)];
        x_next_list = [x_next_list, x_list(2:end)];
        index_list = [index_list, 1:length(x_list)-1];
    end
    
    % calculating current and next error
    e_n = abs(x_current_list - target_root);
    e_n1 = abs(x_next_list - target_root);
    
    % trim boundaries
    xmin = 1.5e-14;
    xmax = 0.05;

    % mask to remove all values outside boundary
    mask = (e_n >= xmin) & (e_n <= xmax);

    % new trimmed error values to use for fit line
    e_n_new = e_n(mask);
    e_n1_new = e_n1(mask);
    
    % plotting the full secant method plot
    figure;
    loglog(e_n, e_n1, 'r.', 'MarkerSize', 10, 'DisplayName', 'Bisection Method Raw Error');
    hold on;
    
    % plotting the fit line on top of the plot
    [p, k] = generate_error_fit(e_n_new, e_n1_new);
    fit_line_x = 10.^(-10:.01:-1);
    fit_line_y = k * fit_line_x .^ p;
    loglog(fit_line_x,fit_line_y,'k-','linewidth', 3, 'DisplayName', 'Filtered Convergence Fit Line')
    hold off;
    ax = gca;
    ax.FontSize = 30;
    title("Bisection Method Convergence Rate Plot")
    xlabel("\epsilon_{n} (-)")
    ylabel("\epsilon_{n+1} (-)")
    legend(location="southeast")
end