
function svgArrow(x1, y1, x2, y2, width, color) {
    var svg = document.createElementNS("http://www.w3.org/2000/svg", "svg"); 
    var svgNS = svg.namespaceURI;
  
    const vbWidth = 1700;
    const vbHeight = 900;
  
    x1 = x1/100*vbWidth;
    x2 = x2/100*vbWidth;
    y1 = y1/100*vbHeight;
    y2 = y2/100*vbHeight;
  
  
    const length = Math.sqrt((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1))
  
    svg.setAttribute('width', '100%');
    svg.setAttribute('height', '100%');
    svg.setAttribute('viewBox', `0 0 ${vbWidth} ${vbHeight}`)
    svg.setAttribute('style', `position: absolute; left: 0%; top: 0%; margin: 0;`);
  
    // create transform group to turn unit arrow into desired arrow
    var grp = document.createElementNS(svgNS, 'g');
    grp.setAttribute('transform', `matrix(${x2-x1} ${y2-y1} ${y1-y2} ${x2-x1} ${x1} ${y1})`);
    svg.appendChild(grp);
  
    const pw = width/length;
    const nw = -width/length;
    const dpw = 2*pw;
    const dnw = 2*nw;
    const al = 1.0-4*width/length;
  
    // make unit arrow pointing from (0,0) to (1,0)
    var polyline = document.createElementNS(svgNS, 'polygon');
    polyline.setAttribute('points', `0,${nw} ${al},${nw} ${al},${dnw} 1,0 ${al},${dpw} ${al},${pw} 0,${pw} 0,${nw}`);
    polyline.setAttribute('style', `fill:${color};stroke:black;stroke-width:0`);
    grp.appendChild(polyline);
    return svg;
  }
  
  $(document).ready(function () {
    $("div.arrow").each(function (index) {
      const x1 = this.getAttribute("data-x1");
      const y1 = this.getAttribute("data-y1");
      const x2 = this.getAttribute("data-x2");
      const y2 = this.getAttribute("data-y2");
      var color = "black"
      if (this.hasAttribute('color')){
        color = this.getAttribute('color');
      }
      var width = 0.1
      if (this.hasAttribute('width')){
        width = this.getAttribute('width');
      }
        var svg = svgArrow(x1, y1, x2, y2, width, color)
      if (this.classList.contains('fragment')){
        svg.classList.add('fragment');
      }
      this.parentNode.replaceChild(svg, this);
    });
      // );
  });
  