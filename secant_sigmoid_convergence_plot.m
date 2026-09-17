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
    num_iter = 150;
    x0_list = linspace(0, 50, num_iter);
    x1_list = linspace(0, 50, num_iter);
    
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
    
    % uses nested for loops to test every single combination of x0 and x1
    % values
    for i = 1:num_iter
        for j = 1:num_iter
            % sets the x0 and x1 to use for that iteration
            x0 = x0_list(i);
            x1 = x1_list(j);
            
            % runs the solver
            [~, exit_flag, x_list] = secant_solver_rec(@test_function03, x0, x1, dxtol, ftol, max_iter, dxmax);
            
            % adds the current x, next x and its index to their lists as well
            % as the newest exit flag
            x_current_list = [x_current_list, x_list(1:end-1)];
            x_next_list = [x_next_list, x_list(2:end)];
            index_list = [index_list, 1:length(x_list)-1];
            % creates a square matrix of exit flag values based on
            % combination
            exit_flag_list(i, j) = exit_flag;
        end
    end
    
    % plotting the 2D painting of whether a combination of x0 and x1
    % results in the solver succeeding or failing
    imagesc(x0_list, x1_list, exit_flag_list)
    hold on;

    % flips the y axis
    axis xy;
    
    % font size
    ax = gca;
    ax.FontSize = 30;

    % labels
    title("Initial Guess Convergence for Secant Method (Sigmoid Function)", "Interpreter", "latex");
    xlabel("$x_{0}$ Guess Value (-)", "Interpreter", "latex")
    ylabel("$x_{1}$ Guess Value (-)", "Interpreter", "latex")
    xlim([0 50])
    ylim([0 50])
    legend;
    
    % plotting the actual root and its horizontal and vertical lines
    plot([0 50], [target_root target_root], "y--", "LineWidth", 2, DisplayName="Root Location X")
    plot([target_root target_root], [0 50], "y--", "LineWidth", 2, DisplayName="Root Location Y")
    scatter(target_root, target_root, 300, "green", "filled", DisplayName="Calculated Root Location")

    % adding legend entries
    scatter(nan, nan, 100, "blue", "filled", DisplayName="Success - Converged");
    scatter(nan, nan, 100, "red", "filled", DisplayName="Failed to Converge");
    legend("Location", "northeast", "Interpreter", "latex");

    % coloring everything 
    customMap = [1 0 0; 0 0 1];
    colormap(customMap);
    cb = colorbar;
    cb.Ticks = [0, 1];
    cb.TickLabels = {'Failed', 'Converged'};
    cb.TickLabelInterpreter = 'latex';

    % high res export
    myfig = gcf(); %set myfig to the current figure
    exportgraphics(myfig , 'SECANT_SIGMOID_CONVERGENCE_DIAGRAM.png', 'Resolution', 600); %saves plot to plot_name at high resolution
end