function streamSave(fileName,bitStream)
fh=fopen(fileName,'w');
fwrite(fh,bitStream);
fclose(fh);
end