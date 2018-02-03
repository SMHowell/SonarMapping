function newbyte = clearMSB(oldbyte)

oldbin = dec2bin(oldbyte);
newbyte = bin2dec(oldbin(2:end));

end