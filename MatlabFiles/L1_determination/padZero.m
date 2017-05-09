%
%  Given an inter n and the length of the string,
%  return a string with numLen character containing
%  n padded with zeros.
%
%
%
function intString = padZero(n, numLen)

if(n ~= 0)
  numDigit = floor(log10(n)) + 1;
else
  numDigit = 1;
end

intString = num2str(n);

for i = (numDigit+1):numLen

  intString = sprintf('0%s', intString);

end
