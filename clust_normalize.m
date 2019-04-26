function data=clust_normalize(data,method)
% Normalization of the data. There are two methods
% Xn = X - Xmin / (Xmax-Xmin)  (linear method 'range')
% Xn = X - mean(X) / std(X)   (Gaussian method 'var')
% The output data.Xold the data, data.X the normalized data,
% if the method used is 'range' then a vector with the minimum and maximum
% of each column (regressor) data.min and data.max
% If the method used is 'var', a vector with the mean values and standart
% deviation of each column X in data.mean and data.std

data.Xold=data.X;
if strcmp(method,'range')
     data.min=min(data.X);
     data.max=max(data.X);
     data.X=(data.X-repmat(min(data.X),size(data.X,1),1))./(repmat(max(data.X),...
     size(data.X,1),1)-repmat(min(data.X),size(data.X,1),1));
 elseif strcmp(method,'var')
     data.mean=mean(data.X);
     data.std=std(data.X);
     %data.X=(data.X-repmat(mean(data.X),size(data.X,1),1))./(2*repmat(std(data.X),size(data.X,1),1));
     data.X=(data.X-repmat(mean(data.X),size(data.X,1),1))./(repmat(std(data.X),size(data.X,1),1));
elseif strcmp(method,'var2')
     data.mean=mean(data.X);
     data.std=std(data.X);
     data.X=(data.X-repmat(mean(data.X),size(data.X,1),1))./(2*repmat(std(data.X),size(data.X,1),1));
     data.min=min(data.X);
     data.max=max(data.X);
     data.X=(data.X-repmat(min(data.X),size(data.X,1),1))./(repmat(max(data.X),...
     size(data.X,1),1)-repmat(min(data.X),size(data.X,1),1));
else
     error('Unknown method given')
end
