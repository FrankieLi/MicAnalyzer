Grain boundary motion mapping with kdtree:

Functions in package:

GetBoundaryDisplace_wkdtree.m
NaiveKdtree.m
ConsolidateGrainIDPairs.m
DisplacementBoth.m
DisplacementSingle.m
DisplaceVectors_useBndSize.m

Matlab command line to run package:

>> [ptMap1, ptMap2, displaceMap] = GetBoundaryDisplace_wkdtree(filename1, filename2, mis_thresh_deg, delta_r_3D, NptsToAvg, mapCon, densityCon, isoCon, displaceFilePrefix)

filename contains a boundary file with boundary endpoints, misorientation and grain ID pairs.

Package currently deals with x,y,z and grain ID #s.  Boundary segments with misorientation mis_thresh_deg 
are used. 

Needs incorporated:

Adding misorientation to kdtree search.  (Currently kdtree is made with x,y,z and grain ID pairs.)

kdtree package can be found at: http://www.mathworks.com/matlabcentral/fileexchange/4586

