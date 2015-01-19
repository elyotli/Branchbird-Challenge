function updateGraph(canvas, data){
	values = [];
	for(var i = 0; i < data.length; i++){
		values.push(data[i].value);
	}
	var yMax = Math.max.apply(Math, values)
	var yScale = d3.scale.linear()
				.domain([0, yMax])
				.range([graphHeight, 0]);

	var color = d3.scale.category10();
	// Define the line
	var line1 = d3.svg.line()
	    .x(function(d) { return xScale(d.year); })
	    .y(function(d) { return yScale(d.value); });

    canvas.append("path")
        .attr("class", "line")
        .style("stroke", "blue")
        .attr("d", line1(data)); 

    // Define the axes
	var xAxis = d3.svg.axis().scale(xScale)
	    .orient("bottom").ticks(years.length)
	    .tickFormat(function(d, i){
		    return d;
		});
	var yAxis = d3.svg.axis().scale(yScale)
	    .orient("left").ticks(5);
    
	// Add the X Axis
    canvas.append("g")
        .attr("class", "x-axis")
        .attr("transform", "translate(0," + graphHeight + ")")
        .call(xAxis);
    // Add the Y Axis
    var $canvas = $(canvas[0]);
    if($canvas.find(".y-axis").length == 0){
	    canvas.append("g")
	        .attr("class", "y-axis")
	        .call(yAxis);
	}
}

$(document).ready(function(){
	//define canvas size, a bunch of globals, should change to closure
	canvasWidth = $(".graph1").width(), //this is the dimension of the entire d3 box
	canvasHeight = 300,
	paddingTop = 10,
	paddingBottom = 50,
	paddingLeft = 70,
	paddingRight = 20,
	graphHeight = canvasHeight - paddingTop - paddingBottom, //this is the dimension of bargraph;
	graphWidth = canvasWidth - paddingLeft - paddingRight;

	//fetch data
	uptown_total_crime = gon.uptown_total_crime;
	chicago_total_crime = gon.chicago_total_crime;
	westloop_total_crime = gon.westloop_total_crime;
	chicago_permits = gon.chicago_permit;
	uptown_permits = gon.uptown_permit;
	westloop_permits = gon.westloop_permit;
	chicago_crime_distribution = gon.chicago_crime_distribution
	uptown_crime_distribution = gon.uptown_crime_distribution
	westloop_crime_distribution = gon.westloop_crime_distribution
	years = gon.years

	//set up x scale
	xScale = d3.scale.linear()
	        	.domain([years[0], years[years.length - 1]])
				.range([0, graphWidth]);

	canvas1 = d3.select(".graph1")
			.append("svg")
			.attr("height", canvasHeight)
			.attr("width", canvasWidth)
			.append("g")
			.attr("transform", "translate(" + paddingLeft + ", " + paddingTop + ")")
			.attr("height", graphHeight)
			.attr("width", graphWidth);

	// processing data
	var westloop_crime_data = [];
	for(var i = 0; i < years.length; i++){
		westloop_crime_data.push({year: years[i], value: westloop_total_crime[i],symbol: "westloop"})
	}

	var westloop_permit_data = [];
	for(var i = 0; i < years.length; i++){
		westloop_permit_data.push({year: years[i], value: westloop_permits[i],symbol: "westloop"})
	}

	updateGraph(canvas1, westloop_crime_data)
	updateGraph(canvas1, westloop_permit_data)

	canvas2 = d3.select(".graph2")
			.append("svg")
			.attr("height", canvasHeight)
			.attr("width", canvasWidth)
			.append("g")
			.attr("transform", "translate(" + paddingLeft + ", " + paddingTop + ")")
			.attr("height", graphHeight)
			.attr("width", graphWidth);

	// processing data
	var chicago_crime_data = [];
	for(var i = 0; i < years.length; i++){
		chicago_crime_data.push({year: years[i], value: chicago_total_crime[i],symbol: "chicago"})
	}

	var chicago_permit_data = [];
	for(var i = 0; i < years.length; i++){
		chicago_permit_data.push({year: years[i], value: chicago_permits[i],symbol: "chicago"})
	}

	updateGraph(canvas2, chicago_crime_data)
	updateGraph(canvas2, chicago_permit_data)

	canvas3 = d3.select(".graph3")
			.append("svg")
			.attr("height", canvasHeight)
			.attr("width", canvasWidth)
			.append("g")
			.attr("transform", "translate(" + paddingLeft + ", " + paddingTop + ")")
			.attr("height", graphHeight)
			.attr("width", graphWidth);

	updateDistributionGraph(canvas3, chicago_crime_distribution)

	$(".button").on("click", function(){
		var scope = $(this).attr('id') + "_crime_distribution";
		updateDistributionGraph(canvas3, eval(scope));
	});
});	

function updateDistributionGraph(canvas, data){
	canvas.attr("height", 600);
	$(canvas[0]).empty();
	//data conversion for %s
	var crime_distribution_data = []
	for(var i = 0; i < years.length; i++){
		$.map(data[i], function(value, index) {
	    	crime_distribution_data.push({year: years[i], type: index, value: value});
		});
	}

	//find max for scale
	var values = [];
	for(var i = 0; i < crime_distribution_data.length; i++){
		values.push(crime_distribution_data[i].value);
	}
	var yMax = Math.max.apply(Math, values)
	var yScale = d3.scale.linear()
				.domain([0, yMax])
				.range([graphHeight, 0]);

	var dataNest = d3.nest()
        .key(function(d) {return d.type;})
        .entries(crime_distribution_data);
    var color = d3.scale.category10();
	var line = d3.svg.line()
	    .x(function(d) { return xScale(d.year); })
	    .y(function(d) { return yScale(d.value); });

    // Loop through each symbol / key
    dataNest.forEach(function(d) {
	    canvas3.append("path")
	        .attr("class", "line")
	        .style("stroke", function() {
	            return d.color = color(d.key); })
	        .attr("d", line(d.values)); 
    });

    // Define the axes
	var xAxis = d3.svg.axis().scale(xScale)
	    .orient("bottom").ticks(years.length)
	    .tickFormat(function(d, i){
		    return d;
		});
	var yAxis = d3.svg.axis().scale(yScale)
	    .orient("left").ticks(5);

    canvas3.append("g")
        .attr("class", "x-axis")
        .attr("transform", "translate(0," + graphHeight + ")")
        .call(xAxis);
    // Add the Y Axis
    var $canvas = $(canvas3[0]);
    if($canvas.find(".y-axis").length == 0){
	    canvas3.append("g")
	        .attr("class", "y-axis")
	        .call(yAxis);
	}
}


	// processing data
	// var chicago_crime_data = [];
	// for(var i = 0; i < years.length; i++){
	// 	chicago_crime_data.push({year: years[i], value: chicago_total_crime[i],symbol: "chicago"})
	// }

	// var chicago_permit_data = [];
	// for(var i = 0; i < years.length; i++){
	// 	chicago_permit_data.push({year: years[i], value: chicago_permits[i],symbol: "chicago"})
	// }

	// updateGraph(canvas3, chicago_crime_data)
	// updateGraph(canvas3, chicago_permit_data)
	// var yScale1 = d3.scale.linear()
	// 			.domain([0, Math.max.apply(Math, westloop_total_crime)])
	// 			.range([graphHeight, 0]);
	// var yScale2 = d3.scale.linear()
	// 			.domain([0, Math.max.apply(Math, westloop_permits)])
	// 			.range([graphHeight, 0]);

	// var color = d3.scale.category10();
	// // Define the line
	// var line1 = d3.svg.line()
	//     .x(function(d) { return xScale(d.year); })
	//     .y(function(d) { return yScale1(d.value); });
	// var line2 = d3.svg.line()
	//     .x(function(d) { return xScale(d.year); })
	//     .y(function(d) { return yScale2(d.value2); });

 //    canvas.append("path")
 //        .attr("class", "line")
 //        .style("stroke", "blue")
 //        .attr("d", line1(data)); 
 //    canvas.append("path")
 //        .attr("class", "line")
 //        .style("stroke", "red")
 //        .attr("d", line2(data)); 

 //    // Define the axes
	// var xAxis = d3.svg.axis().scale(xScale)
	//     .orient("bottom").ticks(years.length)
	//     .tickFormat(function(d, i){
	// 	    return d;
	// 	});
	// var yAxis = d3.svg.axis().scale(yScale1)
	//     .orient("left").ticks(5);
 //    // Add the X Axis
 //    canvas.append("g")
 //        .attr("class", "x axis")
 //        .attr("transform", "translate(0," + graphHeight + ")")
 //        .call(xAxis);
 //    // Add the Y Axis
 //    canvas.append("g")
 //        .attr("class", "y axis")
 //        .call(yAxis);


// multiple series:
// 	var dataNest = d3.nest()
//         .key(function(d) {return d.symbol;})
//         .entries(data);

//     // Loop through each symbol / key
//     dataNest.forEach(function(d) {
// 	    canvas.append("path")
// 	        .attr("class", "line")
// 	        .style("stroke", function() {
// 	            return d.color = color(d.key); })
// 	        .attr("d", line1(d.values)); 
//     });
