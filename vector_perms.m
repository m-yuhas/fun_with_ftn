function permutations = vector_perms(varargin)
% vector_perms  Generate a matrix whose rows are all possible permutations of
%   the elements of the argument vectors.  Each column may only contain
%   entries in the corresponding argument vector, for example:
%
%   vector_perms([1, 2] [3, 4]) would yield:
%
if size(varargin, 2) < 1
    error('vector_perms requires at least 1 argument');
end
permutations = varargin{1}';
for idx = 2:size(varargin, 2)
    current_vector = varargin{idx};
    current_vector_len = size(current_vector, 2);
    old_len = size(permutations, 1);
    new_len = current_vector_len * old_len;
    permutations = [repmat(permutations, current_vector_len, 1), ...
                    reshape(repmat(current_vector, old_len, 1), new_len, 1)];
end
end
