$ = require "jquery"
o = require "./lib/jquery.overlaps.js"
console.log "OVERLAPS", o
Emitter = require "emitter"

module.exports = (surface, selectable, selectedClass) ->
	emitter = new Emitter
	drawingBox = false
	selected = false
	startX = 0
	startY = 0
	
	$(surface).on 
		mousedown: (e) ->
			if selected then selected.removeClass selectedClass
			
			startX = e.pageX
			startY = e.pageY
			drawingBox = $("<div />")
				.addClass("groupSelectionBox")
				.css(left: e.pageX, top: e.pageY)
				.appendTo "body"
				
		mousemove: (e) ->
			if drawingBox			 
				if e.pageX < startX
					left = e.pageX
					width = startX - left
				else
					left = startX
					width = e.pageX - left
					
				if e.pageY < startY
					top = e.pageY
					height = startY - top
				else
					top = startY
					height = e.pageY - top
					
				drawingBox.css {left, top, width, height}
	
	
				selected = $("#{surface} #{selectable}")
					.removeClass(selectedClass)
					.filter(-> drawingBox.overlaps this)
					.addClass(selectedClass)
				
		mouseup: (e) ->
			if drawingBox
				drawingBox.remove()
				drawingBox = false
				selected.removeClass selectedClass
				
			if selected.length
				emitter.emit "itemsSelected", selected

	emitter

