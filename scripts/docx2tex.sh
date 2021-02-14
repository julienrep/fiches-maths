#!/bin/bash
if [ "$#" -ne 2 ]; then
    echo "usage: $0 <header additions> <input file>"
	exit
fi
file_add=$1
file_docx=$2
file_tex=$2.tex

# convert docx to tex
pandoc $file_docx -s -o $file_tex

# now we need to change header to handle special unicode characters
line=$(grep -n 'usepackage' $file_tex | cut -d ":" -f 1)
line=$(echo $line | cut -d " " -f 1)
# trick to include header-additions-file into input-file header
file_tex2=$file_tex.temp
{ head -n $(($line-1)) $file_tex; cat $file_add; tail -n +$line $file_tex; } > $file_tex2
rm $file_tex
mv $file_tex2 $file_tex

#now rename media to be specific to that file
fileshort=$(echo $file_docx | rev | cut -d "/" -f 1 | rev | sed "s/\./_/g")
sed -i -e "s/media\/image/media\/${fileshort}_image/g" $file_tex
