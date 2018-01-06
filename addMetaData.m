function addMetaData ()

[filename,filepath] = uigetfile();
name = strsplit(filename, '.');
name = name{1};
name = strcat(name,'M.dat');
read = fopen(strcat(filepath, filename),'r');
write = fopen(strcat(filepath,name),'w');


meta = metaData(str2num(fgets(read)));
meta.testID = 5;
meta = [meta,1,3000];

strmeta = sprintf('%d\t',meta);

strmeta = sprintf('%s\n',strmeta(1:end-1));


fprintf(write,'%s',strmeta);

i=0;
while(~feof(read))
    fprintf(write,'%s',fgets(read));
    i = i+1;
end
i
fclose(read);
fclose(write);
