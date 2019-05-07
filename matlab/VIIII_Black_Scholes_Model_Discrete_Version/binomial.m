function c = binomial(n, k)
% BINOMIAL Binomial coefficient.
%
%  If the arguments are both non-negative integers with 0 <= K <= N, then
%  BINOMIAL(N, K) =  N!/K!/(N-K)!, which is the number of distinct sets of
%  K objects that can be chosen from N distinct objects.
%  When N or K(or both) are N-D matrices, BINOMIAL(N, K) is the coefficient
%  for each pair of elements. 
%
%  If N and K are integers that do not satisfy 0 <= K <= N, or N and K are
%  non-integers , then the general definition is used, that is
%
%       BINOMIAL(N, K) = GAMMA(N+1) / (GAMMA(K+1) / GAMMA(N-K+1))
%
%  If N is a non-negative integer, BINOMIAL(N) = BINOMIAL(N, 0:N)
%
%  BINOMIAL only supports floating point input arguments.


% Mukhtar Ullah
% mukhtar.ullah@informatik.uni-rostock.de
% Created: 5 Oct, 2004
% Last Modified: 18 Oct, 2010

error(nargchk(1, 2, nargin));

if nargin == 1
    validateattributes(n, {'numeric'}, {'scalar', 'real', 'nonnegative'});
    c = diag(fliplr(pascal(floor(n) + 1))).';
else  
    assert(isscalar(n) || isscalar(k) || isequal(size(n),size(k)), ...
        'Non-scalar arguments must have the same size.')
    validateattributes([n(:); k(:)], {'numeric'}, {'real', 'nonnegative'});
    c = exp(gammaln(n+1) - gammaln(k+1) - gammaln(n-k+1));  % binomial coefficient
    i = ( n==floor(n+.5) & k==floor(k+.5) );
    c(i) = floor(c(i)+.5);                                  % number of combinations
end

