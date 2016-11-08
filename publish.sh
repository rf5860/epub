#!/bin/sh

PACKAGE=Fox.G.R-Forward_The_Stars
TITLE=Forward\ the\ Stars
AUTHOR=G.\ R.\ Fox
DATE=2016-11-30
ID=20161130GRFOX

if [ -d "epub" ]; then
	rm -rf epub;
fi;

mkdir epub;

mkdir epub/META-INF
mkdir epub/OEBPS
mkdir epub/OEBPS/images

cp src/container.xml epub/META-INF/container.xml
cp src/mimetype epub/mimetype

cp src/titlepage.xhtml epub/OEBPS/titlepage.xhtml
echo titlepage.xhtml
cp src/toc.xhtml        epub/OEBPS/toc.xhtml
echo toc.xhtml
cp src/foreword.xhtml   epub/OEBPS/foreword.xhtml
cat includes/foreword.xhtml >> epub/OEBPS/foreword.xhtml
echo \</body\> >> epub/OEBPS/foreword.xhtml
echo \</html\> >> epub/OEBPS/foreword.xhtml
echo foreword.xhtml
cp src/afterword.xhtml  epub/OEBPS/afterword.xhtml
cat includes/foreword.xhtml >> epub/OEBPS/afterword.xhtml
echo \</body\> >> epub/OEBPS/afterword.xhtml
echo \</html\> >> epub/OEBPS/afterword.xhtml
echo afterword.xhtml
cp src/toc.ncx         epub/OEBPS/toc.ncx
echo toc.ncx
cp src/content.opf     epub/OEBPS/content.opf
echo content.opf
cp src/stylesheet.css  epub/OEBPS/stylesheet.css
echo stylesheet.css

echo \<manifest\> > manifest.tmp
echo \<spine toc=\"ncx\"\> > content.opf
echo \<itemref idref=\"titlepage\"/\> >> content.opf
echo \<itemref idref=\"foreword\"/\> >> content.opf
echo \<itemref idref=\"toc\"/\> >> content.opf
echo \<guide\> > guide.tmp
echo \<reference href=\"toc.xhtml\" type=\"toc\" title=\"Table of Contents\"/\> >> guide.tmp
echo \<reference href=\"foreword.xhtml\" type=\"foreword\" title=\"Foreword\"/\> >> guide.tmp
echo \<reference href=\"titlepage.xhtml\" type=\"cover\" title=\"Cover\"/\> >> guide.tmp

echo \<navPoint class=\"chapter\" id=\"titlepage\" playOrder=\"1\"\> >> epub/OEBPS/toc.ncx
echo \<navLabel\> >> epub/OEBPS/toc.ncx
echo \<text\>Title\</text\> >> epub/OEBPS/toc.ncx
echo \</navLabel\> >> epub/OEBPS/toc.ncx
echo \<content src=\"titlepage.xhtml\"/\> >> epub/OEBPS/toc.ncx
echo \</navPoint\> >> epub/OEBPS/toc.ncx
echo \<navPoint class=\"chapter\" id=\"foreword\" playOrder=\"2\"\> >> epub/OEBPS/toc.ncx
echo \<navLabel\> >> epub/OEBPS/toc.ncx
echo \<text\>Foreword\</text\> >> epub/OEBPS/toc.ncx
echo \</navLabel\> >> epub/OEBPS/toc.ncx
echo \<content src=\"foreword.xhtml\"/\> >> epub/OEBPS/toc.ncx
echo \</navPoint\> >> epub/OEBPS/toc.ncx
echo \<navPoint class=\"chapter\" id=\"toc\" playOrder=\"3\"\> >> epub/OEBPS/toc.ncx
echo \<navLabel\> >> epub/OEBPS/toc.ncx
echo \<text\>Table of Contents\</text\> >> epub/OEBPS/toc.ncx
echo \</navLabel\> >> epub/OEBPS/toc.ncx
echo \<content src=\"toc.xhtml\"/\> >> epub/OEBPS/toc.ncx
echo \</navPoint\> >> epub/OEBPS/toc.ncx

CHAPTER=1;
REF=4;
cd chapters;
WORDCOUNT=`cat *.txt | sed -e 's/---//g' | wc | awk '{ print $2 }'`
for i in `ls *.txt`; do
    DEST=`echo $i | sed 's/txt/xhtml/'`;
    cat ../src/chapter.xhtml > tmp;
	echo \<div id=\"id$CHAPTER\"\>\</div\> >> tmp
	echo \<div class=\"index\"\>\<a href=\"$CHAPTER.xhtml\"\>Chapter $CHAPTER\</a\>\</div\> >> tmp
    cat $i | sed -E 's/\/([^\/]*)\//\<em\>\1\<\/em\> /g' | sed -E 's/---/\<p align="center"\>\*\*\*\<\/p\>/g' | sed -E 's/(^[^\<]+$)/\<p\>\1\<\/p\>\ /g' >> tmp


	echo \</body\>\</html\> >> tmp

	echo \<item href=\"$CHAPTER.xhtml\" id=\"id$REF\" media-type=\"application/xhtml+xml\"/\> >> ../manifest.tmp
	echo \<itemref idref=\"id$REF\"/\> >> ../content.opf
	echo \<navPoint class=\"chapter\" id=\"id$REF\" playOrder=\"$REF\"\> >> ../epub/OEBPS/toc.ncx
	echo \<navLabel\> >> ../epub/OEBPS/toc.ncx
	echo \<text\>Chapter $CHAPTER\</text\> >> ../epub/OEBPS/toc.ncx
	echo \</navLabel\> >> ../epub/OEBPS/toc.ncx
	echo \<content src=\"$CHAPTER.xhtml\"/\> >> ../epub/OEBPS/toc.ncx
	echo \</navPoint\> >> ../epub/OEBPS/toc.ncx
	
	echo \<div class=\"index\"\>\<a href=\"$CHAPTER.xhtml\"\>Chapter $CHAPTER\</a\>\</div\> >> ../epub/OEBPS/toc.xhtml

    echo Chapter $CHAPTER;
    mv tmp ../epub/OEBPS/$DEST;
    let CHAPTER=CHAPTER+1
    let REF=CHAPTER+3
done;
cd ..;

let LASTREF=REF
cd includes;
for i in `ls *.jpg`; do
    echo $i;
	echo \<item href=\"images/$i\" id=\"id$REF\" media-type=\"image/jpeg\"/\> >> ../manifest.tmp
	cp $i ../epub/OEBPS/images/$i
    let REF=REF+1
done;
for i in `ls *.png`; do
    echo $i;
	echo \<item href=\"images/$i\" id=\"id$REF\" media-type=\"image/png\"/\> >> ../manifest.tmp
	cp $i ../epub/OEBPS/images/$i
    let REF=REF+1
done;
cd ..

echo \<navPoint class=\"chapter\" id=\"afterword\" playOrder=\"$LASTREF\"\> >> epub/OEBPS/toc.ncx
echo \<navLabel\> >> epub/OEBPS/toc.ncx
echo \<text\>Afterword\</text\> >> epub/OEBPS/toc.ncx
echo \</navLabel\> >> epub/OEBPS/toc.ncx
echo \<content src=\"afterword.xhtml\"/\> >> epub/OEBPS/toc.ncx
echo \</navPoint\> >> epub/OEBPS/toc.ncx
echo \<p class=\"spacer\"\>\</p\> >> epub/OEBPS/toc.xhtml
echo \<div class=\"title\" id=\"afterword\"\>\<a href=\"afterword.xhtml\"\>Afterword\</a\>\</div\> >> epub/OEBPS/toc.xhtml

echo \<itemref idref=\"afterword\"/\> >> content.opf
echo \<reference href=\"afterword.xhtml\" type=\"afterword\" title=\"Afterword\"/\> >> guide.tmp
echo \<item href=\"stylesheet.css\" id=\"css\" media-type=\"text/css\"/\> >> manifest.tmp
echo \<item href=\"titlepage.xhtml\" id=\"titlepage\" media-type=\"application/xhtml+xml\"/\> >> manifest.tmp
echo \<item href=\"foreword.xhtml\" id=\"foreword\" media-type=\"application/xhtml+xml\"/\> >> manifest.tmp
echo \<item href=\"afterword.xhtml\" id=\"afterword\" media-type=\"application/xhtml+xml\"/\> >> manifest.tmp
echo \<item href=\"toc.xhtml\" id=\"toc\" media-type=\"application/xhtml+xml\"/\> >> manifest.tmp
echo \<item href=\"toc.ncx\" media-type=\"application/x-dtbncx+xml\" id=\"ncx\"/\> >> manifest.tmp
echo \</manifest\> >> manifest.tmp
echo \</spine\> >> content.opf
echo \</guide\> >> guide.tmp
echo \</navMap\> >> epub/OEBPS/toc.ncx
echo \</ncx\> >> epub/OEBPS/toc.ncx
echo \</body\> >> epub/OEBPS/toc.xhtml
echo \</html\> >> epub/OEBPS/toc.xhtml

cat manifest.tmp >> epub/OEBPS/content.opf
cat content.opf >> epub/OEBPS/content.opf
cat guide.tmp >> epub/OEBPS/content.opf
echo \</package\> >> epub/OEBPS/content.opf

rm content.opf
rm guide.tmp
rm manifest.tmp

for i in `find epub/OEBPS -maxdepth 1 -type f`; do
	sed -i '' 's/{{ID}}/'"$ID"'/' $i
	sed -i '' 's/{{TITLE}}/'"$TITLE"'/' $i
	sed -i '' 's/{{AUTHOR}}/'"$AUTHOR"'/' $i
	sed -i '' 's/{{DATE}}/'"$DATE"'/' $i
done

if [ -f "$TITLE.epub" ]; then
	rm -f $TITLE.epub;
fi;

cd epub
zip -X -0 ../$PACKAGE.epub mimetype
zip -X -u -r ../$PACKAGE.epub META-INF
zip -X -u -r ../$PACKAGE.epub OEBPS
cd ..
rm -rf epub

echo Generated $PACKAGE.epub. Wordcount: $WORDCOUNT