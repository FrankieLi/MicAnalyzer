%
%  Generate workspaces for cubic fundamental region.
%
%-------------------- User Input
%
fr_refine =   3;  % refinement level on FR
sp_refine =  10;  % refinement level on sphere
per_fiber = 100;  % points per fiber
%
pf_hkls ={[1 1 1], [1 0 0], [1 1 0] };
%
wsopts = {...
    'MakePoleFigures',   pf_hkls, ...
    'PointsPerFiber',  per_fiber, ...
    'MakeFRL2IP',           'on', ...
    'MakeFRH1IP',           'on', ...
    'MakeSphL2IP',          'on', ...
    'MakeSphH1IP',          'on'  ...
	 };
%
%-------------------- Build workspace
%
cfr0 = CubBaseMesh;
csym = CubSymmetries;
cfr  = RefineMesh(cfr0, fr_refine, csym);
cfr.symmetries = csym;
%
sph0 = SphBaseMesh(2, 'Hemisphere', 'on'); % 2d sphere
sph  = RefineMesh(sph0, sp_refine);
sph.crd = UnitVector(sph.crd);
%
wscub = Workspace(cfr, sph, wsopts{:});
save wscub wscub wsopts

