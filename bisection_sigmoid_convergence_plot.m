function bisection_sigmoid_convergence_plot()
    close all;
    %Initial guess near the root we are analyzing convergence behavior
    %(you will need to change this depending on the test function and root)
    x0_ref = 0.5;
    target_root = fzero(@test_function03,x0_ref);
    
    % solver parameters
    dxtol = 1e-14;
    ftol = 1e-14;
    max_iter = 10000;
    
    % setting number of iterations for the sweep and the sweep bounds
    num_iter = 500;
    x_left_list = linspace(0, 50, num_iter);
    x_right_list = linspace(0, 50, num_iter);

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
        for m = 1:num_iter
            % sets the first x0 and x1 to use for that iteration
            x_left = x_left_list(n);
            x_right = x_right_list(m);
            
            % runs the solver
            [~, exit_flag, x_list] = bisection_solver_rec(@test_function03, x_left, x_right, dxtol, ftol, max_iter, NaN);
    
            % adds the current x, next x and its index to their lists
            x_current_list = [x_current_list, x_list(1:end-1)];
            x_next_list = [x_next_list, x_list(2:end)];
            index_list = [index_list, 1:length(x_list)-1];

            exit_flag_list(n, m) = exit_flag;
        end
    end

    % plotting the 2D painting of whether a combination of x0 and x1
    % results in the solver succeeding or failing
    imagesc(x_left_list, x_right_list, exit_flag_list)
    hold on;

    % flips the y axis
    axis xy;
    
    % font size
    ax = gca;
    ax.FontSize = 20;

    % labels
    title("Bisection Method Guess Convergence Diagram", "Interpreter", "latex");
    xlabel("$x_{left}$ Guess Value (-)", "Interpreter", "latex")
    ylabel("$x_{right}$ Guess Value (-)", "Interpreter", "latex")
    xlim([0 50])
    ylim([0 50])
    legend("Interpreter", "latex");
    
    % plotting the actual root and its horizontal and vertical lines
    scatter(target_root, target_root, 300, "green", "filled", DisplayName="Calculated Root Location")
    plot([0 50], [target_root target_root], "y--", "LineWidth", 2, DisplayName="Root Location X")
    plot([target_root target_root], [0 50], "y--", "LineWidth", 2, DisplayName="Root Location Y")

    % adding legend entries
    scatter(nan, nan, 100, "blue", "filled", DisplayName="Success - Converged");
    scatter(nan, nan, 100, "red", "filled", DisplayName="Failed to Converge");
    legend("Location","northwest", "Interpreter","latex");

    % coloring everything 
    customMap = [1 0 0; 0 0 1];
    colormap(customMap);
    cb = colorbar;
    cb.Ticks = [0, 1];
    cb.TickLabels = {'Failed', 'Converged'};
    cb.TickLabelInterpreter = 'latex';

    % high res export
    myfig = gcf(); %set myfig to the current figure
    exportgraphics(myfig , 'BISECTION_SIGMOID_CONVERGENCE_DIAGRAM.png', 'Resolution', 600); %saves plot to plot_name at high resolution
    
    % clf
    % %example for how to plot fit line
    % %generate x data on a logarithmic range
    % fit_line_x = 10.^[-16:.01:1];
    % %compute the corresponding y values
    % fit_line_y = k*fit_line_x.^p;
    % disp(p)
    % disp(k)
    % %plot on a loglog plot.
    % loglog(fit_line_x,fit_line_y,'k-','linewidth',2)
end

