marquee
=======

marquee selection component. 

##Arguments
```
marquee(surface [jquery selector], selectable [selector for selectable items], selectedClass [class to apply to items as they are selected])
```

##Using
```
var marquee = require("marquee");
marquee("body", "> .widget", "lit")
    .on("itemsSelected", function(items) {
        console.log(items);
});
```

emits "itemsSelected" event with jquery object containing selected items. 
