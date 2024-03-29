---
layout: post
title: dfir / mlw / pdf
category: dfir
parent: cheatsheets
modified_date: 2023-09-21
permalink: /dfir/mlw/pdf
---

<iframe width="560" height="315" src="https://www.youtube-nocookie.com/embed/QibsOY1dFU0?si=3hnLwXhyR1FNFb8E" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

## pdf
```bash
# Download PDF samples
wget http://didierstevens.com/files/data/pdf-workshop-exercises.zip
7z x -p infected pdf-workshop-exercises.zip

# unfilter stream object
pdfid.py ex003.pdf
# /JS 
# /Javascript 0
# /OpenAction 
pdf-parser.py -o 5 -f ex003.pdf

# javascript - no exec
pdfid.py ex004.pdf
# /JS 1
# /Javascript 1
# /OpenAction 0
pdf-parser.py -s javascript ex004.pdf

# javascript execution
pdfid.py ex005.pdf
# /JS 1 
# /Javascript 1
# /OpenAction 1
pdf-parser.py -s openaction ex005.pdf
pdf-parser.py -o 7 ex005.pdf

# javascript name obfuscation
pdfid.py ex007.pdf
# /JS 1(1)
# /Javascript 0
# /OpenAction 
pdf-parser.py -s javascript ex007.pdf
pdf-parser.py -o 8 -f -d ex007.js ex007.pdf

# javascript stored in annotation
pdfid.py ex009.pdf
# /JS 
# /Javascript 0
# /OpenAction 
pdf-parser.py -s javascript ex009.pdf # /JS 9 0 R
pdf-parser.py -o 9 -f ex009.pdf # 'this.syncAnnotScan(); eval(this.GetAnnot()[0].name();'
pdf-parser.py -s Annot ex009.pdf # /NM 10 0 R
pdf-parser.py -o 10 -w ex009.pdf

# javascript hidden in ObjStrm
pdfid.py ex010.pdf 
# /JS 0 
# /Javascript 0
# /OpenAction 
# /ObjStm 1
pdf-parser.py -s ObjStm ex010.pdf 
pdf-parser.py -o 10 -f -w ex010.pdf  # /N 6 => the ObjStm contains 6 objects
pdf-parser.py -o 10 -f -w ex010.pdf | pdfid.py -f # /Javascript 1 /OpenAction 1

# javascript exploiting Acrobat Reader 8.1.2
pdfid.py ex011.pdf.vir 
# /JS 1 
# /Javascript 1 
# /OpenAction 1
pdf-parser.py -s javascript ex011.pdf.vir  # /JS (var num = 1112223333)

# embedded executable
!(/assets/images/dfir-mlw-static-pdf-embed-exe.png)
pdfid.py ex013.pdf 
# /JS 0 
# /Javascript 0 
# /OpenAction 0
pdf-parser.py -s embedded ex013.pdf  # /JS (var num = 1112223333)
pdf-parser.py -o 8 -f -d ex013.exe ex013.pdf # /JavaScript 1(1)

# embedded file after %%EOF
pdfid.py -e exo014.pdf
# in clean PDF we have      => After last %%EOF 0
# in this rogue PDF we have => After last %%EOF 51200
pdf-parser -x exo014.exe exo014.pdf # After last %%EOF 51200

# javascript hidden into an /AcroForm
pdfid.py exo015.pdf
# /AcroForm 1
pdf-parser.py -s acroform ex015.pdf # /AcroForm 7 0 R
pdf-parser.py -o 7 ex015.pdf # /XFA [8 0 R]
pdf-parser.py -o 8 -f -d exo015.xml ex015.pdf

# javascript hidden into metadata
pdfid.py exo016.pdf
# /JS 1
pdf-parser.py -s javascript ex016.pdf # /JS (this.metadata) 
pdf-parser.py -s metadata ex016.pdf # /Catalog is referencing metadata
pdf-parser.py -o 7 -f -d exo016.xml ex016.pdf

# javascript infostealer using fullscreen with form to fake website / capture data
# old technic, fullscreen now pops-up a warning  
pdfid.py ex017.pdf 
# /JS 1 
# /Javascript 1
# /OpenAction 1
pdf-parser.py -s javascript ex017.pdf # /JS (app.fs.isFullScreen= true) 

# old technic, fullscreen now pops-up a warning  
!(/assets/images/dfir-mlw-static-pdf-launch-prog1.png)
!(/assets/images/dfir-mlw-static-pdf-launch-prog2.png)
!(/assets/images/dfir-mlw-static-pdf-launch-prog3.png)
pdfid.py secret.pdf.vir 
# /JS 0
# /Javascript 0
# /OpenAction 1
# /Launch 1
pdf-parser.py -s openaction secret.pdf.vir # /JS (app.fs.isFullScreen= true) 

# encrypted PDF
pdfid.py ex019.pdf 
# /Encrypted 1
# /JS 1
# /Javascript 1
# /OpenAction 1
pdf-parser.py -s javascript ex019.pdf # /JS (app.fs.isFullScreen= true) 
# there are 2 passwords type for encryption
# the owner password, stored within the pdf, if only one used, PDF CAN be decrypted
# the user password, used for secrecy, if used, PDF CANNOT be decrypted
qpdf --decrypt ex019.pdf ex019-clear.pdf
# we see the hashes of the /O (Owner) and /U (Users) passwords
# encryption uses the hash of the owner pwd, this is why it can be reversed

# encrypted PDF
pdfid.py ex020.pdf 
# /Encrypted 1
# /JS 1
# /Javascript 1
# /OpenAction 1
pdf-parser.py -s javascript ex020.pdf # /JS (app.fs.isFullScreen= true) 
qpdf --decrypt ex020.pdf ex020-clear.pdf
# invalid password
qpdf --decrypt --password=secret ex020.pdf ex020-clear.pdf
pdf-parser.py -s javascript ex020-clear.pdf