%%
%%  TransformNormal
%%
%%  
%%
%%
%%
function processedNormals = TransformNormal( crystalRMats, wNormals, sToTranspose )

if( nargin < 3)
  sToTranspose ='';
end

if ( strcmp( sToTranspose, 'transpose' ) )
  bTransposeRMat = true;
else
  bTransposeRMat = false;
end

processedNormals = zeros(size(wNormals,1), 4);

if( bTransposeRMat )
  
  Xlab = wNormals(:,1);
  Ylab = wNormals(:,2);
  Zlab = wNormals(:,3);
  Xcrys = squeeze(crystalRMats(1,1,:)).*Xlab + ...
          squeeze(crystalRMats(1,2,:)).*Ylab + ...
          squeeze(crystalRMats(1,3,:)).*Zlab;
  Ycrys = squeeze(crystalRMats(2,1,:)).*Xlab + ...
          squeeze(crystalRMats(2,2,:)).*Ylab + ...
          squeeze(crystalRMats(2,3,:)).*Zlab;
  Zcrys = squeeze(crystalRMats(3,1,:)).*Xlab + ...
          squeeze(crystalRMats(3,2,:)).*Ylab + ...
          squeeze(crystalRMats(3,3,:)).*Zlab;
  processedNormals = [Xcrys, Ycrys, Zcrys];
else
  Xlab = wNormals(:,1);
  Ylab = wNormals(:,2);
  Zlab = wNormals(:,3);
  Xcrys = squeeze(crystalRMats(1,1,:)).*Xlab + ...
          squeeze(crystalRMats(2,1,:)).*Ylab + ...
          squeeze(crystalRMats(3,1,:)).*Zlab;
  Ycrys = squeeze(crystalRMats(1,2,:)).*Xlab + ...
          squeeze(crystalRMats(2,2,:)).*Ylab + ...
          squeeze(crystalRMats(3,2,:)).*Zlab;
  Zcrys = squeeze(crystalRMats(1,3,:)).*Xlab + ...
          squeeze(crystalRMats(2,3,:)).*Ylab + ...
          squeeze(crystalRMats(3,3,:)).*Zlab;
  processedNormals = [Xcrys, Ycrys, Zcrys];
end
end