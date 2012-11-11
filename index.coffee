Emitter = require "emitter"
elementsOverlap = require "elements=-overlap"
dom = require "dom"

module.exports = (surface, selectable, selectedClass) ->
	emitter = new Emitter
	drawingBox = false
	selected = false
	startX = 0
	startY = 0
	
	surfaceElement = document.querySelector(surface)
	
	surfaceElement.addEventListener "mousedown", (e) ->
			if selected then selected.removeClass selectedClass
			
			startX = e.pageX
			startY = e.pageY
			drawingBox = dom("<div />")

			drawingBox
				.addClass("groupSelectionBox")
				.css("left", e.pageX + "px")
				.css("top", e.pageY + "px")

			document.body.appendChild drawingBox.get(0)

	surfaceElement.addEventListener "mousemove", (e) ->
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
				
			drawingBox
				.css("left", left + "px")
				.css("top", top + "px")
				.css("width", width + "px")
				.css("height", height + "px")

			selected = dom("#{surface} #{selectable}", document)
				.removeClass(selectedClass)
				.filter((el) -> elementsOverlap(drawingBox.get(0), el.get(0)))
				.addClass(selectedClass)
				
	surfaceElement.addEventListener "mouseup", (e) ->
		if drawingBox
			document.body.removeChild drawingBox.get(0)
			drawingBox = false

		if selected and selected.length()
			selected.removeClass selectedClass
			emitter.emit "itemsSelected", selected
			selected = false

	emitter

