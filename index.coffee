Emitter = require "emitter"
elementsOverlap = require "elementsOverlap"
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
				.css("left", e.pageX)
				.css("top", e.pageY)

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
					.css("left", left)
					.css("top", top)
					.css("width", width)
					.css("height", height)
	
				selected = dom("#{surface} #{selectable}")
					.removeClass(selectedClass)
					.filter((el) -> 
						elementsOverlap(drawingBox.get(0), el.get(0)))
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

