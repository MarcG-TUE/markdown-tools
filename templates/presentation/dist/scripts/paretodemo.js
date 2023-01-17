(function () {
    const MaxNrPoints = 5;
    const pdData = {
        datasets: [],
    };

    const pdConfig = {
        type: 'scatter',
        data: pdData,
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

    var allPoints = [];
    var paretoPoints = [];
    var dominatedPoints = [];

    function addPoint(chart, x, y) {
        allPoints.push({ x: x, y: y });
        [paretoPoints, dominatedPoints] = splitParetoPoints(allPoints)
        setData(chart, paretoPoints, dominatedPoints);
    }

    function makeScatterChart(ctx) {

        let newConfig = cloneObject(pdConfig)

        newConfig.options.scales.x.min = 0;
        newConfig.options.scales.x.max = 10;
        newConfig.options.scales.y.min = 0;
        newConfig.options.scales.y.max = 10

        let ds = {}
        ds.label = 'Pareto Points'
        ds.data = []
        ds.backgroundColor = 'rgba(255,0,0,.8)'
        ds.pointRadius = 10
        newConfig.data.datasets.push(ds);

        ds = {}
        ds.label = 'Dominated Points'
        ds.data = []
        ds.backgroundColor = 'rgba(0,0,255,.8)'
        ds.pointRadius = 8
        newConfig.data.datasets.push(ds);

        const chart = new Chart(
            ctx,
            newConfig
        );

        chart.options.onClick = (e) => {
            const canvasPosition = Chart.helpers.getRelativePosition(e, chart);

            chart.canvas.style.visibility = "hidden";

            // Substitute the appropriate scale IDs
            const dataX = chart.scales.x.getValueForPixel(canvasPosition.x);
            const dataY = chart.scales.y.getValueForPixel(canvasPosition.y);
            addPoint(chart, dataX, dataY);
            recreateChart2( chart.canvas);
        }

        ctx.chart = chart;

        recreateChart(chart.canvas)

        return chart
    }

    function dominates(a, b) {
        return a.x <= b.x && a.y <= b.y;
    }

    function isDominated(pts, p) {
        return pts.some((v, i) => dominates(v, p))
    }

    function splitParetoPoints(pts) {
        var pareto = [];
        var dominated = [];
        pts.forEach(p => {
            // if p is dominated, add to dominated list
            if (isDominated(pareto, p)) {
                dominated.push(p)
            } else {
                // else add to pareto list and move all pareto points dominated by this one to dominated
                for (let i = 0; i < pareto.length; i++) {
                    const q = pareto[i];
                    if (dominates(p, q)) {
                        dominated.push(q)
                        pareto.splice(i, 1)
                        i--;
                    }
                }
                pareto.push(p)
            }
        });
        pareto.sort((a, b) => a.x < b.x || (a.x == b.x && a.y <= b.y))
        dominated.sort((a, b) => a.x < b.x || (a.x == b.x && a.y <= b.y))
        return [pareto, dominated]
    }

    function setData(chart, data1, data2) {
        chart.data.datasets[0].data = data1
        chart.data.datasets[1].data = data2
        // chart.update();
    }


    function runDemo(chart) {
        var myPoints = [];
        const intervalId = setInterval(() => {
            myPoints.push({
                x: Math.random() * 10,
                y: Math.random() * 10
            });
            var pareto;
            var dominated;
            [pareto, dominated] = splitParetoPoints(myPoints)
            setData(chart, pareto, dominated);
            if (myPoints.length > MaxNrPoints) {
                clearInterval(intervalId);
            }
        }, 1000);

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

    function recreateChart2(canvas) {
		// clear data to redraw animation
		var data = canvas.chart.data.datasets;
		canvas.chart.data.datasets = []; 
		canvas.chart.update();
		canvas.style.visibility = "hidden";
		canvas.chart.data.datasets = data; 
		canvas.style.visibility = "visible"; 
		canvas.chart.update(); 
	}


    $(document).ready(function () {
        $("canvas.paretoDemo").each(function (index) {
            makeScatterChart(this)
        });

        Reveal.addEventListener('slidechanged', function(){
            var canvases = Reveal.getCurrentSlide().querySelectorAll("canvas.paretoDemo");
            for (var i = 0; i < canvases.length; i++ ){
                if ( canvases[i].chart  && canvases[i].chart.config.options.animation !== false ) {
                    recreateChart( canvases[i] );
                }
            }
        });

    });

})();