function odf = ProcessAggregate(ws, quat, wts, method, varargin)
%   STATUS:  in development
%
%   USAGE:
%
%   odf = ProcessAggregate(ws, quat, wts, method, <options>)
%
%   INPUT:
%
%   <options> is a sequence of parameter, value pairs
%             Available options are listed below.  Default values,
%             if set, are shown in brackets.
%
%       'GaussianRadius',  10 * pi/180 [ten degrees]
%
%   OUTPUT:
%
%   NOTES:
%
MyName = mfilename;
%
%-------------------- Defaults and Keyword Arguments
%
ToRadians = pi/180;
optcell = {...
    'GaussianRadius',  ToRadians*5
       };
%
options = OptArgs(optcell, varargin);

%
rod = ToFundamentalRegion(quat, ws.frmesh.symmetries);
if isempty(wts)
  wts = ones(1, size(quat, 2));
end

switch lower(method)
  %
 case 'discretedelta'
  disp 'using discrete delta'
  %
  [elem, ecrd] = MeshCoordinates(ws.frmesh, rod);
  odf = DiscreteDelta(ws.frmesh, ws.frmesh.l2ip, elem, ecrd, wts);
  odf = odf ./ MeanValue(odf, ws.frmesh.l2ip);
  %
 case 'aggregatefunction'
  disp 'using aggregate function'
  odf = AggregateFunction(ws.frmesh.crd(:, 1:ws.frmesh.numind), rod, wts, ...
			  @RodGaussian, options.GaussianRadius, ws.frmesh.symmetries);
  odf = odf' ./ MeanValue(odf, ws.frmesh.l2ip);
 case 'positivediscretedelta'
  disp 'using positive discrete delta'
  ncrd = size(ws.frmesh.crd, 2);
  %
  npts   = length(elem);
  [m, n] = size(ecrd);
  %
  mn = m*n;
  i = ws.frmesh.con(:, elem); i = i(:);
  j = ones(mn, 1);
  w = repmat(wts(:)', [m 1]); w = w(:);
  v = ecrd(:).*w;
  %
  rhs = sparse(i, j, v, ncrd, 1);
  rhs = full(rhs);
  %  
  %  Now reduce according to equivalence.
  %
  rhs = EqvReduce(rhs', ws.frmesh.eqv);
  %
  objfun = @(x) pddObjective(ws.frmesh.l2ip, rhs(:), x);
  x0 = DiscreteDelta(ws.frmesh, ws.frmesh.l2ip, elem, ecrd, wts);
  x0(x0 < 0) = 0;
  lb = zeros(length(rhs), 1);
  opts = optimset('Display', 'iter', 'GradObj', 'on');
  odf = fmincon(objfun, x0, [], [], [], [], lb, [], [], opts);
  odf = odf ./ MeanValue(odf, ws.frmesh.l2ip);
  %
end

function [f, g] = pddObjective(mat, rhs, x)
% PDDOBJECTIVE - 
%   
mx = mat*x - rhs;
f = mx'*mx;
g = 2*mat*mx;
