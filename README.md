# epub generator

This is a set of scripts and assets to generate an epub from a set of text files.

## How to use

* Create a folder called chapters
* Add chapter files inside this directory. We suggest 1.txt, 2.txt etc.
* Create a folder called includes
* Add includes/foreword.xhtml. Write an HTML snippet for a foreword
* Add includes/afterword.xhtml. Write an HTML snippet for an afterword
* Add includes/cover.jpg. This should be 770 × 1186
* Modify publish.sh and set the environment variables for the package, title, author, id, and date
* Run publish.sh