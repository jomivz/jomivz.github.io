## Printable GOAD.SVG 

Here are the URL shortcuts you can type in your browser prefixed by ```https://www.jmvwork.xyz```:

* [/pen/goad2.svg](/pen/goad2.svg) / the original mindmap made by [mayfly277](mayfly277.github.io).
* [/pen/goad2.pdf](/pen/goad2.pdf) / a printabe version of the orginal v2 / 21 pages (A3 format).

```sh
# -w -h : inspect the svg with a web browser to export with a readable size 
# -b : keep the black background
inkscape -w 9900 -h 6224 -b "#000000" goad2.svg -o ad.goad2.png

# invert the colors to save black ink
convert goad2.png -channel RGB -negate goad2negat.png

# split the final PNG to 21 pages (A3 format)  
posterazor goad2negat.png
```
![](/assets/images/goad2-svg-2-pdf-1.png)
![](/assets/images/goad2-svg-2-pdf-2.png)
![](/assets/images/goad2-svg-2-pdf-3.png)
![](/assets/images/goad2-svg-2-pdf-4.png)
![](/assets/images/goad2-svg-2-pdf-5.png)
