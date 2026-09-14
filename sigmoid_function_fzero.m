function sigmoid_function_fzero() 

% Define the function in the range [0, 50]
    x_vals = linspace(0, 50, 300);
    f_x = test_function03(x_vals);
    x_root = fzero(@test_function03, 1); % root of the function

    % Generate a plot of the function
    figure(); hold on;
    plot(x_vals, f_x, 'k','LineWidth', 3, 'DisplayName', 'Sigmoid Function');
    plot(x_root, test_function03(x_root), 'b.', 'MarkerSize', 20); % Location of the root
    yline(0, 'k--', 'displayname', 'x-axis'); % x-axis

    % Run fzero for each point in the function
    for i = 1:length(x_vals)
        current_guess = x_vals(i);
        x_current = fzero(@test_function03, current_guess);

        % Plot the results
        if abs(x_current - x_root) < 1e-5
            plot(x_vals(i), f_x(i), 'c.', 'MarkerSize', 10);
        else
            plot(x_vals(i), f_x(i), 'r.', 'MarkerSize', 12, 'DisplayName', 'Failure to Converge Guess');
        end
    end 

    % Add a title, axis labels, and legend
    title('Fzero Guess Convergence Plot')
    xlabel('x'); ylabel('f(x)'); 
    l = legend('Sigmoid Function', 'Calculated Root Location', 'f(x) = 0 line (x-axis)', 'Successfully Converged Guess');
    set(l, 'location', 'southeast');
    axis([0 50 -5 7])

    % Sigmoid function
    function [f_val,dfdx] = test_function03(x)
    a = 27.3; b = 2; c = 8.3; d = -3;
    H = exp((x-a)/b);
    dH = H/b;
    L = 1+H;
    dL = dH;
    f_val = c*H./L+d;
    dfdx = c*(L.*dH-H.*dL)./(L.^2);
    end
end
