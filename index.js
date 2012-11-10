// Generated by CoffeeScript 1.3.3
(function() {
  var Emitter, dom, elementsOverlap;

  Emitter = require("emitter");

  elementsOverlap = require("elementsOverlap");

  dom = require("dom");

  module.exports = function(surface, selectable, selectedClass) {
    var drawingBox, emitter, selected, startX, startY, surfaceElement;
    emitter = new Emitter;
    drawingBox = false;
    selected = false;
    startX = 0;
    startY = 0;
    surfaceElement = document.querySelector(surface);
    surfaceElement.addEventListener("mousedown", function(e) {
      if (selected) {
        selected.removeClass(selectedClass);
      }
      startX = e.pageX;
      startY = e.pageY;
      drawingBox = dom("<div />");
      drawingBox.addClass("groupSelectionBox").css("left", e.pageX).css("top", e.pageY);
      return document.body.appendChild(drawingBox.get(0));
    });
    surfaceElement.addEventListener("mousemove", function(e) {
      var height, left, top, width;
      if (drawingBox) {
        if (e.pageX < startX) {
          left = e.pageX;
          width = startX - left;
        } else {
          left = startX;
          width = e.pageX - left;
        }
        if (e.pageY < startY) {
          top = e.pageY;
          height = startY - top;
        } else {
          top = startY;
          height = e.pageY - top;
        }
        drawingBox.css("left", left).css("top", top).css("width", width).css("height", height);
        return selected = dom("" + surface + " " + selectable).removeClass(selectedClass).filter(function(el) {
          return elementsOverlap(drawingBox.get(0), el.get(0));
        }).addClass(selectedClass);
      }
    });
    surfaceElement.addEventListener("mouseup", function(e) {
      if (drawingBox) {
        document.body.removeChild(drawingBox.get(0));
        drawingBox = false;
      }
      if (selected && selected.length()) {
        selected.removeClass(selectedClass);
        emitter.emit("itemsSelected", selected);
        return selected = false;
      }
    });
    return emitter;
  };

}).call(this);
