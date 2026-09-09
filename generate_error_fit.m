function[p,k]=generate_error_fit(x_regression,y_regression)
    %generate Y, X1, and X2
    
    Y=log(y_regression)';
    X1=log(x_regression)';
    X2=ones(length(X1),1);

    %run the regression
    coeff_vec=regress(Y,[X1,X2]);

    %pull out the coefficients from the fit
    p=coeff_vec(1);
    k=exp(coeff_vec(2));
end