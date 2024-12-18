# love_windows
multiple windows in love2d with the ability for *very light* interaction between them

## Basic Usage
downlaod and place the *openWindows.lua* file into your project and add ```OpenWindow = require("openWindow");``` into your main file

### Creating a new window
windows are new instances of love2d so each one needs lua files to run, load these as strings and send them to the ```OpenWindow.new();``` function to create a new window with love2d running them as code:
```lua
OpenWindow = require("openWindow");

local mainFile = [[
function love.draw()
  love.graphics.setColor(1, 0, 0);
  love.graphics.rectangle("fill", 5, 5, 40, 35);

  love.graphics.setColor(0, 1, 0);
  love.graphics.rectangle("fill", 30, 40, 50, 40);
end
]];

local confFile = [[
function love.conf(t)
    t.window.title = "test";

    t.console = false;

    t.window.width = 100;
    t.window.height = 100;
end]];

-- all of these create the window the same way:

OpenWindow.new {
  main = mainFile,
  conf = confFile
};

OpenWindow.new({
  main = mainFile,
  conf = confFile
});

OpenWindow.new({
  ["main"] = mainFile,
  ["conf"] = confFile
});

OpenWindow.new({
  ["main.lua"] = mainFile,
  ["conf.lua"] = confFile
});
```

```OpenWindow.new()``` takes a table as an arg, each item in the table will use the item name as its filename other then some exceptions, if a file does not have a type then it will be created as a .lua file.

#### Exceptions:
an item with name 'callback' can be a function that is called when the window returns any info (takes 2 args)
```lua
{
  callback = function(name, state)
    print("set '" .. name .. "' to new state: '" .. state .. "'");
  end
}
```
an item with the name 'name' will set the identity of the window, if one is not provided then it will default to: "UNNAMED" as an arbitrary identity, each window needs to have a unique identity so having 2 "UNNAMED" windows will cause one to not be created
```lua
{
  name = "newWindow"
}
```
an item with the name 'unfilteredArgs' will be used for the love instance creation on unFused instances (non .love files, generally a testing enviornment is unFused, fused is used when publishing the final product), this should always be included and can be gotten from the 2nd argument passed to ```love.load(arg1, this_one)```
```lua
local unfilteredArgs = nil;

function love.load(arg1, arg2)
  unfilteredArgs = arg2;
end

{
  unfilteredArgs = unfilteredArgs
} -- make window with this
```

#### Reffer to the test.lua file for a working instance to start
