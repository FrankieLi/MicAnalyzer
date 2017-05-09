function R = quaternionToR(q)

q = circshift( q', 1);  % get it into ODFPF convention
R = RMatOfQuat( q );


