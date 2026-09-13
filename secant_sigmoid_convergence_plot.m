function secant_sigmoid_convergence_plot()
    close all;
    %Initial guess near the root we are analyzing convergence behavior
    %(you will need to change this depending on the test function and root)
    x0_ref = 26;
    target_root = fzero(@test_function03,x0_ref);
    
    % solver parameters
    dxtol = 1e-14;
    ftol = 1e-14;
    max_iter = 10000;
    dxmax = 1e7; %Newton and Secant only
    
    % setting number of iterations for the sweep and the sweep bounds
    num_iter = 1000;
    x0_list = linspace(0, 26, num_iter);
    x1_list = linspace(26.2, 50, num_iter);
    
    %list of estimate at current iteration (x_{n})
    %compiled across all trials
    x_current_list = [];
    
    %list of estimate at next iteration (x_{n+1})
    %compiled across all trials
    x_next_list = [];
    
    %keeps track of which iteration (n) in a trial
    %each data point was collected from
    index_list = [];

    % list of exit flags
    exit_flag_list = [];
    
    for n = 1:num_iter
        % sets the first x0 and x1 to use for that iteration
        x0 = x0_list(n);
        x1 = x1_list(n);
        
        % runs the solver
        [~, exit_flag, x_list] = secant_solver_rec(@test_function03, x0, x1, dxtol, ftol, max_iter, dxmax);
        
        % adds the current x, next x and its index to their lists as well
        % as the newest exit flag
        x_current_list = [x_current_list, x_list(1:end-1)];
        x_next_list = [x_next_list, x_list(2:end)];
        index_list = [index_list, 1:length(x_list)-1];
        exit_flag_list = [exit_flag_list, exit_flag];
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
    
    % plotting the new sigmoid test function
    figure; hold on;
    ax = gca;
    ax.FontSize = 30; % Changes tick labels and scales labels
    xvals = linspace(-50, 50, 201);
    [yvals,~] = test_function03(xvals);
    plot(xvals, yvals,'k','linewidth', 4, "DisplayName", "Sigmoid Function");
    xlabel('Function Input: x'); ylabel('Function Output: f(x)'); title("Secant Method Guess Convergence Plot");
    xlim([0 50])
    ylim([-8 8])
    legend(location="southeast");
    
    % plotting the horizontal line for y = 0
    plot(xvals, 0*xvals,'k--','linewidth',1, "DisplayName", "Y = 0 Line");

    % plotting the actual root calculated by fzero
    scatter(target_root, test_function03(target_root), 300, "blue", "filled", DisplayName="Calculated Root Location")
    
    % for every iteration in the run, if the exit flag of that iteration is
    % a 1, plot the initial guess in cyan, if its 0, then plot the initial
    % guess in red
    for i = 1:num_iter
        if (exit_flag_list(i) == 1)
            scatter(x0_list(i), test_function03(x0_list(i)), 75, "cyan", "filled", "HandleVisibility", "off");
        else
            scatter(x0_list(i), test_function03(x0_list(i)), 75, "red", "filled", "HandleVisibility", "off");
        end
    end

    % makes only two legend entries for the successes and failures
    scatter(NaN, NaN, 75, "cyan", "filled", "DisplayName", "Successful Solver Run");
    scatter(NaN, NaN, 75, "red", "filled", "DisplayName", "Failed Solver Run");
end