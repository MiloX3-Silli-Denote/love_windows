-- can be placed in empty project as main.lua and create a working instance

--* press the "o" key on the smaller window and it will close and begin printing into the console
--* press the "p" key on the larger window and it will close the smaller window and not print anything to the console

OpenWindow = require("openWindow");

local unfilteredArgs = nil;

local mainFile = [[
local time = 0;

function love.update(dt)
  time = time + dt;

  if love.keyboard.isDown("o") then
    -- love_windows exclussive love function, will send info to parent window and then closes this window
    love.finalize {
      instruc_one = "finalized";
      ["instruc_two"] = tostring(156);
    };
  end
end

function love.draw()
  love.graphics.setColor(1,0,0);
  love.graphics.rectangle("fill", 5,5, 40,40);

  love.graphics.setColor(0,1,0);
  love.graphics.rectangle("fill", 35,40, 50,35);

  love.graphics.setColor(1,1,1);
  love.graphics.print(tostring(time), 15,15);
end

-- love_window exclussive callback, when instruction is recieved from parent window this will be called (will VERY often miss instructions and read the same instruction many times)
-- no interaction has been implemented yet so this does nothing at the moment
function love.instruction(name, state)
  -- print("test window got instruction: name '" .. name .. "' state '" .. state .. "'");
end

-- not allowed to redefine love.errorhandler or love.run
]];

local confFile = [[
function love.conf(t)
    t.window.title = "test";

    t.console = true;
    -- if multiple windows are open with console active then they share one console window and print to it in a janky way

    t.window.width = 100;
    t.window.height = 100;
end]];

function love.load(arg1, arg2)
  unfilteredArgs = arg2;
  OpenWindow.load();

  OpenWindow.new {
    conf = confFile;
    main = mainFile;

    name = "testing_window";
    unfilteredArgs = unfilteredArgs;
    callback = function(name, state)
      print("recieved instruction: name '" .. name .. "' state '" .. state .. "'");
    end;
  };
end

function love.update(dt)
  OpenWindow.update();

  if love.keyboard.isDown("p") then
    OpenWindow.closeWindow("testing_window");
  end
end

function love.quit()
  OpenWindow.quit();
end

-- cannot redefine love.errorhandler or love_windows wont close and clean properly on crash
