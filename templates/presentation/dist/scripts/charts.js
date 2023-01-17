(function () {

    const data = {
        datasets: [],
    };

    const config = {
        type: 'scatter',
        data: data,
        options: {
            scales: {
                x: {
                    min: 0,
                    max: 10,
                    type: 'linear',
                    position: 'bottom',
                    ticks: {
                        font: {
                            size: 20,
                            weight: "normal"
                        },
                        color: "black"
                    }
                },
                y: {
                    min: 0,
                    max: 10,
                    type: 'linear',
                    ticks: {
                        font: {
                            size: 20,
                            weight: "normal"
                        },
                        color: "black"
                    }
                }
            },
            plugins: {
                legend: {
                    display: true
                }
            },
            animation: true,
            responsive: true,
            maintainAspectRatio: true,
            aspectRatio: 1
            // resizeDelay: 2000
        }
    };

    function cloneObject(o) {
        return JSON.parse(JSON.stringify(o))
    }


    function makePoint(p) {
        const xy = p.split(',')
        return { x: xy[0], y: xy[1] }
    }

	function recreateChart(canvas) {
		// clear data to redraw animation
		var data = canvas.chart.data.datasets;
		canvas.chart.data.datasets = []; 
		canvas.chart.update();
		canvas.style.visibility = "hidden";
		setTimeout( function(canvas, data) { 
			canvas.chart.data.datasets = data; 
			canvas.style.visibility = "visible"; 
			canvas.chart.update(); 
		}, 500, canvas, data); // wait for slide transition to re-add data and animation
	}

    function makeScatterChart(ctx, rangeX, rangeY, ptData, labels, colors, dotSizes) {
        // rangeX='0:50' rangeY='0:20' data='[(10,18),(15,10)],[(11,19),(17,17)] labels=['','']'

        const limitsX = rangeX.split(':')
        const limitsY = rangeY.split(':')
        const reList = /\[(.*?)\]/;
        var m = reList.exec(ptData);
        var ptsList = []
        while (m) {
            var pts = []
            ptData = ptData.substring(m.index + m[0].length);
            var pointList = m[0];
            const rePoint = /\((.*?)\)/;
            m = pointList.match(rePoint)
            while (m) {
                pts.push(makePoint(m[1]));
                pointList = pointList.substring(m.index + m[0].length);
                m = pointList.match(rePoint);
            }
            ptsList.push(pts)
            m = reList.exec(ptData);
        }

        // labels
        var labelList = [];
        const reLabel = /\"(.*?)\"/;
        m = labels.match(reLabel)
        while (m) {
            labelList.push(m[1]);
            labels = labels.substring(m.index + m[0].length);
            m = labels.match(reLabel);
        }

        // colors
        var colorList = [];
        const reColor = /rgba\(.*?\)/;
        m = colors.match(reColor)
        while (m) {
            colorList.push(m[0]);
            colors = colors.substring(m.index + m[0].length);
            m = colors.match(reColor);
        }

        // sizes
        var dotSizeList = [];
        dotSizeList = dotSizes.split(',').map(s=>parseFloat(s))

        let newConfig = cloneObject(config)

        newConfig.options.scales.x.min = parseInt(limitsX[0]);
        newConfig.options.scales.x.max = parseInt(limitsX[1]);
        newConfig.options.scales.y.min = parseInt(limitsY[0]);
        newConfig.options.scales.y.max = parseInt(limitsY[1]);

        for (let k = 0; k < ptsList.length; k++) {
            let ds = {}
            ds.label = labelList[k]
            ds.data = ptsList[k]
            ds.backgroundColor = colorList[k]
            ds.pointRadius = dotSizeList[k]
            newConfig.data.datasets.push(ds);
        }

        const chart = new Chart(
            ctx,
            newConfig
        );
        ctx.chart = chart;

        return chart
    }


    function setData(chart, data1, data2) {
        chart.data.datasets[0].data = data1
        chart.data.datasets[1].data = data2
        chart.update();
    }


    $(document).ready(function () {
        $("canvas.scatterChart").each(function (index) {
            const rangeX = this.getAttribute("rangex");
            const rangeY = this.getAttribute("rangey");
            const ptData = this.getAttribute("data");
            const labels = this.getAttribute("labels");
            const colors = this.getAttribute("colors");
            const dotSizes = this.getAttribute("dotSizes");
            makeScatterChart(this, rangeX, rangeY, ptData, labels, colors, dotSizes)
        });

        Reveal.addEventListener('slidechanged', function(){
            var canvases = Reveal.getCurrentSlide().querySelectorAll("canvas.scatterChart");
            for (var i = 0; i < canvases.length; i++ ){
                if ( canvases[i].chart  && canvases[i].chart.config.options.animation !== false ) {
                    recreateChart( canvases[i] );
                }
            }
        });
    

    });

})();
