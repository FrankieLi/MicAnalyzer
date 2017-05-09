function output = TransformAndReduce(mEBSD, g, pm)


Eu = EulerFromR(g, pm);


output = TransformEBSD(mEBSD, [0, 0, 0], Eu);
output = ReduceEBSDToFZ(output);