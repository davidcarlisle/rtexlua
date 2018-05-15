--
-- rtexlua Lua script to execute Lua
-- =================================
--
-- version 0.2 2018-05-15
--
-- Should be secure enough to use in the restricted tex shell escape list.
--
-- Use as:
--
--  texlua rtexlua.lua  'local s=string.gsub("abc abc","b","XYZ") print(s) print(math.sqrt(1+1))' 
--
-- which produces
--
-- aXYZ caXYZc
-- 1.4142135623731
--
-- or from within TeX
--
-- \input|"texlua rtexlua.lua 'local s=string.gsub(@@quot@@abc abc@@quot@@,@@quot@@b@@quot@@,@@quot@@XYZ@@quot@@) print(s) print(math.sqrt(1+1))'"
--
-- Note that you need " at the outer level for the TeX file syntax and
--                    ' around the string to prevent it being interpreted by the shell
-- so " and ' within the string need the @@ form.


-- The call using texlua explicitly requires --shell-escape,
-- if the script is made directly executable a form such as
--
-- \input|"rtexlua 'local s=string.gsub(@@quot@@abc abc@@quot@@,@@quot@@b@@quot@@,@@quot@@XYZ@@quot@@) print(s) print(math.sqrt(1+1))'"
--
-- could (perhaps) be enabled to run in the default restricted shell escape mode.

-- David Carlisle
-- MIT Licence




-- Allow this wrapper to run loadstring locally

local savedloadstring=loadstring

local function localdostring (s)
 savedloadstring(s)()
end


-- Disable any functions that access anything

function dofile(s) print('disabled dofile') end
function load(s) print('disabled load') end
function loadfile(s) print('disabled loadfile') end
function loadstring(s) print('disabled loadstring') end
function module(s) print('disabled module') end
function require(s) print('disabled require') end

-- Remove access to IO, the operating system, sockets, images, tex, mplib

_G=nil
io=nil
os=nil
lfs=nil
socket=nil
img=nil
tex=nil
texio=nil
mplib=nil
package=nil


-- The above sandboxing definitions do not stop all potentially malicious code
-- notably non terminating loops are possible, but as tex is already capable of
-- such loops this does not increase risk. The other potential issue is excessive memory consumption
-- but similar allowed programs such as epstopdf will also use memory increasing with image complexity.



-- Concatenate all arguments, separate by space, and evaluate as Lua
-- to help with passing quotes through multiple interfaces you may use
-- @@quot@@ and @@apos@@
-- which will be replaced by " and ' before evaluation.

local texinput=""
for l = 1,#arg
do
texinput=texinput.. " ".. string.gsub(string.gsub(arg[l],'@@quot@@','"'),'@@apos@@',"'")
end
localdostring(texinput)
