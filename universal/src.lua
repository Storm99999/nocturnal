--!nolint
--[[
	                                                                                                                                      
	                                                                                                 88                  88               
	                                        ,d                                                       88                  ""               
	                                        88                                                       88                                   
	8b,dPPYba,    ,adPPYba,    ,adPPYba,  MM88MMM  88       88  8b,dPPYba,  8b,dPPYba,   ,adPPYYba,  88     8b       d8  88  8b,dPPYba,   
	88P'   `"8a  a8"     "8a  a8"     ""    88     88       88  88P'   "Y8  88P'   `"8a  ""     `Y8  88     `8b     d8'  88  88P'    "8a  
	88       88  8b       d8  8b            88     88       88  88          88       88  ,adPPPPP88  88      `8b   d8'   88  88       d8  
	88       88  "8a,   ,a8"  "8a,   ,aa    88,    "8a,   ,a88  88          88       88  88,    ,88  88  888  `8b,d8'    88  88b,   ,a8"  
	88       88   `"YbbdP"'    `"Ybbd8"'    "Y888   `"YbbdP'Y8  88          88       88  `"8bbdP"Y8  88  888    "8"      88  88`YbbdP"'   
	                                                                                                                         88           
	                                                                                                                         88           
	                                                                                                                         
	                                                                                                                         
	NOCTURNAL.VIP
	CREDITS - Author: newguy
	
	NOTES:
		- This is a collection of 90 features, all in one script
		- It is user-maintainable, meaning YOU, can update it, yourself. (or add features)
		- Forks are always welcome, however, Please do not open pull requests, as this is Discontinued, and a one time release.

	While I do admit, this is pretty poorly written and can be improved upon alot, This is so far the most optimized universal script i've ever seen.
	I average around 240 constant on Max graphics (Arsenal), with most features enabled.

	The weapon modulation features are supported afaik only on Arsenal and Counterblox, but they should work on any game that stores their weapon stats openly.
]]

local Library;
local Notification;
local CreateThread, MultiThreadList;

local Services: { [string]: any } = setmetatable({ }, {
	__index = function(Self: any, Index: string): any
		return cloneref(game.GetService(game, Index));
	end
});

local Environment: any =
	(getgenv and function(): any
		return getgenv()
	end)
	or function(): { [string]: any }
		return {}
	end

local MakeFolder: (Path: string) -> () = makefolder or function(_: string): () end
local IsFolder: (Path: string) -> boolean = isfolder or function(_: string): boolean return false end
local IsFile: (Path: string) -> boolean = isfile or function(_: string): boolean return false end
local WriteFile: (Path: string, Contents: string) -> () = writefile or function(_: string, _: string): () end
local ReadFile: (Path: string) -> string = readfile or function(_: string): string return "" end
local GetConnections: (Event: any) -> () = getconnections or function(...) return { } end
local GetUpvalue: (Upvalue: any) -> () = debug.getupvalue or function(...) end
local LoadFile: (Path: string) -> () = loadfile or function(_: string): () end
local DetourFn: (any) -> () = hookfunction or function(_: any): () end

local Request: ((Options: any) -> any)? =
	(syn and syn.request)
	or (http and http.request)
	or request

local GetCustomAsset: (Path: string) -> string =
	getcustomasset or function(_: string): string return "" end

--// math
local Floor: (number) -> number = math.floor
local Ceil: (number) -> number = math.ceil
local Abs: (number) -> number = math.abs
local Sign: (number) -> number =
	math.sign or function(X: number): number
		if X > 0 then
			return 1
		elseif X < 0 then
			return -1
		else
			return 0
		end
	end

local Max: (...number) -> number = math.max
local Min: (...number) -> number = math.min
local Sqrt: (number) -> number = math.sqrt
local Pow: (number, number) -> number = math.pow
local Exp: (number) -> number = math.exp
local Log: (number, number?) -> number = math.log

local Log10: (number) -> number =
	math.log10 or function(X: number): number
		return Log(X, 10)
	end

local Sin: (number) -> number = math.sin
local Cos: (number) -> number = math.cos
local Tan: (number) -> number = math.tan
local Asin: (number) -> number = math.asin
local Acos: (number) -> number = math.acos
local Atan: (number) -> number = math.atan
local Atan2: (number, number) -> number = math.atan2
local Pi: number = math.pi
local Huge: number = math.huge
local Random: (number?, number?) -> number = math.random
local RandomSeed: (number) -> () = math.randomseed or function(_: number): () end
local Rad: (number) -> number = math.rad
local Deg: (number) -> number = math.deg

local Clamp: (number, number, number) -> number =
	function(Value: number, Min: number, Max: number): number
		return (Value < Min and Min) or (Value > Max and Max) or Value
	end

local Lerp: (number, number, number) -> number =
	math.lerp or function(A: number, B: number, T: number): number
		return A + (B - A) * T
	end

local Round: (number) -> number =
	math.round or function(X: number): number
		return Floor(X + 0.5)
	end

local MathIsFinite: (number) -> boolean =
	(math.type and function(X: number): boolean
		return math.type(X) == "number" and X == X and X ~= Huge and X ~= -Huge
	end)
	or function(_: number): boolean
		return true
	end

--// table
local Insert: <T>(Tbl: { T }, Value: T) -> () = table.insert
local Remove: <T>(Tbl: { T }, Index: number?) -> T? = table.remove
local Concat: (Tbl: { string }, Sep: string?, I: number?, J: number?) -> string = table.concat
local Sort: <T>(Tbl: { T }, Comp: ((T, T) -> boolean)?) -> () = table.sort

local TFind: <T>(Tbl: { T }, Value: T) -> number? =
	table.find or function<T>(T: { T }, V: T): number?
		for I = 1, #T do
			if T[I] == V then
				return I
			end
		end
		return nil
	end

local Clear: (Tbl: { [any]: any }) -> () =
	table.clear or function(T: { [any]: any }): ()
		for K in T do
			T[K] = nil
		end
	end

local Clone: <T>(Tbl: T) -> T =
	table.clone or function<T>(T: T): T
		local N: any = {}
		for K, V in T do
			N[K] = V
		end
		return N
	end

local Move: (Src: { any }, F: number, L: number, Idx: number, Dst: { any }) -> { any } =
	table.move or function(Src: { any }, F: number, L: number, Idx: number, Dst: { any }): { any }
		for I = F, L do
			Dst[Idx + I - F] = Src[I]
		end
		return Dst
	end

local Pack: (...any) -> { n: number, [number]: any } =
	table.pack or function(...: any): { n: number, [number]: any }
		return { n = select("#", ...), ... }
	end

local Freeze: <T>(Tbl: T) -> T =
	table.freeze or function<T>(_: T): T
		return {} :: any
	end

local Unpack: <T>(Tbl: { T }, I: number?, J: number?) -> ...T = table.unpack or unpack
local Create: (number, any?) -> { any } = table.create

--// string
local Byte: (string, number?, number?) -> ...number = string.byte
local Char: (...number) -> string = string.char
local Sub: (string, number, number?) -> string = string.sub
local Len: (string) -> number = string.len
local Lower: (string) -> string = string.lower
local Upper: (string) -> string = string.upper
local Find: (string, string, number?, boolean?) -> (number?, number?, ...string) = string.find
local GSub: (string, string, string | ((...any) -> string), number?) -> (string, number) = string.gsub
local Gmatch: (string, string) -> (() -> string?) = string.gmatch
local Match: (string, string, number?) -> string? = string.match
local Rep: (string, number, string?) -> string = string.rep
local Reverse: (string) -> string = string.reverse

local Split: (string, string) -> { string } =
	string.split or function(S: string, Sep: string): { string }
		local Out: { string } = {}
		for Part in S:gmatch("([^" .. Sep .. "]+)") do
			Insert(Out, Part)
		end
		return Out
	end

local Format: (string, ...any) -> string = string.format
local Trim: (string) -> string =
	string.trim or function(S: string): string
		return S:match("^%s*(.-)%s*$") or ""
	end

--// os / task
local Time: () -> number = os.time
local Clock: () -> number = os.clock
local Date: (string?, number?) -> any = os.date
local DiffTime: (number, number) -> number = os.difftime

local Tick: () -> number = tick or OsTime
local Time: () -> number = time

local Wait: (number?) -> number = (task and task.wait) or wait
local Spawn: (thread | (() -> ()), ...any) -> () = (task and task.spawn) or spawn
local Defer: ((...any) -> (), ...any) -> () =
	(task and task.defer)
	or function(F: (...any) -> (), ...: any): ()
		local Co = coroutine.create(F)
		coroutine.resume(Co, ...)
	end

local Delay: (number, (...any) -> (), ...any) -> () = (task and task.delay) or delay
local Cancel: (thread) -> () = (task and task.cancel) or function(_: thread): () end

--// bit
local BitBand: (number, number) -> number =
	(bit32 and bit32.band)
	or function(A: number, B: number): number
		local R = 0
		local Bit = 1
		for _ = 0, 31 do
			local AA = A % 2
			local BB = B % 2
			if AA == 1 and BB == 1 then
				R += Bit
			end
			A = Floor(A / 2)
			B = Floor(B / 2)
			Bit *= 2
		end
		return R
	end

local BitBor: (number, number) -> number =
	(bit32 and bit32.bor)
	or function(A: number, B: number): number
		local R = 0
		local Bit = 1
		for _ = 0, 31 do
			local AA = A % 2
			local BB = B % 2
			if AA == 1 or BB == 1 then
				R += Bit
			end
			A = Floor(A / 2)
			B = Floor(B / 2)
			Bit *= 2
		end
		return R
	end

local BitXor: (number, number) -> number =
	(bit32 and bit32.bxor)
	or function(A: number, B: number): number
		return (A + B) - 2 * (A ^ B)
	end

local BitLshift: (number, number) -> number =
	(bit32 and bit32.lshift) or function(A: number, N: number): number
		return A * (2 ^ N)
	end

local BitRshift: (number, number) -> number =
	(bit32 and bit32.rshift) or function(A: number, N: number): number
		return Floor(A / (2 ^ N))
	end

local BitNot: (number) -> number =
	(bit32 and bit32.bnot) or function(A: number): number
		return 2 ^ A
	end

local function Switch<T>(Value: T, Cases: { [T]: (() -> ()) }, Default: (() -> ())?)
    local CaseFn: (() -> ())? = Cases[Value]

    if CaseFn then
        CaseFn()
    elseif Default then
        Default()
    end
end

local function Pairs<K, V>(tbl: { [K]: V }): (()->(K, V)?) 
    local nextIndex = nil;

    return function()
        nextIndex, value = next(tbl, nextIndex);
        return nextIndex, value;
    end;
end


--// roblox
local Vec2: (number, number) -> Vector2 = Vector2.new
local Vec3: (number, number, number) -> Vector3 = vector.create
local VecEmpty: (number, number, number) -> Vector3 = vector.zero
local UDim2New: (number, number, number, number) -> UDim2 = UDim2.new
local UDimNew: (number, number) -> UDim = UDim.new
local InstanceNew: (string) -> Instance = Instance.new
local Color3New: (number, number, number) -> Color3 = Color3.new
local Color3FromRGB: (number, number, number) -> Color3 = Color3.fromRGB
local Color3FromHSV: (number, number, number, number) -> Color3 = Color3.fromHSV
local CFrameNew: (...any) -> CFrame = CFrame.new
local CFrameAngles: (...any) -> CFrame = CFrame.Angles
local CFrameLookAt: (...any) -> CFrame = CFrame.lookAt



local ColorSequenceNew: (any) -> ColorSequence = ColorSequence.new
local ColorSequenceKeypointNew: (number, Color3) -> ColorSequenceKeypoint = ColorSequenceKeypoint.new
local NumberSequenceNew: (any) -> NumberSequence = NumberSequence.new
local NumberSequenceKeypointNew: (number, number, number?) -> NumberSequenceKeypoint =
	NumberSequenceKeypoint.new

--// services
local ContextActionService: ContextActionService = Services.ContextActionService
local HttpService: HttpService = Services.HttpService
local RunService: RunService = Services.RunService
local TweenService: TweenService = Services.TweenService
local ReplicatedStorage: ReplicatedStorage = Services.ReplicatedStorage
local InputService: UserInputService = Services.UserInputService
local ScriptContext: ScriptContext = Services.ScriptContext
local LogService: LogService = Services.LogService
local PlayerService: Players = Services.Players
local Lighting: Lighting = Services.Lighting

local LocalPlayer: Player? = PlayerService.LocalPlayer
local Camera: Instance? = workspace.CurrentCamera
local Mouse: Mouse? = LocalPlayer:GetMouse()

local StartupArgs = Pack((...))[1] or { };
local ThreadList: { } = { };

local Window, Tabs;

--//
local WorldToViewportPoint: () -> () = Camera.WorldToViewportPoint;
--//

--//
local RayParams = RaycastParams.new()
RayParams.IgnoreWater = true
RayParams.FilterType = Enum.RaycastFilterType.Blacklist
--//

--// hooks
do
	for Index, Connection in GetConnections(LogService.MessageOut) do
		if Connection and Connection.Function then
			DetourFn(Connection.Function, newcclosure(function(...)
				return;
			end));
		end;
	end;

	for Index, Connection in GetConnections(ScriptContext.Error) do
		if Connection and Connection.Function then
			DetourFn(Connection.Function, newcclosure(function(...)
				return;
			end));
		end;
	end;

	DetourFn(Services.Stats.GetMemoryUsageMbForTag, function()
		return coroutine.yield();
	end)
end;

local Nocturnal: { } = {
    ['Sense'] = nil,

    ['Circle'] = nil,

    ['Connections'] = { },

    ['PlayerCache'] = {
        ['_cache'] = { },
    },

	['Humanizer'] = {
		['Sample'] = nil,
		['Tick'] = Tick(),
		['Index'] = 1,
	},

    ['Parts'] = {
		--// R15
		"Head",
        "HumanoidRootPart",
		"UpperTorso",
		"LowerTorso",
		"LeftUpperArm",
		"LeftLowerArm",
		"LeftHand",
		"RightUpperArm",
		"RightLowerArm",
		"RightHand",
		"LeftUpperLeg",
		"LeftLowerLeg",
		"LeftFoot",
		"RightUpperLeg",
		"RightLowerLeg",
		"RightFoot",

		--// R6
		"Right Arm",
		"Left Arm",
		"Left Leg",
		"Right Leg",
		"Torso",
	},

	['Edges'] = {
		{ 1, 2 }, { 2, 4 }, { 4, 3 }, { 3, 1 },
		{ 5, 6 }, { 6, 8 }, { 8, 7 }, { 7, 5 },
		{ 1, 5 }, { 2, 6 }, { 3, 7 }, { 4, 8 },
	},

    ['Skies'] = {
		["Purple Nebula"] = {
			["SkyboxBk"] = "rbxassetid://159454299",
			["SkyboxDn"] = "rbxassetid://159454296",
			["SkyboxFt"] = "rbxassetid://159454293",
			["SkyboxLf"] = "rbxassetid://159454286",
			["SkyboxRt"] = "rbxassetid://159454300",
			["SkyboxUp"] = "rbxassetid://159454288"
		},

		["Night Sky"] = {
			["SkyboxBk"] = "rbxassetid://12064107",
			["SkyboxDn"] = "rbxassetid://12064152",
			["SkyboxFt"] = "rbxassetid://12064121",
			["SkyboxLf"] = "rbxassetid://12063984",
			["SkyboxRt"] = "rbxassetid://12064115",
			["SkyboxUp"] = "rbxassetid://12064131"
		},

		["Pink Daylight"] = {
			["SkyboxBk"] = "rbxassetid://271042516",
			["SkyboxDn"] = "rbxassetid://271077243",
			["SkyboxFt"] = "rbxassetid://271042556",
			["SkyboxLf"] = "rbxassetid://271042310",
			["SkyboxRt"] = "rbxassetid://271042467",
			["SkyboxUp"] = "rbxassetid://271077958"
		},

		["Morning Glow"] = {
			["SkyboxBk"] = "rbxassetid://1417494030",
			["SkyboxDn"] = "rbxassetid://1417494146",
			["SkyboxFt"] = "rbxassetid://1417494253",
			["SkyboxLf"] = "rbxassetid://1417494402",
			["SkyboxRt"] = "rbxassetid://1417494499",
			["SkyboxUp"] = "rbxassetid://1417494643"
		},

		["Setting Sun"] = {
			["SkyboxBk"] = "rbxassetid://626460377",
			["SkyboxDn"] = "rbxassetid://626460216",
			["SkyboxFt"] = "rbxassetid://626460513",
			["SkyboxLf"] = "rbxassetid://626473032",
			["SkyboxRt"] = "rbxassetid://626458639",
			["SkyboxUp"] = "rbxassetid://626460625"
		},

		["Seaside Sky"] = {
			["SkyboxBk"] = "http://www.roblox.com/asset/?id=4495864450",
			["SkyboxDn"] = "http://www.roblox.com/asset/?id=4495864887",
			["SkyboxFt"] = "http://www.roblox.com/asset/?id=4495865458",
			["SkyboxLf"] = "http://www.roblox.com/asset/?id=4495866035",
			["SkyboxRt"] = "http://www.roblox.com/asset/?id=4495866584",
			["SkyboxUp"] = "http://www.roblox.com/asset/?id=4495867486"
		},

		["Fade Blue"] = {
			["SkyboxBk"] = "rbxassetid://153695414",
			["SkyboxDn"] = "rbxassetid://153695352",
			["SkyboxFt"] = "rbxassetid://153695452",
			["SkyboxLf"] = "rbxassetid://153695320",
			["SkyboxRt"] = "rbxassetid://153695383",
			["SkyboxUp"] = "rbxassetid://153695471"
		},

		["Elegant Morning"] = {
			["SkyboxBk"] = "rbxassetid://153767241",
			["SkyboxDn"] = "rbxassetid://153767216",
			["SkyboxFt"] = "rbxassetid://153767266",
			["SkyboxLf"] = "rbxassetid://153767200",
			["SkyboxRt"] = "rbxassetid://153767231",
			["SkyboxUp"] = "rbxassetid://153767288"
		},

		["Neptune"] = {
			["SkyboxBk"] = "rbxassetid://218955819",
			["SkyboxDn"] = "rbxassetid://218953419",
			["SkyboxFt"] = "rbxassetid://218954524",
			["SkyboxLf"] = "rbxassetid://218958493",
			["SkyboxRt"] = "rbxassetid://218957134",
			["SkyboxUp"] = "rbxassetid://218950090"
		},

		["Redshift"] = {
			["SkyboxBk"] = "rbxassetid://401664839",
			["SkyboxDn"] = "rbxassetid://401664862",
			["SkyboxFt"] = "rbxassetid://401664960",
			["SkyboxLf"] = "rbxassetid://401664881",
			["SkyboxRt"] = "rbxassetid://401664901",
			["SkyboxUp"] = "rbxassetid://401664936"
		},

		["Aesthetic Night"] = {
			["SkyboxBk"] = "rbxassetid://1045964490",
			["SkyboxDn"] = "rbxassetid://1045964368",
			["SkyboxFt"] = "rbxassetid://1045964655",
			["SkyboxLf"] = "rbxassetid://1045964655",
			["SkyboxRt"] = "rbxassetid://1045964655",
			["SkyboxUp"] = "rbxassetid://1045962969"
		}
	},

    ['Textures'] = { 
        ['None'] = '', 
        ['Hex'] = 'http://www.roblox.com/asset/?id=488275840', 
        ['Stars'] = 'http://www.roblox.com/asset/?id=7209784983'
    },

	['MoveInput'] = {
		['Forward'] = 0,
		['Right'] = 0,
		['Up'] = 0,
	},

	["RayParameters"] = {
        ["Raycast"] = {
            ["TotalParams"] = 3,
            ["Arguments"] = {
                "Instance",
                "Vector3",
                "Vector3",
                "RaycastParams"
            }
        },
        ["FindPartOnRayWithIgnoreList"] = {
            ["TotalParams"] = 3,
            ["Arguments"] = {
                "Instance",
                "Ray",
                "table",
                "boolean",
                "boolean"
            }
        },
        ["FindPartOnRayWithWhitelist"] = {
            ["TotalParams"] = 3,
            ["Arguments"] = {
                "Instance",
                "Ray",
                "table",
                "boolean"
            }
        },
        ["FindPartOnRay"] = {
            ["TotalParams"] = 2,
            ["Arguments"] = {
                "Instance",
                "Ray",
                "Instance",
                "boolean",
                "boolean"
            }
        }
    },

	['Directions'] = {
		Vec3(-1, 0, 0),
		Vec3(0, 0, 1),
		Vec3(1, 0, 0),
		Vec3(0, 0, -1)
	},

	['Yaws'] = {
		-90,
		0, 
		90, 
		180 
	},

	["EasingStyles"] = {
        ["Linear"] = function(t)
            return t
        end,
        ["QuadIn"] = function(t)
            return t ^ 2
        end,
        ["QuadOut"] = function(t)
            return t * (2 - t)
        end,
        ["QuadInOut"] = function(t)
            if t < 0.5 then
                return 2 * t ^ 2
            else
                return -1 + (4 - 2 * t) * t
            end
        end,
        ["CubicIn"] = function(t)
            return t ^ 3
        end,
        ["CubicOut"] = function(t)
            local f = t - 1
            return f ^ 3 + 1
        end,
        ["CubicInOut"] = function(t)
            if t < 0.5 then
                return 4 * t ^ 3
            else
                local f = 2 * t - 2
                return 0.5 * f ^ 3 + 1
            end
        end,
        ["QuartIn"] = function(t)
            return t ^ 4
        end,
        ["QuartOut"] = function(t)
            local f = t - 1
            return 1 - f ^ 4
        end,
        ["QuartInOut"] = function(t)
            if t < 0.5 then
                return 8 * t ^ 4
            else
                local f = t - 1
                return 1 - 8 * f ^ 4
            end
        end,
        ["QuintIn"] = function(t)
            return t ^ 5
        end,
        ["QuintOut"] = function(t)
            local f = t - 1
            return f ^ 5 + 1
        end,
        ["QuintInOut"] = function(t)
            if t < 0.5 then
                return 16 * t ^ 5
            else
                local f = 2 * t - 2
                return 0.5 * f ^ 5 + 1
            end
        end,
        ["SineIn"] = function(t)
            return 1 - Cos(t * Pi / 2)
        end,
        ["SineOut"] = function(t)
            return Sin(t * Pi / 2)
        end,
        ["SineInOut"] = function(t)
            return -0.5 * (Cos(Pi * t) - 1)
        end,
        ["ExpoIn"] = function(t)
            if t == 0 then
                return 0
            else
                return 2 ^ (10 * (t - 1))
            end
        end,
        ["ExpoOut"] = function(t)
            if t == 1 then
                return 1
            else
                return 1 - 2 ^ (-10 * t)
            end
        end,
        ["ExpoInOut"] = function(t)
            if t == 0 then
                return 0
            elseif t == 1 then
                return 1
            elseif t < 0.5 then
                return 0.5 * 2 ^ (20 * t - 10)
            else
                return 1 - 0.5 * 2 ^ (-20 * t + 10)
            end
        end,
        ["CircIn"] = function(t)
            return 1 - Sqrt(1 - t ^ 2)
        end,
        ["CircOut"] = function(t)
            return Sqrt(1 - (t - 1) ^ 2)
        end,
        ["CircInOut"] = function(t)
            if t < 0.5 then
                return 0.5 * (1 - Sqrt(1 - 4 * t ^ 2))
            else
                return 0.5 * (Sqrt(1 - (2 * t - 2) ^ 2) + 1)
            end
        end,
        ["BackIn"] = function(t)
            local s = 1.70158
            return t ^ 3 - s * t ^ 2 * Sin(t * Pi)
        end,
        ["BackOut"] = function(t)
            local s = 1.70158
            local f = t - 1
            return f ^ 3 + s * f ^ 2 * Sin(f * Pi) + 1
        end,
        ["BackInOut"] = function(t)
            local s = 1.70158 * 1.525
            if t < 0.5 then
                return 0.5 * (2 * t) ^ 2 * ((s + 1) * 2 * t - s)
            else
                local f = 2 * t - 2
                return 0.5 * (f ^ 2 * ((s + 1) * f + s) + 2)
            end
        end,
        ["ElasticIn"] = function(t)
            if t == 0 then
                return 0
            elseif t == 1 then
                return 1
            else
                return -2 ^ (10 * (t - 1)) * Sin((t - 1.075) * (2 * Pi) / 0.3)
            end
        end,
        ["ElasticOut"] = function(t)
            if t == 0 then
                return 0
            elseif t == 1 then
                return 1
            else
                return 2 ^ (-10 * t) * Sin((t - 0.075) * (2 * Pi) / 0.3) + 1
            end
        end,
        ["ElasticInOut"] = function(t)
            if t == 0 then
                return 0
            elseif t == 1 then
                return 1
            elseif t < 0.5 then
                return -0.5 * 2 ^ (20 * t - 10) * Sin((20 * t - 11.125) * (2 * Pi) / 0.45)
            else
                return 0.5 * 2 ^ (-20 * t + 10) * Sin((20 * t - 11.125) * (2 * Pi) / 0.45) + 1
            end
        end,
        ["BounceOut"] = function(t)
            if t < 1 / 2.75 then
                return 7.5625 * t ^ 2
            elseif t < 2 / 2.75 then
                local f = t - 1.5 / 2.75
                return 7.5625 * f ^ 2 + 0.75
            elseif t < 2.5 / 2.75 then
                local f = t - 2.25 / 2.75
                return 7.5625 * f ^ 2 + 0.9375
            else
                local f = t - 2.625 / 2.75
                return 7.5625 * f ^ 2 + 0.984375
            end
        end,
        ["BounceIn"] = function(t)
            return 1 - (function(tt)
                    if tt < 1 / 2.75 then
                        return 7.5625 * tt ^ 2
                    elseif tt < 2 / 2.75 then
                        local f = tt - 1.5 / 2.75
                        return 7.5625 * f ^ 2 + 0.75
                    elseif tt < 2.5 / 2.75 then
                        local f = tt - 2.25 / 2.75
                        return 7.5625 * f ^ 2 + 0.9375
                    else
                        local f = tt - 2.625 / 2.75
                        return 7.5625 * f ^ 2 + 0.984375
                    end
                end)(1 - t)
        end,
        ["BounceInOut"] = function(t)
            if t < 0.5 then
                local x = t * 2
                return 0.5 * (1 - (function(tt)
                            if tt < 1 / 2.75 then
                                return 7.5625 * tt ^ 2
                            elseif tt < 2 / 2.75 then
                                local f = tt - 1.5 / 2.75
                                return 7.5625 * f ^ 2 + 0.75
                            elseif tt < 2.5 / 2.75 then
                                local f = tt - 2.25 / 2.75
                                return 7.5625 * f ^ 2 + 0.9375
                            else
                                local f = tt - 2.625 / 2.75
                                return 7.5625 * f ^ 2 + 0.984375
                            end
                        end)(1 - x))
            else
                local x = t * 2 - 1
                return 0.5 * (function(tt)
                        if tt < 1 / 2.75 then
                            return 7.5625 * tt ^ 2
                        elseif tt < 2 / 2.75 then
                            local f = tt - 1.5 / 2.75
                            return 7.5625 * f ^ 2 + 0.75
                        elseif tt < 2.5 / 2.75 then
                            local f = tt - 2.25 / 2.75
                            return 7.5625 * f ^ 2 + 0.9375
                        else
                            local f = tt - 2.625 / 2.75
                            return 7.5625 * f ^ 2 + 0.984375
                        end
                    end)(x) + 0.5
            end
        end
    },

	['EasingStylesList'] = {
		'Linear', 'QuadIn', 'QuadOut', 'QuadInOut',
		'CubicIn', 'CubicOut', 'CubicInOut',
		'QuartIn', 'QuartOut', 'QuartInOut',
		'QuintIn', 'QuintOut', 'QuintInOut',
		'SineIn', 'SineOut', 'SineInOut',
		'ExpoIn', 'ExpoOut', 'ExpoInOut',
		'CircIn', 'CircOut', 'CircInOut',
		'BackIn', 'BackOut', 'BackInOut',
		'ElasticIn', 'ElasticOut', 'ElasticInOut',
		'BounceIn', 'BounceOut', 'BounceInOut'
	},

	['GetSecuredFolder'] = function() local a = workspace:FindFirstChild("_securefolder") if a then return a else a = InstanceNew("Folder", workspace) a.Name = "_securefolder" return a end return nil end,

    ['LoadComplete'] = false,
};

function Nocturnal:FormatTime(seconds: any): string
	if seconds < 0.001 then
		return Format("%.3f µs", seconds * 1e6);
	elseif seconds < 1 then
		return Format("%.3f ms", seconds * 1000);
	else
		return Format("%.3f s", seconds);
	end;
end;

function Nocturnal:Download(FileName: string, User: string, Repository: string, File: string): { }
	if IsFile(FileName) then return end;

	local Url: string = Format("https://github.com/%s/%s/blob/main/%s?raw=true", User, Repository, File);
	local OK, Statement = pcall(function()
		local Data = game:HttpGetAsync(Url);

		pcall(WriteFile, FileName, Data);
	end)

	if OK then
        return { true, OK, Statement };
    else
        warn("[nocturnal @ downloader]", OK, Statement);
        return { false, OK, Statement };
    end;
end;

--// fetch
do
	assert(WriteFile, "[nocturnal @ fetch] Unsupported executor. | ", Nocturnal:FormatTime(Clock()));
	assert(getgc, "[nocturnal @ fetch] Unsupported executor. | ", Nocturnal:FormatTime(Clock()));

	Nocturnal:Download("src.lua", "Storm99999", "nocturnal", "universal/src.lua");
	Nocturnal:Download("esp.lua", "Storm99999", "nocturnal", "universal/esp.lua");
	Nocturnal:Download("lib.lua", "Storm99999", "nocturnal", "universal/lib.lua");
	Nocturnal:Download("ntf.lua", "Storm99999", "nocturnal", "universal/ntf.lua");
end;

function Nocturnal:GetFileName(Path: string)
    return Path:match("[^\\/]+$") or Path;
end

function Nocturnal:Draw(Inst: DrawingObject, Properties: DrawingProperties)
	local Object: any = Drawing.new(Inst);

	for Index, Property in Properties or {} do
		local succ, err = pcall(function()
			Object[Index] = Property;
		end);

		if not succ then
			warn(err);
		end;
	end;

	return Object;
end;

function Nocturnal:Corners(part: Instance): { Vector3 }
	local s = part.Size * 0.5;

	return { 
		Vec3(-s.X, -s.Y, -s.Z), 
		Vec3(s.X, -s.Y, -s.Z), 
		Vec3(-s.X, -s.Y, s.Z), 
		Vec3(s.X, -s.Y, s.Z), 
		Vec3(-s.X, s.Y, -s.Z), 
		Vec3(s.X, s.Y, -s.Z), 
		Vec3(-s.X, s.Y, s.Z), 
		Vec3(s.X, s.Y, s.Z), 
	};
end;

function Nocturnal:Raycast(Origin: Vector3, Direction: Vector3)
	local Params = RaycastParams.new();
	Params.FilterDescendantsInstances = { LocalPlayer.Character, Camera };
	Params.FilterType = Enum.RaycastFilterType.Exclude;
				
	return workspace:Raycast(Origin, Direction, Params);
end

function Nocturnal:IsValid(Parameters: { }, Method: { })
	local Matches: number = 0;

	if #Parameters < Method.TotalParams then
		return false;
	end;

	for Index, Argument in Parameters do
		if typeof(Argument) == Method.Arguments[Index] then
			Matches += 1;
		end;
	end;
			
	return Matches >= Method.TotalParams;
end

function Nocturnal:DirectAt(Origin: Vector3, Position: Vector3)
	return (Position - Origin).Unit * 1000;
end

function Nocturnal:IsVisible(part: BasePart?, ignoreList: { })
	if not Part or not Part:IsDescendantOf(workspace) then
		return false
	end

	local Origin = Camera.CFrame.Position
	local Direction = Part.Position - Origin

	if Direction.Magnitude <= 1e-6 then
		return true
	end

	RayParams.FilterDescendantsInstances = ignoreList

	local Result = workspace:Raycast(Origin, Direction, RayParams);

	if not Result then
		return true;
	end;

	return Result.Instance:IsDescendantOf(Part.Parent);
end

pcall(function()
    Notification = LoadFile("ntf.lua")();
    Environment().noct_notif = Notification;
end);

pcall(function()
    Library = LoadFile("lib.lua")();
    Environment().Library = Library;

    CreateThread, MultiThreadList = function(Func: (...any) -> (), ...: any): thread
        local Thread: thread = Library.Utility:CreateThread(Func, ...)
        Insert(ThreadList, Thread)

        return Thread;
    end, function(JobList: { any }, ...: any): { thread }
        local Threads: { thread } = {}

        local Count: number = #JobList
        if Count == 0 then return Threads end

        for i = 1, Count do
            local Item = JobList[i]

            if type(Item) == "table" then
                local Fn: (() -> ())? = Item[1]
                local Args: { any }? = Item[2]
                if type(Fn) == "function" then
                    local Thread: thread
                    if Args and type(Args) == "table" then
                        Thread = Library.Utility:CreateThread(Fn, Unpack(Args));
                    else
                        Thread = Library.Utility:CreateThread(Fn);
                    end;

                    Insert(Threads, Thread);
                    Insert(ThreadList, Thread);
                end;
            elseif type(Item) == "function" then
                local Thread: thread = Library.Utility:CreateThread(Item, ...);
                Insert(Threads, Thread);
                Insert(ThreadList, Thread);
            end;
        end;

        return Threads;
    end;
end);

pcall(function()
	if not IsFolder("nocturnal_remastered/samples/") then
		MakeFolder("nocturnal_remastered/samples/");
	end;
end);

pcall(function()
    Nocturnal.Sense = LoadFile("esp.lua")();
    Nocturnal.Sense.Load();
end);

if not Library or not Notification or not Nocturnal.Sense then return end;

pcall(function()
    Library:Init();
end);

pcall(function() setfflag("AdornShadingAPI", "true") end);
pcall(function() Nocturnal.ViewmodelPath = StartupArgs.ViewmodelPath or Camera end);
pcall(function() function Nocturnal:IsFriendly(Player: Player) return Player.Team == LocalPlayer.Team end end)

pcall(function()
	local GameLookup = {
		[6035872082] = {
			ViewmodelPath = workspace:FindFirstChild("ViewModels") and workspace:FindFirstChild("ViewModels"):FindFirstChild("FirstPerson") or nil,
			TeamPath = nil
		},

		[7072674902] = {
			ViewmodelPath = workspace.CurrentCamera,
			TeamFunc = function(Self, Player: Player): boolean
				if Player:FindFirstChild("PlayerStates") then
					return Player.PlayerStates.Team.Value == LocalPlayer.PlayerStates.Team.Value;
				end;

				return false;
			end
		},

		[111958650] = {
			DoWork = function(Self): nil
				Insert(Nocturnal.Parts, "FakeHead")
			end
		}
	};

	for Id, Game in GameLookup do
		if rawequal(game.GameId, Id) then
			if Game.ViewmodelPath then
				Nocturnal.ViewmodelPath = Game.ViewmodelPath;
			end;

			if Game.TeamFunc then
				Nocturnal.IsFriendly = nil;
				Nocturnal.IsFriendly = Game.TeamFunc;
			end;

			if Game.DoWork then
				CreateThread(Game.DoWork);
			end;
		end;
	end;
end);

function Nocturnal:RotationY(CoordinateFrame: CFrame): CFrame
    local X, Y, Z = CoordinateFrame:ToOrientation();
    
    return CFrameNew(CoordinateFrame.Position) * CFrameAngles(0, Y, 0);
end;

function Nocturnal.PlayerCache:Update()
    Clear(self._cache);

    local Players = PlayerService:GetPlayers()

    for Index = 1, #Players do
        local Player: Player?   = Players[Index];
		if Player == LocalPlayer then continue end;
		if Nocturnal:IsFriendly(Player) and not Library.Flags["legit.team"] then continue end;

        local Character: Model? = Player.Character;
		local BodyParts: { }    = {};
        local Alive: boolean    = Character and Character:FindFirstChild("Humanoid") and Character.Humanoid.Health > 0 or false;

        if Character then
            for j = 1, #Nocturnal.Parts do
                local PartName = Nocturnal.Parts[j];
                local Part = Character:FindFirstChild(PartName);

                if Part then
                    BodyParts[PartName] = Part;
                end;
            end;
        end;


        self._cache[Player.Name] = {
            ["PlayerInstance"] = Player,
            ["BodyParts"]      = BodyParts,
            ["Alive"]          = Alive
        };
    end
end;

function Nocturnal:GetPlayers(): { [string]: any }
    return Clone(self.PlayerCache._cache);
end;

function Nocturnal:Alive(): boolean
	return LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health > 0 or false
end;

function Nocturnal:ClearAllChams(): ()
	for _, Entry in self.PlayerCache._cache do
		local Char = Entry.PlayerInstance.Character;
		if not Char then continue end;

		local Highlight = Char:FindFirstChild("Chams");

		if Highlight and Highlight:IsA("Highlight") then
			Highlight:Destroy();
		end;

		for _, Part in Pairs(Entry.BodyParts) do
			if Part and Part.Parent then
				for _, Obj in Part:GetChildren() do
					if Obj.Name == "Chams"
						or Obj.Name == "Glow"
						or Obj:IsA("HandleAdornment") then

						Obj:Destroy();
					end;
				end;
			end;
		end;
	end;
end;

function Nocturnal:GetStrafeTarget(MaxDistance: number): BasePart?
	local Character: Model? = LocalPlayer.Character
	if not Character then return nil end

	local Root: BasePart? = Character:FindFirstChild("HumanoidRootPart") :: BasePart?
	if not Root then return nil end

	local ClosestRoot: BasePart? = nil
	local ClosestDistance: number = MaxDistance

	for _, Entry: PlayerEntry in Nocturnal.PlayerCache._cache do
		if not Entry.Alive then continue end

		local EnemyCharacter: Model? = Entry.PlayerInstance.Character
		if not EnemyCharacter then continue end

		local EnemyRoot: BasePart? =
			EnemyCharacter:FindFirstChild("HumanoidRootPart") :: BasePart?
		if not EnemyRoot then continue end

		local Distance: number = (EnemyRoot.Position - Root.Position).Magnitude

		if Distance < ClosestDistance then
			ClosestRoot = EnemyRoot
			ClosestDistance = Distance
		end
	end

	return ClosestRoot
end

function Nocturnal:GetStrafeCFrame(
	StrafeMode: string,
	SelfRoot: BasePart,
	TargetRoot: BasePart,
	Radius: number,
	DeltaTime: number
): CFrame?

	local Result: CFrame? = nil

	Nocturnal._strafeAngle = Nocturnal._strafeAngle or 0
	Nocturnal._strafeAngle += DeltaTime * Library.Flags["move.strafespeed"]

	Switch(StrafeMode, {

		Circle = function()
			local Angle: number = Nocturnal._strafeAngle

			local Offset: Vector3 = Vec3(
				Cos(Angle) * Radius,
				0,
				Sin(Angle) * Radius
			)

			Result = CFrameNew(
				TargetRoot.Position + Offset,
				TargetRoot.Position
			)
		end,

		Ontop = function()
			Result = CFrameNew(
				TargetRoot.Position + Vec3(0, Radius, 0),
				TargetRoot.Position
			)
		end,

		Underground = function()
			Result = CFrameNew(
				TargetRoot.Position - Vec3(0, Radius, 0),
				TargetRoot.Position
			)
		end

	}, function()
		Result = nil
	end)

	return Result;
end;

function Nocturnal:GetFreestandYaw(): number
	local Torso: BasePart = LocalPlayer.Character.PrimaryPart;
	local Origin: Vector3 = Torso.Position;

	local RayParams: RaycastParams = RaycastParams.new();
	RayParams.FilterDescendantsInstances = { LocalPlayer.Character, Camera };
	RayParams.FilterType = Enum.RaycastFilterType.Blacklist;

	local BestDirection: number = 0
	local MaxDist: number = -Huge

	for i = 1, #Nocturnal.Directions do
		local Result: RaycastResult? = workspace:Raycast(Origin, Nocturnal.Directions[i] * 100, RayParams);
		local Dist: number = Result and (Result.Position - Origin).Magnitude or 100;

		if Dist > MaxDist then
			MaxDist = Dist;
			BestDirection = Nocturnal.Yaws[i];
		end;
	end;

	return BestDirection;
end

function Nocturnal:FindBestTarget(IsRage: boolean?): (Player?, BasePart?)
    if not Camera or not LocalPlayer then
        return nil, nil
    end

    local IgnoreList = {}
    local Char = LocalPlayer.Character

    if Char then
        IgnoreList[1] = Char
    end

    IgnoreList[#IgnoreList + 1] = Camera;

    local Flags = Library.Flags
    local UseFOV = Flags["world.fov"]
    local FOVSize = Flags["world.fov.size"]
    local HitboxMode = Flags["legit.hitbox"]
    local WallCheck = Flags["legit.visible"]

    local MouseX = Mouse.X
    local MouseY = Mouse.Y
    local MouseVec = Vec2(MouseX, MouseY)

    local BestDistance = Huge
    local BestPlayer = nil
    local BestPart = nil

    local List = self.PlayerCache._cache

    for _, Data in self.PlayerCache._cache do
        if not Data.Alive then
            continue
        end

        local Parts = Data.BodyParts
        local Root = Parts.HumanoidRootPart

        if not Root then
            continue
        end

        local RootPos, OnScreen = WorldToViewportPoint(Camera, Root.Position)

        if not OnScreen then
            continue
        end

        if not IsRage and UseFOV then
            local dx = RootPos.X - MouseX
            local dy = RootPos.Y - MouseY
            if (dx * dx + dy * dy) > (FOVSize * FOVSize) then
                continue
            end
        end

        local Head = Parts.Head
        local Torso = Parts.UpperTorso or Parts.Torso
        local Hitbox: BasePart? = nil

        --// Hitbox selection
        if HitboxMode == "Head" then
            Hitbox = Head
        elseif HitboxMode == "Body" then
            Hitbox = Torso
        else
            if Head and Torso then
                local hx, hOn = WorldToViewportPoint(Camera, Head.Position)
                local tx, tOn = WorldToViewportPoint(Camera, Torso.Position)

                if hOn and tOn then
                    local hdx = hx.X - MouseX
                    local hdy = hx.Y - MouseY
                    local tdx = tx.X - MouseX
                    local tdy = tx.Y - MouseY

                    Hitbox = ((hdx * hdx + hdy * hdy) < (tdx * tdx + tdy * tdy)) and Head or Torso
                else
                    Hitbox = hOn and Head or (tOn and Torso)
                end
            else
                Hitbox = Head or Torso
            end
        end

        if not Hitbox then
            continue
        end

        if not IsRage and WallCheck and not self:IsVisible(Hitbox, IgnoreList) then
            continue
        end

        local ScreenPos, Visible = WorldToViewportPoint(Camera, Hitbox.Position)
        if not Visible then
            continue
        end

        local dx = ScreenPos.X - MouseX
        local dy = ScreenPos.Y - MouseY
        local Dist = dx * dx + dy * dy

        if Dist < BestDistance then
            BestDistance = Dist
            BestPlayer = Data.PlayerInstance
            BestPart = Hitbox
        end
    end

    return BestPlayer, BestPart
end


CreateThread(function()
    while Wait(1) do
        Nocturnal.PlayerCache:Update();
    end;
end);

Insert(Nocturnal.Connections, PlayerService.PlayerAdded:Connect(function(Player: Player?)
    Nocturnal.PlayerCache:Update();
end))

Insert(Nocturnal.Connections, PlayerService.PlayerRemoving:Connect(function(Player: Player?)
    Nocturnal.PlayerCache._cache[Player.Name] = nil;
end))

--// UI
do
    Window =
        Library:Window(
        {
            Title = "Nocturnal Remastered"
        }
    );

    Tabs = {
        ["Legit"] = Window:Tab("Legit", 1),
        ["Rage"] = Window:Tab("Rage", 2),
        ["Visuals"] = Window:Tab("Visuals", 3),
        ["Misc"] = Window:Tab("Misc", 4)
    };

    --// Settings
    Library:CreateSettings(Window);

    --// Legit
    do
        local main = Tabs.Legit:Section("Legitbot", 1, 1);
        local filter = Tabs.Legit:Section("Filters", 2, 1);
        local trigger = Tabs.Legit:Section("Triggerbot", 2, 2);
        local rcs = Tabs.Legit:Section("Recoil Control", 1, 3);

        main:Toggle( { Flag = "legit.enabled", Text = "Enabled" } ):Bind(
            {
                Flag = "legit.key",
                Text = "Aimbot",
                Mode = "hold",
                Bind = "NONE",
                Callback = function(E)
                end
            }
        )
		
		main:Toggle( { Flag = "legit.humanizer", Text = "Humanizer" } )

        main:Slider( { Flag = "legit.smooth", Text = "Smoothing", Min = 0, Max = 100, Value = 20, Suffix = "%" } )

        main:Dropdown(
            {
                Flag = "legit.hitbox",
                Text = "Target Hitbox",
                Values = {"Head", "Body", "Closest"},
                Selected = "Head"
            }
        )

        main:Dropdown(
            {
                Flag = "legit.meth",
                Text = "Smoothing Curve",
                Values = { "Linear", "Exponential", "EaseInOut", "WeightedAverage" },
                Selected = "Linear"
            }
        )

		local SampleDropdown = main:Dropdown(
            {
                Flag = "legit.humansample",
                Text = "Humanizer Sample",
                Values = { },
                Selected = "",
				Callback = function(Sample: string): ()
					if not IsFile("nocturnal_remastered/samples/" .. Sample) then
						return;
					end;

					local OK, Decode = pcall(function()
						return HttpService:JSONDecode(ReadFile("nocturnal_remastered/samples/" .. Sample));
					end)

					if OK then
						local VecSample: { } = { };

						for Index, Value in Pairs(Decode) do
							VecSample[Index] = Vec2(Value.x, Value.y);
						end;

						Nocturnal.Humanizer.Sample = VecSample;
						Nocturnal.Humanizer.Index = 1;
						Nocturnal.Humanizer.Tick = Tick();
					else
						Nocturnal.Humanizer.Sample = nil;
						Nocturnal.Humanizer.Index = 1;
						Nocturnal.Humanizer.Tick = Tick();
					end;
				end
            }
        )
		
		local Files = listfiles("nocturnal_remastered/samples/")
		for _, FullPath in Pairs(Files) do
			SampleDropdown:AddValue(Nocturnal:GetFileName(FullPath))
		end

		CreateThread(function()
			while Wait(3) do
				SampleDropdown:ClearValues();
				local Files = listfiles("nocturnal_remastered/samples/");

				for _, FullPath in Pairs(Files) do
					SampleDropdown:AddValue(Nocturnal:GetFileName(FullPath));
				end;
			end
		end)

		main:Dropdown(
            {
                Flag = "legit.cammethod",
                Text = "Method",
                Values = { "Mouse", "Camera" },
                Selected = "Mouse"
            }
        )


        filter:Toggle({ Flag = "legit.team", Text = "Ignore Team" })
        filter:Toggle({ Flag = "legit.visible", Text = "Visibility Check" })
		filter:Toggle({ Flag = "world.fov", Text = "Visualizers" })

        filter:Slider(
            {
                Flag = "world.fov.size",
                Text = "FOV Size",
                Min = 10,
                Max = 500,
                Value = 150,
                Suffix = "°",
                Callback = function(Value)
                    if Nocturnal.Circle then
                        Nocturnal.Circle.Radius = Value;
                    end
                end
            }
        )


		filter:Dropdown(
			{
				Flag = "legit.deadzone.type",
				Text = "Dead Zone Type",
				Values = { "Hard", "Soft" },
				Selected = "Soft"
			}
		)

		filter:Slider({
			Flag = "legit.deadzone",
			Text = "Dead Zone",
			Min = 0,
			Max = 25,
			Value = 3,
			Suffix = "px"
		})

        trigger:Toggle({ Flag = "trigger.enabled", Text = "Enabled" })
        trigger:Toggle({ Flag = "trigger.randomize", Text = "Randomize Delay" })
        trigger:Slider({ Flag = "trigger.delay", Text = "Delay", Min = 0, Max = 250, Value = 50, Suffix = "ms" })
        trigger:Slider({ Flag = "trigger.delaymax", Text = "Delay Max", Min = 0, Max = 250, Value = 50, Suffix = "ms" })

		--// RCS, Please, do not question this. It is ported from Nocturnal v1, and is fragile.
		local smoothX = 0
		local smoothY = 0
		local SMOOTHING = .15
		local enabled = false
		local strength = 15
		local InputConnection: RBXScriptConnection
		local currentIndex = 1
		local lastGunName = ""
		local remainderX = 0
		local remainderY = 0
		local lastShootTime = 0
		local isHolding = false

		local guns = {}

		local function Normalize(str)
			return str:lower():gsub("%W", "")
		end

		local function AddGun(name, id, rpm, pattern): nil
			local gunData = {
				name = name,
				id = id,
				rpm = rpm,
				recoilPattern = pattern
			}

			guns[Normalize(name)] = gunData
		end

		AddGun(
			"AUG",
			1,
			600,
			{
				{0, 0},
				{2.222882090266193, 2.959465127391366},
				{2.311439259414717, 9.569831750358858},
				{0.036375035481399, 20.29080815488128},
				{-3.486687033130921, 33.33760877746562},
				{-0.696092814076953, 47.719471242662486},
				{3.406308922998944, 63.00722365715827},
				{10.23175762119175, 73.05811444055955},
				{13.634832385761529, 80.79069498307169},
				{20.112250083198767, 87.04543847771787},
				{12.248423980575575, 92.76442285759437},
				{9.74565333249188, 95.90836601095208},
				{16.474184154655358, 95.55639296395766},
				{16.90945636392498, 99.20489779079602},
				{5.440400492255662, 100.80211604472088},
				{-12.701747810559304, 95.33934851869235},
				{-28.349707159956427, 89.00127065104394},
				{-30.033165669765374, 92.0479680324646},
				{-32.75261229576271, 94.93571781786714},
				{-36.76204638765153, 94.48739845596984},
				{-24.74547690252887, 95.20343152580047},
				{-9.05785924129152, 96.83774207974264},
				{-1.51068331115752, 99.58276227796799},
				{-4.095434680791485, 100.19796535993362},
				{4.158934426047507, 98.9371775155192},
				{18.982421985349266, 93.52702258914763},
				{28.528317604105002, 93.59727361737633},
				{20.39315174592432, 96.057521872506},
				{12.01218410664915, 97.51933275754548},
				{10.347007170845933, 98.39823477438577}
			}
		)

		AddGun(
			"AK-47",
			223,
			600,
			{
				{0, 0},
				{-3.827636948042893, 3.536428966243171},
				{0.121165492837354, 12.858673756857806},
				{-1.2711849271449, 27.3605424641275},
				{-1.673201892334844, 42.59346607107974},
				{4.463792920096362, 58.71875911296247},
				{8.463622955365372, 72.67738087743321},
				{14.916891507104577, 82.44516349926568},
				{6.659815463504096, 89.56268273045887},
				{-14.204224560583262, 87.50140293913717},
				{-25.256739579340184, 88.79593779505954},
				{-18.72588913668821, 94.24987228877819},
				{-26.59217048249592, 97.27814488836974},
				{-39.409618443331674, 93.0454935198128},
				{-40.88200003044932, 95.54752111932157},
				{-20.961300410160202, 96.32584448266331},
				{-11.518010220412572, 99.81424250132606},
				{-4.469909867720372, 105.0723284161461},
				{9.006248167423479, 104.23676761877519},
				{25.569507149111917, 99.84373539025064},
				{15.319282441848282, 98.60579327997657},
				{18.375680236201855, 99.97202892515732},
				{15.15648101008768, 104.87009656981306},
				{10.791329701463264, 106.53245487581405},
				{20.24546987089886, 105.00756071856401},
				{23.60397143167229, 107.61090682106477},
				{13.116273340229377, 107.37700253644354},
				{-3.151668316018399, 105.73756331715488},
				{-25.88902421233086, 95.27387044126002},
				{-33.11802738944682, 95.29814441612216}
			}
		)

		local m4_pattern = {
			{0, 0},
			{0.593149889668485, 2.930082298076452},
			{0.467599252492137, 5.400722402012841},
			{-1.378824494413463, 11.98730717748309},
			{0.743137048487199, 21.072202025117463},
			{-2.338073017301649, 31.569213818164247},
			{-4.224184381458436, 43.389298022518524},
			{2.503264604071358, 50.51859139356511},
			{6.470252451534178, 56.27880589304245},
			{15.527316925591018, 59.026697413775985},
			{13.51870087620907, 63.99068138062866},
			{6.304251496325907, 66.54484911498237},
			{-6.052203590640147, 64.92335880146629},
			{-15.786608052241583, 65.18757929727312},
			{-26.49450945007401, 63.29534907815819},
			{-26.19777190292132, 64.75552981186893},
			{-22.388620350606082, 66.73098770213686},
			{-27.052202746705014, 67.17494607446021},
			{-33.18877939802228, 66.14283556099245},
			{-31.85382799345042, 66.96288788980127}
		}
		AddGun("M4A1", 38965, 666, m4_pattern)
		AddGun("M4A4", 38965, 666, m4_pattern)

		AddGun(
			"Galil",
			51191,
			666,
			{
				{0, 0},
				{2.077857360333431, 2.2495791915748},
				{0.84905967703718, 4.320737884655506},
				{3.926628908955945, 9.600868451319947},
				{9.878246473373661, 16.64580929760077},
				{9.610986697477262, 27.24516674668283},
				{10.348841239807621, 39.491856466554964},
				{13.543698774729389, 47.8876427165137},
				{18.857784390941106, 52.38716250570664},
				{16.752095014806955, 59.13697827354003},
				{5.836141504877478, 63.73169390877232},
				{-9.263443306404396, 61.69368912201999},
				{-23.656323275486606, 56.026531404243286},
				{-28.247377265885998, 59.31030128398085},
				{-34.18087082527084, 60.851591552511316},
				{-37.206360793860995, 60.89928135879738},
				{-37.46303242021487, 61.42658780711642},
				{-35.33600421746067, 65.20123224456778},
				{-22.77034676496905, 68.70240197702267},
				{-15.882469056314447, 70.28856495028266},
				{-3.504446085339037, 68.62000759309504},
				{11.883290462649704, 64.5911905993017},
				{14.845132251834926, 65.80351656607756},
				{9.085302674062307, 67.68469887133408},
				{15.277462271420456, 66.62934078310957},
				{20.446102778540503, 66.00408093783584},
				{28.53232902404034, 64.70948476457252},
				{23.816550318189243, 66.88135940333831},
				{7.701462592979505, 64.19958597166527},
				{-4.625359659193873, 62.81916414149335},
				{-11.590448854725855, 65.58327903562795},
				{-8.447212343366624, 69.61683997367848},
				{-15.697920921000085, 67.8866752748851},
				{-27.362147060743442, 60.787564568812854},
				{-34.386819438864435, 60.222093510077556}
			}
		)

		AddGun(
			"FAMAS",
			39623,
			666,
			{
				{0, 0},
				{-1.877815022167983, 2.079078040335055},
				{-1.426179848701379, 4.089731689589768},
				{-4.674170905270299, 9.166690224882464},
				{-5.059926312817549, 17.511982131036916},
				{-4.829737947224267, 28.00479403960494},
				{2.133248053065285, 36.944696369981145},
				{10.023502190160348, 42.58014824188317},
				{6.799453673709023, 48.616225146981414},
				{-2.808361360608417, 52.33993838841711},
				{-11.2405348202883, 55.377992427353846},
				{-17.728389875589517, 56.09346446621464},
				{-15.248130804657796, 58.9965342239173},
				{-3.790672139233781, 60.978173199405056},
				{1.998792580115771, 63.540701008489314},
				{11.769860271029623, 62.076755974402914},
				{14.687762038554872, 62.559386758757384},
				{22.026346708750697, 62.51747243935909},
				{23.65776018255924, 64.99417882973863},
				{21.44342079302596, 66.44315965353461},
				{8.8897989150064, 65.57737159884616},
				{7.642004828003477, 67.07702991367877},
				{12.924750299289633, 66.67644776964391},
				{20.3412830318508, 63.52183674863727},
				{28.183528005820083, 58.10815697074985}
			}
		)

		AddGun(
			"DesertEagle",
			12345,
			267,
			{
				{0, 0},
				{26.815728296829917, 31.242901752599302},
				{-3.317230599950525, 20.126243666122814},
				{-4.224166803398816, 20.04172356428791},
				{-6.864289752463892, 27.10308534055652},
				{5.954570401516337, 49.902621304156646}
			}
		)

		AddGun(
			"SG553",
			43500,
			545,
			{
				{0, 0},
				{-1.215159144305283, 2.650864194067308},
				{-2.618407656774418, 3.651866709266545},
				{-4.291565951560159, 8.348016470560214},
				{-6.330926582732133, 15.668227603086684},
				{-9.084359618215505, 25.60337745135338},
				{-11.757968841367424, 36.88227720284397},
				{-17.84508324999042, 41.423232447816495},
				{-13.370099555467132, 46.835712850673055},
				{-16.40630589884911, 50.64931017629117},
				{-21.35455060165442, 53.23281715283949},
				{-22.494471985656265, 54.6858596698778},
				{-20.543077665297403, 56.160205368166444},
				{-23.218487361519657, 58.45440816461879},
				{-22.798920368114253, 62.3404571123458},
				{-27.467867871087886, 61.13523506386782},
				{-33.165482656974405, 55.39129592091709},
				{-38.099669269626965, 53.316678174597996},
				{-39.86374461968676, 52.50356028941025},
				{-26.687739853239083, 52.69534223377693},
				{-9.897473142475858, 49.44997475867327},
				{1.832035880559232, 48.17248219674433},
				{5.409636462911261, 51.24526285286948},
				{9.216100324666591, 54.59600906676643},
				{10.530411125907179, 57.09293496413695},
				{17.159815740618065, 56.73051897049839},
				{25.701734591473766, 56.199076980113674},
				{22.86749972905878, 59.03727578253211},
				{18.58425981293327, 60.4570151316226},
				{6.707106347665074, 58.079326656754674}
			}
		)

		AddGun(
			"P90",
			6213,
			857,
			{
				{0, 0},
				{-1.512070031220564, 1.784402786107674},
				{-1.181923377554774, 3.833282948043264},
				{-0.264386755521403, 6.400265241308062},
				{-1.800011498190314, 12.111488811975322},
				{-7.163571771027064, 19.546904748335855},
				{-13.318876696492715, 25.517330917057944},
				{-18.287408069519337, 34.033993055117456},
				{-13.928956070470129, 41.09336069807538},
				{-9.031323748218979, 47.744421662848445},
				{-8.043590828965746, 53.46668318557177},
				{-6.498529637177525, 59.293671815402945},
				{-8.044275963067669, 62.93453341440814},
				{-14.365420054144886, 63.023877233652996},
				{-16.988639992033058, 64.6704754239666},
				{-20.40519553884497, 65.89516762316259},
				{-25.582678906773978, 65.86951149268306},
				{-19.487293407532594, 66.72277151663869},
				{-11.426798052066282, 67.49219366706103},
				{-6.299983400446152, 68.05728138495427},
				{-1.254667102614459, 68.72804710169068},
				{5.8048074962751, 68.25262616618589},
				{12.993267232345637, 66.65153132448035},
				{10.87420813974665, 66.4065173546085},
				{13.045518128567108, 66.93650734722254},
				{7.232342853502791, 67.04767897723622},
				{-0.12188806673845, 66.80789041067476},
				{-10.210045274443079, 65.78391255434829},
				{-11.600580452376517, 66.7600566297424},
				{-8.853378843126213, 68.51867531267273},
				{-10.642455583940183, 69.06526953853155},
				{-12.804184302226597, 70.05803515297393},
				{-9.942870443396561, 71.11183610096859},
				{-2.436996423130546, 70.8411274207295},
				{1.698459319626697, 70.45761649007778},
				{-0.13108053372384, 70.99542307869986},
				{-1.176436970292167, 71.18735815037697},
				{-7.362773158946855, 70.6132398965314},
				{-13.139624364699346, 69.63728070997941},
				{-12.146584458478959, 70.69232434769319},
				{-6.019828368607975, 70.54590369723525},
				{3.618721732332158, 68.38871034939729},
				{8.090226364203057, 67.6957067970777},
				{14.023176425925595, 67.42785748261434},
				{21.738500878522313, 65.76917718481411},
				{25.953251285617917, 66.19516451951796},
				{31.75911340998358, 64.4525847588505},
				{29.752867007511647, 65.82218516729442},
				{23.829489275210094, 67.45773858594109},
				{26.005728884437456, 66.67315878109392}
			}
		)

		AddGun(
			"TEC-9",
			789,
			500,
			{
				{0, 0},
				{0.880322281355544, 3.265015837788265},
				{5.027892833203274, 9.517318345146377},
				{12.16499727455663, 18.939061732815976},
				{6.097899214738125, 30.973237460498478},
				{-5.879380921126691, 40.736889764253334},
				{-15.723294887320817, 48.42705906222121},
				{-22.063723563836074, 55.48058988381391},
				{-18.280071837224753, 64.53692889667806},
				{-12.005599282440626, 69.90449288403624},
				{-15.348433960507627, 73.76284897555597},
				{-6.68600251282103, 74.4915455058785},
				{2.998030336869031, 74.03781034492327},
				{-1.960094140523081, 75.07349844261849},
				{-15.076828926748462, 69.36073729753723},
				{-30.031410487349145, 61.42710649400129},
				{-40.05520688741513, 59.205534669344345},
				{-29.42060668078121, 62.961290745821785},
				{-17.403641429556902, 66.62058769838534},
				{-22.652774866973616, 69.41403279522797},
				{-11.905632587224972, 71.91120924048946},
				{-11.273021906845724, 73.99454417964753},
				{-18.67896562713895, 74.79542804707944},
				{-29.736817009004966, 70.34885008098765},
				{-17.1731657113077, 69.2662132345869},
				{-21.486166021371073, 68.66149714233903},
				{-18.974547398535005, 70.33549566981972},
				{-19.729108917903314, 71.98949681097534},
				{-23.114432789266495, 73.60889195441071},
				{-8.085763390695933, 78.06549552943666},
				{11.250896317422013, 75.67432921399583},
				{6.334824448913242, 74.28588216303629}
			}
		)

		AddGun(
			"MP7",
			61649,
			750,
			{
				{0, 0},
				{0.069722261010226, 2.231823956006918},
				{-0.539265619331843, 3.842846630586771},
				{-1.982688601023381, 5.443074608031464},
				{-4.767971685332896, 10.23289258093878},
				{-9.365273666132982, 17.215859539211465},
				{-8.934055947462792, 25.626696786704613},
				{-13.803392936114664, 31.963612794930242},
				{-15.267230898544634, 38.490344617429415},
				{-20.415280418934753, 40.098545840856985},
				{-23.44685053098605, 41.821108849271006},
				{-19.318140373914662, 46.0493126896639},
				{-9.702244133638631, 48.055330095735215},
				{-0.688345730884087, 48.844519729354815},
				{6.624638240861757, 49.11976206525047},
				{7.0270841238404, 51.639012318148424},
				{3.986837788414581, 54.300692077713805},
				{2.05390170315993, 54.9549056459694},
				{0.229793583182369, 55.7914527362092},
				{2.01453583240772, 57.211289392253484},
				{1.00019995581589, 59.21155833636318},
				{-6.609532398984631, 57.6564216071025},
				{-16.47697057292021, 52.977069235396996},
				{-18.47362801424918, 52.867936099664554},
				{-23.070832483685642, 51.64112147608396},
				{-21.98901064271035, 50.57935689471713},
				{-22.455623777677403, 49.73649257083267},
				{-22.594137105632267, 50.69525541573308},
				{-24.99847629299043, 50.909889526624134},
				{-25.28629793562176, 52.36981933757136}
			}
		)

		AddGun(
			"Bizon",
			36387,
			750,
			{
				{0, 0},
				{-0.582141432484473, 2.367243502948205},
				{-1.855503827259798, 3.709796919028985},
				{-3.376870912830269, 7.463520353804084},
				{-7.264901196002766, 13.534209159776184},
				{-13.570614494623563, 20.64947346779465},
				{-12.103615303123995, 30.63328502044935},
				{-7.390266415400039, 40.02538569735912},
				{-7.138940716200523, 48.31069999261444},
				{1.97282250723648, 51.09965839205379},
				{8.906182302422538, 53.44132061005176},
				{11.706796509320172, 57.62689361873855},
				{18.811316544989662, 58.854898708570076},
				{15.608242047951416, 62.42543422345876},
				{2.863741364136844, 61.96909433871203},
				{2.65207250265792, 63.55380657710129},
				{9.005738813476594, 63.61771308372924},
				{11.894269668195744, 63.550825474889464},
				{9.963005155437706, 64.97376429539108},
				{13.317547412914601, 66.45951177162632},
				{19.493237662270836, 66.26161849556772},
				{26.8363251131168, 64.2083979056375},
				{30.858447268607865, 64.17664741933349},
				{34.232032725748226, 63.760663908353486},
				{37.62988029896281, 62.71389132528789},
				{37.56585539124334, 60.831739832458034},
				{35.52792727547551, 61.26415847324031},
				{33.9812245640443, 62.87659063513206},
				{33.2004481449899, 64.48789763060152},
				{22.65249095196128, 66.38417354965132},
				{21.26242703409898, 67.61384034363908},
				{20.582122827878383, 68.98673393089028},
				{25.47572743070285, 68.01744811617388},
				{17.97299352588149, 68.81117919588591},
				{18.429620252686263, 65.78238790208763},
				{21.06951728045704, 63.407945223002855},
				{14.870455719923367, 63.86010827648909},
				{16.045712134156393, 64.58860193518366},
				{12.096573170028742, 66.76104033520129},
				{13.266818375851658, 67.78670338198113},
				{20.65162666847717, 64.6542848815072},
				{27.283789528587654, 62.54420721009337},
				{33.514430389121316, 57.818100858642495},
				{35.934386702945226, 56.16980030941529},
				{32.395647615207245, 59.02989682536549},
				{33.20918582105514, 60.95475080604174},
				{38.29112142994005, 59.535854168924374},
				{44.067550581786286, 57.12918182298811},
				{35.11956878697619, 60.01584433405053},
				{25.8885286658902, 62.943032917989385},
				{24.98176945948776, 63.92974076495835},
				{27.24263064852074, 61.17392857094359},
				{26.74501699342961, 60.84344601647423},
				{27.611169450540466, 61.69702642249755},
				{32.224855948934305, 60.01627629463034},
				{26.12150065128629, 61.7564502573249},
				{19.28198086278661, 64.04913965786078},
				{11.16227820989455, 65.54959301716585},
				{-2.077480649994077, 63.04241260248134},
				{-5.19613296855344, 61.92030876367257},
				{-2.677008887927787, 62.9737655049631},
				{5.254405273523558, 62.992287457280284},
				{0.975086186704296, 63.407568825310655},
				{-1.939458337556546, 65.4765796871913}
			}
		)

		AddGun(
			"MAC10",
			34079,
			800,
			{
				{0, 0},
				{-2.216265608511797, 1.461116006276989},
				{-2.836459362876889, 3.351547418637371},
				{-1.406327428770925, 6.342249414568317},
				{0.556743466247412, 12.995027116747531},
				{5.684998101480691, 21.330194759279696},
				{11.387954151874638, 33.217957748332175},
				{15.621702454453395, 43.53435527503768},
				{12.819615792044228, 52.13201721445581},
				{17.15811580194303, 56.88315258498569},
				{19.10167048422839, 62.42713371374432},
				{21.352819737257896, 68.01014587163301},
				{20.14025434967339, 71.69234568071437},
				{19.02135982623825, 73.80955449280587},
				{14.283659911651643, 75.35607874292698},
				{4.017739802072862, 75.5128588771158},
				{-10.299311879612603, 72.36080488437743},
				{-11.198744678666092, 72.04781161596837},
				{-16.888913820179386, 70.23191534189347},
				{-13.601467086543366, 70.1921674175055},
				{-16.6028616072341, 69.06595069768801},
				{-22.544873219293308, 68.65545908909985},
				{-27.897930878523088, 69.66959140545633},
				{-19.938715497499413, 70.28209198828176},
				{-13.415231580192136, 71.14079715355797},
				{-5.549540349070455, 71.61887988702242},
				{5.044795954116022, 70.85569266175654},
				{6.310069788201267, 72.77640626282708},
				{-4.145436904313783, 70.27521096298422},
				{-2.979041884004872, 69.82867039819234}
			}
		)

		AddGun(
			"UMP",
			59299,
			666,
			{
				{0, 0},
				{-0.447553756112138, 3.243738451604018},
				{-2.231461892378343, 7.238728258247353},
				{-2.976766668521302, 15.906990552500382},
				{-5.35721912562942, 26.792683294427118},
				{-10.11874597116931, 38.12034706556247},
				{-11.152413439937625, 51.041045364875416},
				{-5.702217034356321, 59.727106153423904},
				{-7.8529200778257, 65.60631127361019},
				{-3.330994662930442, 72.2227322684621},
				{6.066472142757123, 76.41772907832035},
				{12.923315539753292, 78.58697508248648},
				{12.692295235931336, 80.3519411385217},
				{15.075631597538367, 83.50939719533861},
				{14.91476769939795, 86.2534297680375},
				{19.498492763345915, 84.61397580353535},
				{22.323626327482767, 83.48969495195203},
				{15.915778941400887, 86.06219403446718},
				{6.494144835598191, 87.19699076298707},
				{6.801493482263551, 86.0469817103183},
				{13.433801244092885, 83.2001819591268},
				{21.68096708698191, 82.08393905900269},
				{19.756676279979178, 83.23670173779946},
				{9.050028164895055, 82.68500404709634},
				{7.136943489910397, 82.0058823979918}
			}
		)

		local mp9_pattern = {
			{0, 0},
			{-0.303841782200537, 2.792520937197335},
			{-1.714246580759466, 4.97084994129804},
			{-0.129029042347133, 10.535952845419471},
			{-0.901293606581709, 19.311699153554947},
			{3.998611274271228, 30.028988294012752},
			{3.341943383093199, 40.45287580120788},
			{-0.641041518577608, 51.47268699816286},
			{4.627529780025419, 58.492765783097276},
			{15.06362952745987, 63.28853968383331},
			{26.124826520243406, 63.3353622862474},
			{38.84815962732787, 60.287559889991606},
			{38.385904513091084, 65.18130494771448},
			{38.8075067742448, 70.70395303284664},
			{27.147945618041742, 74.47004173424},
			{20.57277390427629, 78.87152204943186},
			{11.561928871693835, 82.51159483356491},
			{4.569040979901547, 85.6109957633187},
			{-5.917495281551617, 85.02938723688243},
			{-20.875237022946248, 79.84398112916276},
			{-18.311550065162884, 81.05245661690122},
			{-10.104635303211097, 82.48064333550738},
			{0.229841004104084, 83.00842072678327},
			{1.717147328390929, 84.12207197094625},
			{-6.955472220565271, 83.12287646316292},
			{-20.101689834400027, 79.46463695906648},
			{-23.070392703624595, 81.21791875947281},
			{-28.353669272463446, 83.53887227124113},
			{-23.61221702787463, 86.29136070516171},
			{-21.134777391438586, 88.89361865890962}
		}

		AddGun("MP9", 50729, 857, mp9_pattern);
		AddGun("MP9_alt", 50729, 857, mp9_pattern);

		AddGun(
			"Negev",
			57966,
			800,
			{
				{0, 0},
				{0.985554778432676, 3.684132561804101},
				{4.101272703940044, 8.69501274604477},
				{4.164124204583452, 18.724777646426602},
				{0.518603328801917, 30.703316600239717},
				{-4.081871401739883, 43.94827811875222},
				{-1.262865427267654, 58.26377789783995},
				{0.044465207097377, 71.36539947174965},
				{-5.703553041690306, 86.44162990790446},
				{-15.145664438784877, 96.9298457416128},
				{-17.994706935075282, 106.00369618820932},
				{-14.762811224237133, 113.87978484450936},
				{-3.990184519724612, 117.21960376435045},
				{7.81948797874669, 118.91115736096783},
				{23.62625079596893, 120.10096655864663},
				{28.75592901307781, 122.7706595248827},
				{35.05883322824389, 124.76862762551856},
				{29.972981058348715, 126.80877385524619},
				{27.97098835779552, 129.223542113227},
				{30.540992527552923, 131.73049719898506},
				{34.21806462694504, 134.57854501851642},
				{38.91279549535921, 134.2381443739862},
				{38.39614569892081, 134.27276418636217},
				{28.103806342812362, 133.55135900269775},
				{15.237097678312008, 133.64206386033456},
				{4.264023214910731, 135.8944646293456},
				{-12.341046708202605, 135.71342674507338},
				{-20.829597955416816, 135.86968828589883},
				{-17.787871141419522, 136.08799782581931},
				{-11.472353419794587, 136.89358621288986},
				{-1.920802229520826, 137.54473856346314},
				{3.874480389396064, 138.9486042938063},
				{7.852193929344909, 142.32433117233117},
				{17.150335974496798, 145.67915660410426},
				{21.185109605477532, 148.46418499725556},
				{25.555792922631426, 149.78256656618183},
				{19.196603104320086, 149.11599228290137},
				{6.070646967869495, 145.78396764537501},
				{-6.717592482224916, 143.37322282537806},
				{-18.60443479883614, 142.16704271135134},
				{-29.41416406856539, 139.12488982647437},
				{-26.2801707657242, 138.18264663935562},
				{-15.840498941592747, 137.69492770873322},
				{-15.071897807951752, 138.30049581700422},
				{-17.651577945520906, 140.7602083076362},
				{-25.606085718236486, 141.50273821565207},
				{-24.347572308278103, 142.75234194065928},
				{-20.339488429183596, 143.4676400449643},
				{-23.047150589210112, 142.42563542422758},
				{-22.06231053472401, 141.55667720778686},
				{-17.41503054109683, 144.01377953915656},
				{-8.940244355646819, 148.01972319640652},
				{1.554105076978439, 149.27054386956078},
				{9.146623814278652, 149.41237690269682},
				{6.089733871583919, 148.05086206071783},
				{-5.260693659867555, 143.48551719423918},
				{-19.96316629771239, 136.1698906447916},
				{-30.933933076683587, 134.43612399773482},
				{-44.579189288785074, 132.89708722537705},
				{-54.3266107638741, 130.46862103406107},
				{-51.88929971318348, 131.1818477933149},
				{-45.40000962314569, 133.83772728647332},
				{-43.33237398655774, 135.59556438313746},
				{-47.89527656705219, 137.26967443116826},
				{-49.05208086894835, 142.32060384327804},
				{-40.22213937918015, 140.5170483991216},
				{-25.117042307962222, 132.24499450866278},
				{-17.09335097901886, 125.41351808722196},
				{-16.78227219691709, 119.89606105943516},
				{-19.009792164650417, 119.39837817063153},
				{-14.22445992924781, 121.79602244618809},
				{-10.065110381888505, 124.64156304034904},
				{-13.901405040875176, 125.95457271561857},
				{-21.96319015321947, 126.32205914252971},
				{-23.620390044146802, 127.9499009569824},
				{-20.29501402392886, 132.1331398287987},
				{-8.322243025610602, 134.63131671050942},
				{6.891113156576055, 132.04591865626205},
				{21.871345502420315, 127.9806770626795},
				{26.926207805482917, 127.44653306729867},
				{33.40180042514775, 127.50353240900851},
				{28.56435639447287, 128.38792905261997},
				{27.554864944014938, 132.0422649040514},
				{30.691937165788318, 135.2221561926079},
				{33.70180682425932, 135.75825682267478},
				{38.165803517202384, 134.2334993405417},
				{37.62610603140598, 133.72257156885058},
				{27.40897545143463, 132.80486405358852},
				{17.114344110776045, 135.17501558974857},
				{2.779419394627588, 138.2837534344268},
				{-12.87244033403568, 135.99420546155343},
				{-20.924433944141796, 135.16300059405583},
				{-17.69094902637014, 134.995607341243},
				{-11.31017402089798, 135.72718111754403},
				{-3.445172281372707, 138.66437931645746},
				{3.373485089007222, 143.46528708693035},
				{8.499824714010987, 145.80392328255564},
				{17.29801541035648, 145.75159358192445},
				{21.099226669568154, 146.96388907324285},
				{25.3670375287258, 147.7056576016038},
				{20.40311284022905, 149.61472298161695},
				{6.968834172085077, 149.7524443046743},
				{-8.584348738236368, 145.02846963705747},
				{-18.74343406582596, 141.26892623393445},
				{-28.833488314320466, 137.14559636417195},
				{-25.463141155397835, 135.89271311572904},
				{-15.02896893836856, 135.47958480400325},
				{-14.712054096370348, 138.50574271366986},
				{-17.851230895735753, 142.19313945157512},
				{-25.2828615544982, 140.98595232565162},
				{-23.836108225361183, 141.38781569632343},
				{-19.804083022044917, 141.8442084649643},
				{-22.558336533942303, 140.84136945227215},
				{-22.15597033165013, 142.66047267747555},
				{-16.65045769475723, 146.08724358072317},
				{-8.940244355646819, 148.01972319640652},
				{1.554105076978439, 149.27054386956078},
				{9.146623814278652, 149.41237690269682},
				{6.089733871583919, 148.05086206071783},
				{-3.409067281123054, 145.43737056558803},
				{-19.525506565309275, 141.07288079327992},
				{-32.841524677616235, 137.06813740094177},
				{-44.64149090083515, 132.8556726646392},
				{-53.598484025644446, 129.19391816801937},
				{-50.89275429321312, 129.45498680162524},
				{-46.25300090286596, 133.84745087290316},
				{-44.5385614952901, 139.09547779355208},
				{-49.22221809498269, 139.61464266054327},
				{-48.757208628414276, 141.7550106685705},
				{-39.26197141351423, 138.65796715095325},
				{-23.9949931767764, 129.9810061092713},
				{-16.049474079122422, 123.18586104585358},
				{-16.201394981190322, 120.94935030590912},
				{-19.01602615470947, 120.3519877360056},
				{-13.782995373504752, 121.11877127880344},
				{-9.493350159342405, 123.27704686029273},
				{-13.340885053581806, 124.40458004078316},
				{-21.46018547525462, 124.83486043119741},
				{-23.270173776108862, 128.47890217092728},
				{-19.65154751940541, 134.2254479982155},
				{-8.04034043810163, 134.59968252979874},
				{7.009484246893028, 131.05321530118144},
				{21.897630900703536, 126.65242615244469},
				{26.896001037459403, 126.09574409678267},
				{32.77118100544909, 128.3922768922543},
				{29.38716034734682, 132.41335788762413},
				{28.160363151386615, 135.22601249996035},
				{30.978281773937127, 135.18832523152452},
				{33.782748364362725, 134.261078391195},
				{38.12225803263848, 132.22173176058635}
			}
		)

		local function GetGun()
			local gunObj = LocalPlayer:FindFirstChild("Gun") or nil;

			if gunObj and gunObj:IsA("StringValue") then
				local currentGun = gunObj.Value;

				if currentGun == "" or currentGun == "USP" or currentGun == "Zeus" then
					return nil;
				end;

				return guns[Normalize(currentGun)];
			end;

			return guns["ak47"];
		end

		local function ResetRecoil()
			currentIndex = 1
			isHolding = false
			remainderX = 0
			remainderY = 0
			smoothX = 0
			smoothY = 0
			lastShootTime = 0
		end

		InputService.InputBegan:Connect(
			function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					isHolding = true
				end
			end
		)

		InputService.InputEnded:Connect(
			function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					isHolding = false
					ResetRecoil();
				end
			end
		)

		Insert(Nocturnal.Connections, RunService.RenderStepped:Connect(
			function()
				if not enabled then
					return
				end

				if Library.Flags["rcs.method"] ~= "CS:GO" then
					return
				end

				if not isHolding then
					return
				end

				local gun = GetGun();

				if not gun then
					ResetRecoil();
					return;
				end

				local now = Tick()
				local interval = 60 / gun.rpm

				if now - lastShootTime >= interval then
					lastShootTime = now

					local pattern = gun.recoilPattern
					local curr = pattern[currentIndex]
					local prev = pattern[currentIndex - 1] or {0, 0}

					if curr then
						local mul = Library.Flags["rcs.strength"] / 100

						local moveX = ((curr[1] - prev[1]) * mul) + remainderX
						local moveY = ((curr[2] - prev[2]) * mul) + remainderY

						local fx = Floor(moveX + 0.5)
						local fy = Floor(moveY + 0.5)

						remainderX = moveX - fx
						remainderY = moveY - fy

						smoothX = smoothX + fx
						smoothY = smoothY + fy

						if currentIndex < #pattern then
							currentIndex = currentIndex + 1
						end
					end
				end

				local smoothing = Clamp((Library.Flags["rcs.strength"] / 100) * 0.15, 0.02, 0.3)

				if Abs(smoothX) > 0.01 or Abs(smoothY) > 0.01 then
					local dx = smoothX * smoothing
					local dy = smoothY * smoothing

					local ix = Floor(dx + 0.5);
					local iy = Floor(dy + 0.5);

					smoothX = smoothX - ix
					smoothY = smoothY - iy

					mousemoverel(ix, iy);
				end
			end
		))

		function Nocturnal.ControlRecoil(input, gameProcessed)
			if not enabled then
				return;
			end;

			if input.UserInputType == Enum.UserInputType.MouseButton1 and not Library.Open then
				if rawequal(Library.Flags["rcs.method"], "Linear") then
					ResetRecoil();

					isHolding = false;

					if Nocturnal:Alive() then
						while InputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
							local moveY = Max(strength / 100 * 10, 1);
							mousemoverel(0, moveY);
							Wait();
						end;
					end;
				end;
			end;
		end;

		
		rcs:Toggle({ Flag="rcs.enabled", Text="Enable", Callback = function(Value: boolean)
			enabled = Value;

			if enabled then
				InputConnection = InputService.InputBegan:Connect(Nocturnal.ControlRecoil);
			else
				if InputConnection then
					InputConnection:Disconnect();
					InputConnection = nil;
				end
			end
		end});

		rcs:Slider({ Flag="rcs.strength", Text="Strength", Min=1, Max=100, Value=100, Increment = 1, Suffix="%", Callback = function(Value: number): () strength = Value end })


		rcs:Dropdown({
            Flag = "rcs.method",
            Text = "Recoil Method",
            Values = { 'Linear', 'CS:GO' },
            Selected = "Linear"
        })
    end;

	--// Rage
    do
        local main     = Tabs.Rage:Section("Ragebot", 1, 1)
        local resolver = Tabs.Rage:Section("Resolver", 1, 2)
        local antiaim  = Tabs.Rage:Section("Anti-Aim", 2, 2)

        main:Toggle({ Flag="rage.silent", Text="Silent Aim", Risky=true })

		main:Dropdown({
            Flag="silent.mode",
            Text="Raycast Method",
            Values={"Raycast","FindPartOnRay","FindPartOnRayWithIgnoreList","FindPartOnRayWithWhitelist"},
            Selected="Raycast"
        })

        resolver:Toggle({ Flag="resolver.enabled", Text="Resolver", Risky=true })
        resolver:Dropdown({
            Flag="resolver.mode",
            Text="Resolver Mode",
            Values={"Off","Basic","Adaptive","Aggressive"},
            Selected="Adaptive"
        })

        antiaim:Toggle({ Flag="aa.enabled", Text="Enable", Risky=true })
        antiaim:Toggle({ Flag="aa.ud", Text="Upside down", Risky=true })

        antiaim:Dropdown({
            Flag="aa.pitch",
            Text="Pitch",
            Values={"Off","Up","Down","Zero"},
            Selected="Off"
        })

        antiaim:Dropdown({
            Flag="aa.yaw",
            Text="Yaw",
            Values={"Backward","Spin","Jitter","Freestanding"},
            Selected="Backward"
        })

        antiaim:Slider({ Flag="aa.jitter", Text="Jitter Amount", Min=0, Max=180, Value=90, Suffix="°", Risky = true })
    end

	--// visuals
	do
        local players         = Tabs.Visuals:Section("Player ESP", 1, 1)
        local chams           = Tabs.Visuals:Section("Chams", 2, 1)
        local miscellaneous   = Tabs.Visuals:Section("Miscellaneous", 2, 2)
        local world           = Tabs.Visuals:Section("World", 1, 3)
        local viewmodel   =     Tabs.Visuals:Section("Viewmodel", 2, 3)

        --// Player ESP
        players:Toggle({ Flag="esp.enabled", Text="Enable ESP" })
        players:Toggle({ Flag="esp.box", Text="Box" }):Color({ Flag="esp.box.color", Text="Box Color" })
        players:Toggle({ Flag="esp.fill", Text="Fill" }):Color({ Flag="esp.fill.color", Text="Fill Color" })
        players:Toggle({ Flag="esp.name", Text="Name" }):Color({ Flag="esp.name.color", Text="Name Color" })
        players:Toggle({ Flag="esp.health", Text="Health" }):Color({ Flag="esp.health.color", Text="Health Color" })
        players:Toggle({ Flag="esp.weapon", Text="Weapon" })
        players:Toggle({ Flag="esp.distance", Text="Distance" }):Color({ Flag="esp.distance.color", Text="Distance Color" })
        players:Toggle({ Flag="esp.skeleton", Text="Skeleton" }):Color({ Flag="esp.skeleton.color", Text="Skeleton Color" })
        players:Toggle({ Flag="esp.arrow", Text="Offscreen Arrow" }):Color({ Flag="esp.arrow.color", Text="Arrow Color" })

        --// Chams
        chams:Toggle({ Flag="chams.enabled", Text="Enabled" }):Color({ Flag="chams.color", Text="Chams Color" })
        chams:Toggle({ Flag="chams.outline", Text="Outline" })
            :Color({ Flag="chams.outline.color", Text="Outline Color" })
        chams:Slider({ Flag="chams.trans", Text="Transparency", Min=0, Max=1, Value=0.5, Increment = 0.1, Suffix="%" })


        chams:Dropdown({
            Flag="chams.method",
            Text="Cham Style",
            Values={'BoxHandleAdornment', 'Materialistic', 'Highlight', 'Glow', 'Wireframe', 'LayeredGlow', 'OutlineGlow', 'Drawing'},
            Selected="BoxHandleAdornment"
        })

        --// viewmodel
        local GunModulationConnection;

        viewmodel:Toggle({
            Flag = "gunchams.enabled",
            Text = "Gun Chams",
            Callback = function(Value: boolean): ()
                if Value then
                    GunModulationConnection = Nocturnal.ViewmodelPath.ChildAdded:Connect(function(Child: Instance?): ()
                        if not Child or not Child:IsA("Model") then return end;

                        for Index, Part in Child:GetDescendants() do
                            if Part:IsA("SurfaceAppearance") then Part:Destroy(); continue end;
                            if not Part:IsA("MeshPart") then continue end;

                            local PartName: string = Lower(Part.Name);

                            if PartName:find("glove") or PartName:find("arm") or PartName:find("sleeve") or PartName:find("joint") then
                                continue
                            end

                            local SurfaceAppearance: SurfaceAppearance? = Part:FindFirstChildOfClass("SurfaceAppearance")
                            if SurfaceAppearance then SurfaceAppearance:Destroy() end

                            Part.TextureID = Nocturnal.Textures[Library.Flags["gunchams.texture"]];
                            Part.Material = Enum.Material.Neon;
                            Part.Color = Library.Flags["gunchams.color"];
                            Part.Reflectance = (Library.Flags["gunchams.reflectance"]);

                            local Effect: string = Library.Flags["gunchams.style"];

                            Switch(Effect, {
                                Pulse = function()
                                    CreateThread(function()
                                        while Part and Part.Parent do
                                            local ToOpaque = TweenService:Create(Part, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Transparency = 0});
                                            local ToFaded = TweenService:Create(Part, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Transparency = 0.9});

                                            ToOpaque:Play(); ToOpaque.Completed:Wait();
                                            ToFaded:Play(); ToFaded.Completed:Wait();

                                            Wait(0.5);
                                        end
                                    end)
                                end,

                                Tween = function()
                                    Part.Material = Enum.Material.ForceField
                                    CreateThread(function()
                                        while Part and Part.Parent do
                                            local TweenInfoSettings = TweenInfo.new(1.3, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut);
                                            local TweenWhite = TweenService:Create(Part, TweenInfoSettings, {Color = Color3.fromRGB(255, 255, 255)});
                                            TweenWhite:Play(); TweenWhite.Completed:Wait();
                                            local TweenOriginal = TweenService:Create(Part, TweenInfoSettings, {Color = Library.Flags["gunchams.color"]});
                                            TweenOriginal:Play(); TweenOriginal.Completed:Wait();
                                        end
                                    end)
                                end,

                                ForceField = function()
                                    Part.Color = Library.Flags["gunchams.color"]
                                    Part.Material = Enum.Material.ForceField
                                end,

                                Flat = function()
                                    Part.Material = Enum.Material.Neon
                                end,

                                Glass = function()
                                    Part.Color = Library.Flags["gunchams.color"]
                                    Part.Material = Enum.Material.Glass
                                    Part.Transparency = 0.55
                                end,

                                Smooth = function()
                                    Part.Color = Library.Flags["gunchams.color"]
                                    Part.Material = Enum.Material.SmoothPlastic
                                end,

                                ForceOverlay = function()
                                    Part.Color = Library.Flags["gunchams.color"]
                                    Part.Material = Enum.Material.Plastic
                                    Part.Reflectance = 999999
                                end,

                                Water = function()
                                    Part.Material = Enum.Material.ForceField
                                    Part.Transparency = 0
                                    Part.Color = Library.Flags["gunchams.color"]

                                    local TextureIndex = 1
                                    local MAX_TEXTURES = 25 --// theres only lIke 25 textures in water folder so this is the limit. do not chang.e

                                    CreateThread(function()
                                        while Part and Part.Parent do
                                            Part.TextureID = "rbxasset://textures/water/normal_" .. StringFormat("%02d", TextureIndex) .. ".dds";
                                            TextureIndex = TextureIndex + 1;

                                            if TextureIndex > MAX_TEXTURES then
                                                TextureIndex = 1;
                                            end;

                                            Wait(0.08);
                                        end
                                    end)
                                end
                            });
                        end;
                    end)
                else
                    if GunModulationConnection then
                        GunModulationConnection:Disconnect()
                        GunModulationConnection = nil
                    end
                end
            end
        }):Color({ Flag="gunchams.color", Text="Gun Chams Color" })

        viewmodel:Slider({ Flag="gunchams.reflectance", Text="Cham Reflectance", Min=0, Max=1, Value=0, Increment=0.1, Suffix="%" })

        viewmodel:Dropdown({
            Flag="gunchams.style",
            Text="Cham Type",
            Values={"Pulse", "ForceField", "Flat", "Glass", "Tween", "Smooth", "ForceOverlay", "Water"},
            Selected="Pulse"
        });

        viewmodel:Dropdown({
            Flag="gunchams.texture",
            Text="Cham Texture",
            Values={"None", "Stars", "Hex"},
            Selected="None"
        });

        local c = {
            Nocturnal:Draw("Line", { ZIndex = 999 }),
            Nocturnal:Draw("Line", { ZIndex = 999 }),
            Nocturnal:Draw("Line", { ZIndex = 999 }),
            Nocturnal:Draw("Line", { ZIndex = 999 })
        }

        local CurrentPos = Vec2(0, 0)
        local CurrentGap = 0
        local PulseTime = 0
        local Rotation = 0


        local function RotatePoint(p, center, a): Vector2
            local s, cr = Sin(a), Cos(a);
            local dx, dy = p.X - center.X, p.Y - center.Y

            return Vec2(
                dx * cr - dy * s + center.X,
                dx * s + dy * cr + center.Y
            )
        end

        function EaseInOut(t: number): number
            return t * t * (3 - 2 * t); --// thx devforum
        end;

        function EaseInOutQuart(t: number): number
            if t < 0.5 then
                return 8 * t^4
            else
                local f = (t - 1)
                return 1 - 8 * f ^ 4
            end
        end

       function UpdateCrosshair(ScreenPos, Delta): ()
            local Center = Camera.ViewportSize / 2;
            local Len = Library.Flags["world.crosshair.length"] or 5;
            local BaseGap = Library.Flags["world.crosshair.gap"] or 5;
            local PulseAmount = 6;
            local PulseSpeed = 1.5; --// too lazy to make this configurable. fck fof.

            PulseTime = (PulseTime + Delta * PulseSpeed) % 2;
            local T = PulseTime;
            if T > 1 then T = 2 - T end;
			
			local EasingName = Library.Flags["misc.easingstyle"] or "QuartInOut";
			local EasingFunc = Nocturnal.EasingStyles[EasingName] or Nocturnal.EasingStyles.QuartInOut;
			local Eased = EasingFunc(T);

            local TargetGap;
            if Library.Flags["misc.effects"] then
                TargetGap = BaseGap + Eased * PulseAmount;
            else
                TargetGap = BaseGap;
            end;

            CurrentGap = CurrentGap + (TargetGap - CurrentGap) * 0.15;

            if ScreenPos then
                CurrentPos = CurrentPos:Lerp(ScreenPos, 0.2);
            else
                CurrentPos = CurrentPos:Lerp(Center, 0.2);
            end;

            if Library.Flags["world.crosshair.spin"] then
                Rotation = (Rotation + 0.02) % (Pi * 2);
            end;

            local Points = {
                { Vec2(CurrentPos.X - CurrentGap, CurrentPos.Y), Vec2(CurrentPos.X - CurrentGap - Len, CurrentPos.Y) },
                { Vec2(CurrentPos.X + CurrentGap, CurrentPos.Y), Vec2(CurrentPos.X + CurrentGap + Len, CurrentPos.Y) },
                { Vec2(CurrentPos.X, CurrentPos.Y - CurrentGap), Vec2(CurrentPos.X, CurrentPos.Y - CurrentGap - Len) },
                { Vec2(CurrentPos.X, CurrentPos.Y + CurrentGap), Vec2(CurrentPos.X, CurrentPos.Y + CurrentGap + Len) },
            }

            for Index = 1, 4 do
                local Line = c[Index];
                local From = RotatePoint(Points[Index][1], CurrentPos, Rotation);
                local To   = RotatePoint(Points[Index][2], CurrentPos, Rotation);

                Line.From = From;
                Line.To = To;
                Line.Thickness = Library.Flags["world.crosshair.width"] or 2;
                Line.Color = Library.Flags["world.crosshair.color"] or Color3New(1,1,1);
                Line.Visible = Library.Flags["world.crosshair.enabled"] == true;
            end
        end



        Insert(Nocturnal.Connections, RunService.RenderStepped:Connect(function(dt)
            if not Library.Flags["world.crosshair.enabled"] then return end;

            if Library.Flags["world.crosshair.follow"] and Nocturnal.ViewmodelPath and #Nocturnal.ViewmodelPath:GetChildren() > 0 then
                local barrel

                for _, d in Nocturnal.ViewmodelPath:GetDescendants() do
                    if d:IsA("BasePart") then
                        local n = d.Name:lower()
                        if n:find("barrel") or n:find("bolt") then
                            barrel = d
                            break
                        end
                    end
                end

                if barrel then
                    local RayParams = RaycastParams.new()
                    RayParams.FilterType = Enum.RaycastFilterType.Exclude
                    RayParams.FilterDescendantsInstances = { LocalPlayer.Character, Camera }

                    local Result = workspace:Raycast(
                        barrel.Position,
                        Camera.CFrame.LookVector * 500,
                        RayParams
                    )

                    if Result then
                        local Screen, OnScreen = Camera:WorldToViewportPoint(Result.Position);

                        if OnScreen then
                            UpdateCrosshair(Vec2(Screen.X, Screen.Y), dt);

                            return
                        end
                    end
                end
            end

            UpdateCrosshair(nil, dt);
        end))


        --// Misc
        miscellaneous:Toggle({
            Flag = "world.crosshair.enabled",
            Text = "Custom Crosshair",
            Callback = function(Enabled)
                if not Enabled then
                    for Index = 1, 4 do
                        if c[Index] then c[Index].Visible = false end
                    end
                end
            end
        }):Color({
            Flag = "world.crosshair.color",
            Text = "Crosshair Color"
        })

        miscellaneous:Toggle({
            Flag = "world.crosshair.follow",
            Text = "Follow Barrel"
        })

        miscellaneous:Toggle({
            Flag = "world.crosshair.spin",
            Text = "Spin",
            Callback = function(v)
                if not v then Rotation = 0 end;
            end
        })

        miscellaneous:Slider({
            Flag = "world.crosshair.gap",
            Text = "Gap",
            Min = 0,
            Max = 20,
            Value = 5
        })

        miscellaneous:Slider({
            Flag = "world.crosshair.width",
            Text = "Width",
            Min = 1,
            Max = 10,
            Value = 2
        })

        miscellaneous:Slider({
            Flag = "world.crosshair.length",
            Text = "Length",
            Min = 1,
            Max = 60,
            Value = 5
        })

        miscellaneous:Separator({Flag="goyimDestroyer69420", Text = "Sky"})

        local SkyValues: { string } = {};
		Insert(SkyValues, "None")

		for Index, Sky in Nocturnal.Skies do
			Insert(SkyValues, Index);
		end;

        miscellaneous:Toggle({Text = "Custom skybox", Flag = "world_skyboxtogg"})
        miscellaneous:Dropdown({
            Flag = "world_skyboxcustom",
            Text = "Skybox",
            Values = SkyValues,
            Selected = "None",
            Callback = function(Value): ()
                if not Value then return end
				if Value == 'None' then return end
				if Lighting:FindFirstChildOfClass("Sky") then Lighting:FindFirstChildOfClass("Sky"):Destroy() end;
				local Skybox = InstanceNew("Sky", Lighting);

				Skybox.SkyboxLf = Nocturnal.Skies[Value].SkyboxLf;
				Skybox.SkyboxBk = Nocturnal.Skies[Value].SkyboxBk;
				Skybox.SkyboxDn = Nocturnal.Skies[Value].SkyboxDn;
				Skybox.SkyboxFt = Nocturnal.Skies[Value].SkyboxFt;
				Skybox.SkyboxRt = Nocturnal.Skies[Value].SkyboxRt;
				Skybox.SkyboxUp = Nocturnal.Skies[Value].SkyboxUp;

				Skybox.Name = "skeibocks"
            end
        })

        local function GetOrCreateEffect(Name, ClassName): Instance
            local existing = Lighting:FindFirstChild(Name);

            if existing then
                if existing.ClassName ~= ClassName then
                    existing:Destroy();
                else
                    return existing;
                end;
            end;

            local inst = InstanceNew(ClassName);
            inst.Name = Name;
            inst.Parent = Lighting;

            return inst;
        end

        local function RemoveNamedEffect(Name): nil
            local inst = Lighting:FindFirstChild(Name)

            if inst then
                inst:Destroy();
            end
        end

        local function RestoreLighting(): nil
            Lighting:ClearAllChildren(); --// too lazy for ts
        end

        local function SaveCurrentLighting()
            --// Placeholder
        end

        local function MasterOK()
            return Library.Flags["world.amb"] == true
        end

        Spawn(
            function()
                local lastMaster = nil

                while Wait() do
                    local masterOn = Library.Flags["world.amb"] == true

					if not masterOn then
						continue
					end

                    if lastMaster == nil then
                        lastMaster = masterOn
                    elseif lastMaster and not masterOn then
                        RestoreLighting()
                    end
                    lastMaster = masterOn

                    if not masterOn then

                    end

                    if Library.Flags["world_ambc"] then
                        Lighting.Ambient = Library.Flags["world_ambc"]
                    end
                    if Library.Flags["world_csbc"] then
                        Lighting.ColorShift_Bottom = Library.Flags["world_csbc"]
                    end
                    if Library.Flags["world_cstc"] then
                        Lighting.ColorShift_Top = Library.Flags["world_cstc"]
                    end
                    if Library.Flags["world_eds"] then
                        Lighting.EnvironmentDiffuseScale = Library.Flags["world_eds"]
                    end
                    if Library.Flags["world_ess"] then
                        Lighting.EnvironmentSpecularScale = Library.Flags["world_ess"]
                    end
                    if Library.Flags["world_brightness2"] then
                        Lighting.Brightness = Library.Flags["world_brightness2"]
                    end
                    if Library.Flags["world_ct"] then
                        Lighting.ClockTime = Library.Flags["world_ct"]
                    end

                    --// Bloom
                    if Library.Flags["world_bloom"] then
                        local b = GetOrCreateEffect("nBloom", "BloomEffect")
                        b.Enabled = true
                        if Library.Flags["world_bi"] then
                            b.Intensity = Library.Flags["world_bi"]
                        end
                        if Library.Flags["world_bs"] then
                            b.Size = Library.Flags["world_bs"]
                        end
                        if Library.Flags["world_bt"] then
                            b.Threshold = Library.Flags["world_bt"]
                        end
                    else
                        local b = Lighting:FindFirstChild("nBloom")
                        if b then
                            b.Enabled = false
                        end
                    end

                    --// Sun Rays
                    if Library.Flags["world_sr"] then
                        local s = GetOrCreateEffect("nSunRays", "SunRaysEffect")
                        s.Enabled = true
                        if Library.Flags["world_sri"] then
                            s.Intensity = Library.Flags["world_sri"]
                        end
                        if Library.Flags["world_srs"] then
                            s.Spread = Library.Flags["world_srs"]
                        end
                    else
                        local s = Lighting:FindFirstChild("nSunRays")
                        if s then
                            s.Enabled = false
                        end
                    end

                    --// Color Correction
                    if Library.Flags["world_cc"] then
                        local c = GetOrCreateEffect("nColorCorrection", "ColorCorrectionEffect")
                        c.Enabled = true
                        if Library.Flags["world_ccc"] then
                            c.TintColor = Library.Flags["world_ccc"]
                        end
                    else
                        local c = Lighting:FindFirstChild("nColorCorrection")
                        if c then
                            c.Enabled = false
                        end
                    end
                end
            end
        )

        --// UI
        world:Toggle({Text = "Ambience", Flag = "world.amb"}):Color(
            {
                Text = "Ambient Color",
                Flag = "world_ambc",
                Color = Lighting.Ambient,
                Callback = function(c)
                    if MasterOK() then
                        Lighting.Ambient = c
                        SaveCurrentLighting()
                    end
                end
            }
        )

        world:Toggle({Text = "Colorshift Bottom", Flag = "world_csb"}):Color(
            {
                Text = "Bottom Color",
                Flag = "world_csbc",
                Color = Color3.new(0, 0, 0),
                Callback = function(c)
                    if MasterOK() then
                        Lighting.ColorShift_Bottom = c
                        SaveCurrentLighting()
                    end
                end
            }
        )

        world:Toggle({Text = "Colorshift Top", Flag = "world_cst"}):Color(
            {
                Text = "Top Color",
                Flag = "world_cstc",
                Color = Color3.new(0, 0, 0),
                Callback = function(c)
                    if MasterOK() then
                        Lighting.ColorShift_Top = c
                        SaveCurrentLighting()
                    end
                end
            }
        )

        world:Slider(
            {
                Text = "Environment Diffuse",
                Min = 0,
                Max = 1,
                Value = 0.35,
                Increment = 0.1,
                Flag = "world_eds",
                Callback = function(v)
                    if MasterOK() then
                        Lighting.EnvironmentDiffuseScale = v
                        SaveCurrentLighting()
                    end
                end
            }
        )

        world:Slider(
            {
                Text = "Environment Specular",
                Min = 0,
                Max = 1,
                Value = 1,
                Increment = 0.1,
                Flag = "world_ess",
                Callback = function(v)
                    if MasterOK() then
                        Lighting.EnvironmentSpecularScale = v
                        SaveCurrentLighting()
                    end
                end
            }
        )

        world:Slider(
            {
                Text = "Clock time",
                Min = 0,
                Max = 24,
                Value = Lighting.ClockTime,
                Increment = 0.1,
                Flag = "world_ct",
                Callback = function(v)
                    if MasterOK() then
                        Lighting.ClockTime = v
                        SaveCurrentLighting()
                    end
                end
            }
        )

        --// Bloom
        world:Toggle({Text = "Bloom", Flag = "world_bloom"})
        world:Slider({Text = "Bloom Intensity", Min = 0, Max = 10, Value = 4, Flag = "world_bi"})
        world:Slider({Text = "Bloom Size", Min = 0, Max = 50, Value = 15, Flag = "world_bs"})
        world:Slider({Text = "Bloom Threshold", Min = 0, Max = 1, Value = 0.15, Increment = 0.01, Flag = "world_bt"})

        --// Sun Rays
        world:Toggle({Text = "Sun Rays", Flag = "world_sr"})
        world:Slider({Text = "Intensity", Min = 0, Max = 1, Value = 0.01, Increment = 0.01, Flag = "world_sri"})
        world:Slider({Text = "Spread", Min = 0, Max = 1, Value = 0.1, Increment = 0.1, Flag = "world_srs"})

        --// Color Correction
        world:Toggle({Text = "Color correction", Flag = "world_cc"}):Color(
            {Text = "Correction Color", Flag = "world_ccc", Color = Color3.fromRGB(255, 85, 255)}
        )

    end

	--// Misc
	do
        local movement = Tabs.Misc:Section("Movement", 1, 1)
        local weapon   = Tabs.Misc:Section("Weapon", 2, 1)
        local network  = Tabs.Misc:Section("Network", 1, 2)
        local other    = Tabs.Misc:Section("Other", 2, 2)

        --// connections
        local BunnyConnection;

        movement:Toggle({ Flag="move.speed", Text="Speed" })

		Insert(Nocturnal.Connections, RunService.RenderStepped:Connect(function(DeltaTime: number): ()
			if not Library.Flags["move.speed"] then return end;
			if not Nocturnal:Alive() then return end;

			local Player: Player = PlayerService.LocalPlayer;
			local Character: Model? = Player.Character;
			if not Character then return end;

			local Humanoid: Humanoid? = Character:FindFirstChildOfClass("Humanoid");
			if not Humanoid then return end;

			local SpeedType: string = Library.Flags["move.speedtype"] or "WalkSpeed";
			local SpeedAmount: number = Library.Flags["move.speedamount"] or 16;

			if SpeedType == "WalkSpeed" then
				Humanoid.WalkSpeed = SpeedAmount;
			elseif SpeedType == "MoveDirection" then
				local Root: BasePart = Character.PrimaryPart;
				if Root then
					local MoveDir: Vector3 = Humanoid.MoveDirection;
					Root.CFrame += CFrameNew(MoveDir * SpeedAmount * DeltaTime).Position;
				end;
			end;
		end));

        movement:Toggle({
            Flag = "move.bhop",
            Text = "Bunny Hop",
			Risky = true,
            Callback = function(Value: boolean): ()
                if Value then
                    BunnyConnection = RunService.RenderStepped:Connect(function(DeltaTime: number): ()
                        if not Library.Flags["move.bhop"] then return end;
                        if not Nocturnal:Alive() then return end;

                        local IsJumping: boolean = InputService:IsKeyDown(Enum.KeyCode.Space);

                        if IsJumping then
                            if not BodyVelocity then
                                BodyVelocity = InstanceNew("BodyVelocity")
                                BodyVelocity.Name = "שְׁמַע יִשְׂרָאֵל יְהוָה אֱלֹהֵינוּ יְהוָה אֶחָד"
                                BodyVelocity.MaxForce = Vec3(Huge, 0, Huge)
                                BodyVelocity.Parent = LocalPlayer.Character.PrimaryPart
                            end

                            local AddAngle: number = 0;

                            local W: boolean = InputService:IsKeyDown(Enum.KeyCode.W);
                            local A: boolean = InputService:IsKeyDown(Enum.KeyCode.A);
                            local S: boolean = InputService:IsKeyDown(Enum.KeyCode.S);
                            local D: boolean = InputService:IsKeyDown(Enum.KeyCode.D);

                            if A and W then 
                                AddAngle = 45;
                            elseif D and W then 
                                AddAngle = 315;
                            elseif D and S then 
                                AddAngle = 225;
                            elseif A and S then 
                                AddAngle = 145;
                            elseif A then 
                                AddAngle = 90;
                            elseif S then 
                                AddAngle = 180;
                            elseif D then 
                                AddAngle = 270;
                            end;

                            local CameraRotation: CFrame = Nocturnal:RotationY(workspace.CurrentCamera.CFrame);
                            local MoveRotation: CFrame = CameraRotation * CFrameAngles(0, Rad(AddAngle), 0);

                            BodyVelocity.Velocity = Vec3(MoveRotation.LookVector.X, 0, MoveRotation.LookVector.Z) * (Library.Flags["move.speedamount"] * 2);
                            LocalPlayer.Character.Humanoid.Jump = true;
                        else
                            if BodyVelocity then
                                BodyVelocity:Destroy()
                                BodyVelocity = nil
                            end
                        end
                    end)

                    Insert(Nocturnal.Connections, BunnyConnection);
                else
                    if BunnyConnection then
                        BunnyConnection:Disconnect()
                        BunnyConnection = nil
                    end

                    if BodyVelocity then
                        BodyVelocity:Destroy()
                        BodyVelocity = nil
                    end
                end
            end
        })

        local function DoCollision(Character: Model, CanCollide: boolean)
            for _, descendant in Character:GetDescendants() do
                if descendant:IsA("BasePart") and not (descendant.Parent:IsA("Accessory")) then
                    descendant.CanCollide = CanCollide
                end
            end
        end

        movement:Toggle({
            Flag = "move.noclip",
            Text = "Noclip",
            Callback = function(Enabled: boolean)
                local Character = LocalPlayer.Character

                if Nocturnal:Alive() and Character then
                    DoCollision(Character, not Enabled);
                end
            end
        }):Bind({
            Flag = "move.nokey",
            Text = "Noclip",
            Bind = "NONE",
            Mode = "toggle",
            Callback = function(Enabled: boolean)
                local Character = LocalPlayer.Character
                if Nocturnal:Alive() and Character then
                    DoCollision(Character, not Enabled);
                end
            end
        })

        movement:Toggle({ Flag="move.edgejump", Text="Edge Jump" }):Bind({
            Flag = "move.jumpkey",
            Text = "Edgejump",
            Bind = "NONE",
            Mode = "toggle"
        })

		movement:Toggle({ Flag="move.jumpbug", Text="Jump Bug" }):Bind({
            Flag = "move.jumpkey",
            Text = "Jump Bug",
            Bind = "NONE",
            Mode = "toggle"
        })

		Insert(Nocturnal.Connections, RunService.RenderStepped:Connect(function(DeltaTime: number): ()
			if not Library.Flags["move.jumpbug"] or not Library.Flags["move.jumpkey"] then return end;
            if not Nocturnal:Alive() then return end;

            local Character: Model? = LocalPlayer.Character
            if not Character then return end

            local Humanoid: Humanoid? = Character:FindFirstChildOfClass("Humanoid")
            local Root: BasePart? = Character.PrimaryPart
            if not Humanoid or not Root then return end

            local CurrentVelocity: Vector3 = Root.Velocity

            if CurrentVelocity.Y < -2 then
                local RayResult: RaycastResult? = Nocturnal:Raycast(Root.Position, Vec3(0, -3, 0));

                if RayResult then
                    Root.CFrame = LastPosition;
                    Root.Velocity += Vec3(0, Humanoid.JumpPower, 0);
                end;
            end;

            LastPosition = Root.CFrame;
        end))

		Insert(Nocturnal.Connections, RunService.Heartbeat:Connect(function(DeltaTime: number)
			if not Library.Flags["move.edgejump"] or not Library.Flags["move.jumpkey"] then return end;
			if not Nocturnal:Alive() then return end;

			local Player: Player = PlayerService.LocalPlayer;
			local Character: Model? = Player.Character;
			if not Character then return end;

			local Root: BasePart = Character.PrimaryPart;
			if not Root then return end;

			local Velocity: Vector3 = Root.Velocity;

			-- Already moving up s0 dont do ts
			if Velocity.Y > 1 then return end;

			local Forward: Vector3 = Vec3(Velocity.X, 0, Velocity.Z);
			if Forward.Magnitude < 1 then return end;
			Forward = Forward.Unit;

			local FeetHit: RaycastResult? = Nocturnal:Raycast(Root.Position, Vec3(0, -3.1, 0));
			if not FeetHit then return end;

			local AheadPosition: Vector3 = Root.Position + Forward * 2;
			local AheadHit: RaycastResult? = Nocturnal:Raycast(AheadPosition, Vec3(0, -3.1, 0));

			if not AheadHit then
				if rawequal(Library.Flags["move.edgetype"], "Velocity") then
					Root.Velocity += Vec3(0, Character.Humanoid.JumpPower, 0) or Vec3(0, 50, 0);
				else
					Character:FindFirstChildOfClass("Humanoid").Jump = true;
				end;
			end;
		end))

        movement:Toggle({ Flag="move.targetstrafe", Text="Target Strafe" }):Bind({ Flag="move.strafe.key", Text="Targetstrafe", Bind = 'NONE', Mode="toggle" })

		movement:Dropdown({
            Flag = "net.strafetype",
            Text = "Targetstrafe type",
            Values = { "Circle", "Ontop", "Underground" },
            Selected = "Circle",
        })

		movement:Dropdown({
			Flag = "move.speedtype",
			Text = "Speed Type",
			Values = { "WalkSpeed", "MoveDirection" },
			Selected = "WalkSpeed",
		})

		movement:Dropdown({
            Flag = "move.edgetype",
            Text = "Edgejump type",
            Values = { "Velocity", "Humanoid" },
            Selected = "Velocity",
        })


		Insert(Nocturnal.Connections, RunService.RenderStepped:Connect(function(DeltaTime: number)
			if not Nocturnal.LoadComplete then return end;
			if not Library.Flags["move.targetstrafe"] or not Library.Flags["move.strafe.key"] then return end;

			local Character: Model? = LocalPlayer.Character;
			if not Character then return end;

			local Root: BasePart? = Character:FindFirstChild("HumanoidRootPart") :: BasePart?;
			if not Root then return end;

			local Radius: number = Library.Flags["move.strafedistance"];
			local StrafeMode: string = Library.Flags["net.strafetype"];

			local TargetRoot: BasePart? = Nocturnal:GetStrafeTarget(Library.Flags["move.strafedistance"] * 2);
			if not TargetRoot then return end;

			local TargetCFrame: CFrame? = Nocturnal:GetStrafeCFrame(
				StrafeMode,
				Root,
				TargetRoot,
				Radius,
				DeltaTime
			);

			if TargetCFrame then
				Root.CFrame = TargetCFrame;
			end;
		end))



		movement:Slider({ Flag="move.strafespeed", Text="Strafe Speed", Min=1, Max=10, Value=5})

        movement:Slider({ Flag="move.strafedistance", Text="Strafe Distance", Min=1, Max=100, Value=16})

        movement:Slider({ Flag="move.speedamount", Text="Speed Amount", Min=1, Max=160, Value=16})


		Nocturnal.OriginalValues = {};

		weapon:Toggle({
			Flag = "weapon.firerate",
			Text = "Fire Rate",
			Risky = true,
			Callback = function(State: boolean)
				for _, Obj in ReplicatedStorage:GetDescendants() do
					if Obj:IsA("NumberValue") and Find(Lower(Obj.Name), "firerate") then
						CreateThread(function()
							if not Nocturnal.OriginalValues[Obj] then Nocturnal.OriginalValues[Obj] = Obj.Value end

							if State then
								Obj.Value = 0.03
							else
								Obj.Value = Nocturnal.OriginalValues[Obj]
							end
						end)
					end
				end
			end
		})

		weapon:Toggle({
			Flag = "weapon.norecoil",
			Text = "No Recoil",
			Risky = true,
			Callback = function(State: boolean)
				for _, Obj in ReplicatedStorage:GetDescendants() do
					if Obj:IsA("NumberValue") and Find(Lower(Obj.Name), "recoil") then
						CreateThread(function()
							if not Nocturnal.OriginalValues[Obj] then Nocturnal.OriginalValues[Obj] = Obj.Value end

							if State then
								Obj.Value = 0.03
							else
								Obj.Value = Nocturnal.OriginalValues[Obj]
							end
						end)
					end
				end
			end
		})

		weapon:Toggle({
			Flag = "weapon.nospread",
			Text = "No Spread",
			Risky = true,
			Callback = function(State: boolean)
				for _, Obj in ReplicatedStorage:GetDescendants() do
					if Obj:IsA("NumberValue") and Find(Lower(Obj.Name), "spread") then
						CreateThread(function()
							if not Nocturnal.OriginalValues[Obj] then Nocturnal.OriginalValues[Obj] = Obj.Value end

							if State then
								Obj.Value = 0.03
							else
								Obj.Value = Nocturnal.OriginalValues[Obj]
							end
						end)
					end
				end
			end
		})

		weapon:Toggle({
			Flag = "weapon.instant",
			Text = "Instant Reload",
			Risky = true,
			Callback = function(State: boolean)
				for _, Obj in ReplicatedStorage:GetDescendants() do
					if Obj:IsA("NumberValue") and Find(Lower(Obj.Name), "reloadtime") then
						CreateThread(function()
							if not Nocturnal.OriginalValues[Obj] then Nocturnal.OriginalValues[Obj] = Obj.Value end

							if State then
								Obj.Value = 0.03
							else
								Obj.Value = Nocturnal.OriginalValues[Obj]
							end
						end)
					end
				end
			end
		})



        network:Toggle({ Flag="net.fakelag", Text="Fakelag" }):Bind({ Flag="net.lag.key", Text="Fakelag", Bind = 'NONE', Mode="toggle" })
        
        network:Toggle({ Flag="net.fakelag.vis", Text="Visualize lag" }):Color(
            {Text = "Visualization Color", Flag = "net.fakelag.color", Color = Color3.fromRGB(255, 85, 255)}
        )

        network:Slider({ Flag="net.lagticks", Text="Lag ticks", Min=1, Max=20, Value=3})

        network:Dropdown({
            Flag = "net.lagtype",
            Text = "Fakelag type",
            Values = {"Instance", "Prevent Replication", "Physics"},
            Selected = "Instance",
            Callback = function(Value): ()
                
            end
        })

        network:Separator({Flag = "goydestroy50", Text = "Desync"})

        local desyncConn;
        network:Toggle({ Flag="net.desync", Text="Disable netsync" }):Bind({ Flag="net.dsync.key", Text="Desync", Bind = 'NONE', Mode="toggle" })
        network:Slider({ Flag="net.syncticks", Text="Desync ticks", Min=1, Max=5000, Value=3})

        CreateThread(function()
            Insert(Nocturnal.Connections, RunService.RenderStepped:Connect(function(DeltaTime: number)
                if Library.Flags["net.desync"] or Library.Flags["net.dsync.key"] then
                    if Nocturnal:Alive() then
                       	Spawn(function()
                            if LocalPlayer.Character and not workspace:FindFirstChildOfClass("Seat") then
                                local _c = LocalPlayer.Character
                                if not (_c and _c:FindFirstChild("HumanoidRootPart")) then

                                else
                                    if true then
                                        local cee = InstanceNew("Seat")
                                        cee.Name = "tRGWJUI%ERjtguihe85ur"
                                        cee.Parent = workspace
                                        cee.Size = Vec3(4, 1, 1)
                                        cee.CanCollide = false
                                        cee.CanQuery = false
                                        --cee.CollisionGroup = "Smoke"

                                        local awe = InstanceNew("Weld", cee)
                                        local bb = InstanceNew("Weld")
                                        bb.Name = "geriuzh5eruzhge5"
                                        bb.Parent = _c.HumanoidRootPart

                                        cee.CFrame = CFrameNew(_c.HumanoidRootPart.Position)
                                        cee.CFrame = cee.CFrame
                                        awe.Part0 = _c.HumanoidRootPart
                                        awe.Part1 = cee
                                        _c.HumanoidRootPart.CFrame = CFrameNew(cee.Position)
                                        bb.Part0 = _c.HumanoidRootPart
                                        bb.Part1 = cee
                                        cee.Transparency = 1
                                    end

                                    if Library.Flags["net.fakelag.vis"] then
                                        local sf = workspace
                                        if not sf:FindFirstChild("FakeChar") then
                                            local i = InstanceNew("Model", sf)
                                            i.Name = "FakeChar"
                                            for _, v in _c:GetDescendants() do
                                                if v:IsA("BasePart") and v.Transparency ~= 1 then
                                                    local a = v:Clone()
                                                    a.CanCollide = false
                                                    a.Parent = i
                                                    v.CanQuery = false
                                                    a.Anchored = true
                                                    a.Color = Library.Flags["net.fakelag.color"]
                                                    a.Material = "ForceField"
                                                    a.Transparency = 0.6
                                                    a.Reflectance = 0
													a.CollisionGroup = "Smoke";

                                                    if a:IsA("MeshPart") then
                                                        a.TextureID = ""
                                                    end

                                                    for _, c in a:GetChildren() do
                                                        if not c:IsA("SpecialMesh") then
                                                            c:Destroy()
                                                        else
                                                            c.TextureId = ""
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end

                                    Delay(Library.Flags["net.syncticks"] / 10000, function()
                                        local isThere = workspace:FindFirstChildOfClass("Seat")

                                        if isThere then
                                            isThere:Destroy()
                                        end

                                        local sf = workspace

                                        for _, v in sf:GetChildren() do
                                            if v:IsA("Seat") or v.Name == "FakeChar" then
                                                v:Destroy()
                                            end
                                        end

                                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                            local h = LocalPlayer.Character.HumanoidRootPart
                                            local existing = h:FindFirstChild("geriuzh5eruzhge5")
                                            if existing then
                                                existing:Destroy()
                                            end
                                        end
                                    end)
                                end
                            end
                        end)
                    end
                end 
            end))
        end)

        local LagTick = 0;
		local lagconn;

        CreateThread(function()
			local Sleeping: boolean = false;

			Insert(Nocturnal.Connections, RunService.PostSimulation:Connect(function()
				if Nocturnal.LoadComplete and Nocturnal:Alive() and (Library.Flags["net.lag.key"] == true or Library.Flags["net.fakelag"] == true) and Library.Flags["net.lagtype"] == "Physics" then
					Sleeping = not Sleeping;
					sethiddenproperty(LocalPlayer.Character.HumanoidRootPart, "NetworkIsSleeping", Sleeping);
				end;
			end));
		end);

        CreateThread(function()
			while Wait(1/20) do
				LagTick = Clamp(LagTick + 1, 0, Library.Flags["net.lagticks"] or 5)
                if Nocturnal.LoadComplete 
                and Nocturnal:Alive() 
                and (Library.Flags["net.fakelag"] == true or Library.Flags["net.lag.key"] == true)
                and Library.Flags["net.lagtype"] == "Instance" then
					if rawequal(LagTick, (Random(1, Library.Flags["net.lagticks"]))) then
						Services.NetworkClient:SetOutgoingKBPSLimit(9e9)
						Nocturnal.GetSecuredFolder():ClearAllChildren()
						LagTick = 0

						if Library.Flags["net.fakelag.vis"] then
							local i = InstanceNew("Model", Nocturnal:GetSecuredFolder())
							i.Name = "FakeChar2"

							for _, v: BasePart in LocalPlayer.Character:GetDescendants() do
								if v:IsA("BasePart") and v.Transparency ~= 1 then
									local a = v:Clone()
									a.CanCollide = false
									a.Parent = i
									v.CanQuery = false
									a.Anchored = true
									a.Color = Library.Flags["net.fakelag.color"]
									a.Material = "ForceField"
									a.Transparency = 0.6
									a.Reflectance = 0
									a.CollisionGroup = "Smoke";


									if a:IsA("MeshPart") then
										a.TextureID = ""
									end

									for _, c in a:GetChildren() do
										if not c:IsA("SpecialMesh") then
										    c:Destroy()
										else
											c.TextureId = ""
										end
									end
								end
							end
						end
					else
						if (Library.Flags["net.fakelag"] == true or Library.Flags["net.lag.key"] == true) then
							Services.NetworkClient:SetOutgoingKBPSLimit(1);
						end
					end
				else
					Nocturnal.GetSecuredFolder():ClearAllChildren();
					Services.NetworkClient:SetOutgoingKBPSLimit(9e9);
				end
			end
		end)

        other:Toggle({ Flag="misc.thirdperson", Text="Third Person" }):Bind({ Flag="misc.thirdperson.key", Text="Third Person", Bind = 'NONE', Mode="toggle" })
        other:Toggle({ Flag="misc.fly", Text="Flight" }):Bind({ Flag="misc.flight.key", Text="Flight", Bind = 'NONE', Mode="toggle" })
		other:Slider({ Flag="misc.flyspeed", Text="Flight Speed", Min=1, Max=350, Value=60, Increment = 1 })

		--// While I did think about using the bunnyhop connection for this, I realized they were overlapping and that it's best to seperate them
		do
			Insert(Nocturnal.Connections, InputService.InputBegan:Connect(function(Input: InputObject, GameProcessed: boolean): ()
				if GameProcessed then
					return;
				end;

				if Input.KeyCode == Enum.KeyCode.W then
					Nocturnal.MoveInput.Forward = 1;
				elseif Input.KeyCode == Enum.KeyCode.S then
					Nocturnal.MoveInput.Forward = -1;
				elseif Input.KeyCode == Enum.KeyCode.A then
					Nocturnal.MoveInput.Right = -1;
				elseif Input.KeyCode == Enum.KeyCode.D then
					Nocturnal.MoveInput.Right = 1;
				elseif Input.KeyCode == Enum.KeyCode.Space then
					Nocturnal.MoveInput.Up = 1;
				elseif Input.KeyCode == Enum.KeyCode.LeftControl then
					Nocturnal.MoveInput.Up = -1;
				end;
			end));

			Insert(Nocturnal.Connections, InputService.InputEnded:Connect(function(Input: InputObject): ()
				if Input.KeyCode == Enum.KeyCode.W or Input.KeyCode == Enum.KeyCode.S then
					Nocturnal.MoveInput.Forward = 0;
				elseif Input.KeyCode == Enum.KeyCode.A or Input.KeyCode == Enum.KeyCode.D then
					Nocturnal.MoveInput.Right = 0;
				elseif Input.KeyCode == Enum.KeyCode.Space or Input.KeyCode == Enum.KeyCode.LeftControl then
					Nocturnal.MoveInput.Up = 0;
				end;
			end));

			Insert(Nocturnal.Connections, RunService.RenderStepped:Connect(function(DeltaTime: number): ()
				if not Library.Flags["misc.fly"] or not Library.Flags["misc.flight.key"] then
					return;
				end;

				if not Nocturnal:Alive() then
					return;
				end;

				local Root: BasePart? = LocalPlayer.Character.PrimaryPart

				local MoveDirection: Vector3 =
					Camera.CFrame.LookVector * Nocturnal.MoveInput.Forward +
					Camera.CFrame.RightVector * Nocturnal.MoveInput.Right +
					Vec3(0, Nocturnal.MoveInput.Up, 0);

				if MoveDirection.Magnitude > 0 then
					MoveDirection = MoveDirection.Unit;
				end;

				Root.Velocity = MoveDirection * Library.Flags["misc.flyspeed"];

				if MoveDirection.Magnitude > 0 then
					--// i dont like this
					Root.CFrame = CFrameLookAt(Root.Position, Root.Position + MoveDirection);
				end;
			end));
		end;

		do
			RunService:BindToRenderStep("Thirdperson", Enum.RenderPriority.Camera.Value + 1, function()
				if not Nocturnal.LoadComplete then return end;

				if Library.Flags["misc.ratio"] then
					Camera.CFrame *= CFrameNew(0, 0, 0, 1, 0, 0, 0, Library.Flags["misc.ratioEffect"], 0, 0, 0, 1);
				end
				
				if Library.Flags["misc.thirdperson"] or Library.Flags["misc.thirdperson.key"] then
					Camera.CFrame += (Camera.CFrame.LookVector * -10);
				end;
			end);
		end;

        other:Toggle({ Flag="misc.ratio", Text="Aspect Ratio" })
		other:Slider({ Flag="misc.ratioEffect", Text="Ratio", Min=0.1, Max=1, Value=0.5, Increment = 0.1 })
        other:Toggle({ Flag="misc.effects", Text="Enable fluent effects" })
		other:Dropdown({
            Flag = "misc.easingstyle",
            Text = "Crosshair easing",
            Values = Nocturnal.EasingStylesList,
            Selected = "QuartInOut",
            Callback = function(Value): ()
                
            end
        })
	end
end

--// fov circle
do
    Nocturnal.Circle = Nocturnal:Draw("Circle", {
        Transparency = 1, 
        Thickness = 1, 
        NumSides = 360, 
        Radius = 50, 
        Position = Vec2(0, 0),
        Visible = false,
        Outline = true,
        Color = Color3FromRGB(255, 255, 255)
    })

	Nocturnal.DeadzoneCircle = Nocturnal:Draw("Circle", {
        Transparency = 1,
        Thickness = 1,
        NumSides = 360,
        Radius = 5,
        Position = Vec2(0, 0),
        Visible = false,
        Outline = true,
        Color = Color3FromRGB(255, 80, 80)
    })
end;

--// legitbot
do
    Insert(Nocturnal.Connections, RunService.RenderStepped:Connect(function(DeltaTime: number)
        local mousePos = InputService:GetMouseLocation();
        Nocturnal.Circle.Position = mousePos;
        Nocturnal.Circle.Visible = Library.Flags["world.fov"];

        local dz = Library.Flags["legit.deadzone"] or 0;
        Nocturnal.DeadzoneCircle.Position = mousePos;
        Nocturnal.DeadzoneCircle.Radius = dz;
        Nocturnal.DeadzoneCircle.Visible =
            dz > 0 and Library.Flags["world.fov"];

        if Library.Flags["legit.enabled"] and Library.Flags["legit.key"] then
            local targetPlayer, targetPart = Nocturnal:FindBestTarget();

            if targetPlayer and targetPart then
                local camMethod = Library.Flags["legit.cammethod"] or "Mouse";

                if camMethod == "Mouse" then
                    local pos, onScreen = Camera:WorldToScreenPoint(targetPart.Position);

                    if onScreen then
                        local delta = Vec2(pos.X - Mouse.X, pos.Y - Mouse.Y);
                        local dist = delta.Magnitude;

                        local deadzone = Library.Flags["legit.deadzone"] or 0;
                        local dzType = Library.Flags["legit.deadzone.type"] or "Hard";

                        if deadzone > 0 then
                            if dzType == "Hard" then
                                if dist <= deadzone then
                                    return;
                                end;
                            else
                                if dist <= deadzone then
                                    return;
                                end;

                                local scale = Clamp((dist - deadzone) / deadzone, 0, 1);
                                delta = delta * scale;
                            end;
                        end;

                        local magnitude = delta;
                        local smooth = Max(1, Library.Flags["legit.smooth"]);

                        local humanizerEnabled = Library.Flags["legit.humanizer"];
                        if humanizerEnabled and Nocturnal.Humanizer.Sample then
                            local Delta = 25 / dist;

                            if Delta <= 0.8 then
                                local CurrentTick = Tick();
                                local sample = Nocturnal.Humanizer.Sample[Nocturnal.Humanizer.Index];
                                magnitude = magnitude + sample * Delta;

                                if (CurrentTick - Nocturnal.Humanizer.Tick) > 0.1 then
                                    Nocturnal.Humanizer.Tick = CurrentTick;
                                    Nocturnal.Humanizer.Index = Nocturnal.Humanizer.Index + 1;

                                    if Nocturnal.Humanizer.Index > #Nocturnal.Humanizer.Sample then
                                        Nocturnal.Humanizer.Index = 1;
                                    end;
                                end;
                            end;
                        end;

                        if Library.Flags["legit.smooth"] == 0 then
                            mousemoverel(magnitude.x, magnitude.y);
                        else
                            local method = Library.Flags["legit.meth"];

                            if method == "Linear" then
                                mousemoverel(magnitude.x / smooth, magnitude.y / smooth);
                            elseif method == "Exponential" then
                                local factor = 1 - Exp(-smooth * DeltaTime);
                                mousemoverel(magnitude.x * factor, magnitude.y * factor);
                            elseif method == "EaseInOut" then
                                local factor = Sin((1 / smooth) * (Pi / 2));
                                mousemoverel(magnitude.x * factor, magnitude.y * factor);
                            elseif method == "WeightedAverage" then
                                if not Nocturnal.lastMove then
                                    Nocturnal.lastMove = Vec2(0,0);
                                end;

                                local move = (magnitude / smooth + Nocturnal.lastMove) / 2;
                                mousemoverel(move.x, move.y);
                                Nocturnal.lastMove = move;
                            end;
                        end;
                    end;

                elseif camMethod == "Camera" then
                    local camPos = Camera.CFrame.Position;
                    local targetCF = CFrameNew(camPos, targetPart.Position);

                    local smooth = Max(1, Library.Flags["legit.smooth"]);
                    local method = Library.Flags["legit.meth"];

                    local alpha = 1;

                    if Library.Flags["legit.smooth"] ~= 0 then
                        if method == "Linear" then
                            alpha = 1 / smooth;
                        elseif method == "Exponential" then
                            alpha = 1 - Exp(-smooth * DeltaTime);
                        elseif method == "EaseInOut" then
                            alpha = Sin((1 / smooth) * (Pi / 2));
                        elseif method == "WeightedAverage" then
                            if not Nocturnal.lastCam then
                                Nocturnal.lastCam = Camera.CFrame;
                            end;

                            targetCF = Nocturnal.lastCam:Lerp(targetCF, 0.5);
                            Nocturnal.lastCam = targetCF;
                            alpha = 1;
                        end;
                    end;

                    Camera.CFrame = Camera.CFrame:Lerp(targetCF, alpha);
                end;
            end;
        end;
    end));
end;

--// Chams
do
    local LastEnabled = false

    function RemoveAdorns(Part): ()
        if not Part then return end;
        local Children = Part:GetChildren();

        for i = 1, #Children do
            local Obj = Children[i]
            if Obj.Name == "Chams" or Obj.Name == "Glow" then
                Obj:Destroy()
            end
        end
    end

    function RemoveCharChams(Char): ()
        if not Char then return end;
        local Children = Char:GetChildren();

        for i = 1, #Children do
            local P = Children[i]
            if P:IsA("BasePart") then
                RemoveAdorns(P)
            end
        end
    end

    function CreateAdornment(Part, Type, Color, Trans, ZIndex, SizeOffset, Extra)
        Extra = Extra or {} -- yo why tf wat the fuckz

        local Ad
        if Type == "Cylinder" then
            Ad = InstanceNew("CylinderHandleAdornment")
            Ad.Height = Part.Size.Y + (Extra.HeightOffset or 0)
            Ad.Radius = (Part.Size.X * 0.5) + (Extra.RadiusOffset or 0)
            Ad.CFrame = CFrameNew(VecEmpty, Vec3(0, 1, 0))

        elseif Type == "Box" then
            Ad = InstanceNew("BoxHandleAdornment")
            Ad.Size = Part.Size + (SizeOffset or VecEmpty)

        elseif Type == "Wireframe" then
            Ad = InstanceNew("WireframeHandleAdornment")
            Ad.Adornee = Part
            Ad.AlwaysOnTop = true
            Ad.Thickness = Extra.Thickness or 1
            Ad.ZIndex = ZIndex or 1
            Ad.Color3 = Color
            Ad.Parent = Part
            return Ad
        else
            error("err cus: "..tostring(Type))
        end

        Ad.Name = "Chams"
        Ad.AlwaysOnTop = true
        Ad.ZIndex = ZIndex
        Ad.Adornee = Part
        Ad.Color3 = Color
        Ad.Transparency = Trans or 0
        if Extra.Shading then
            Ad.Shading = Extra.Shading
        end

        Ad.Parent = Part

        return Ad;
    end


    CreateThread(function()
        while Wait(2) do
            local Enabled = Library.Flags["chams.enabled"]

            if not Enabled and LastEnabled then
                Nocturnal:ClearAllChams()
            end

            LastEnabled = Enabled

            if not Enabled then continue end

            local ChamsType = Library.Flags["chams.method"]
            local MainColor = Library.Flags["chams.color"]
            local GlowColor = Library.Flags["chams.outline.color"]
            local Trans = Library.Flags["chams.trans"]

			if ChamsType == 'Drawing' then
				Nocturnal:ClearAllChams();
			end

        	for _, Entry in Nocturnal.PlayerCache._cache do
                if not Entry.Alive then
					local Char = Entry.PlayerInstance.Character
					if Char then
						RemoveCharChams(Char)
					end

					continue;
				end

				local BodyParts = Entry.BodyParts

				for Name, Part in BodyParts do
					if not Part or not Part:IsA("BasePart") or Part.Transparency >= 1 then continue end;

					RemoveAdorns(Part);

					if ChamsType == "Materialistic" then
						local SA = Part:FindFirstChildOfClass("SurfaceAppearance")
						if SA then SA:Destroy() end

						if Part.Name:find("Sleeve") then
							for _, D in Part:GetChildren() do
								if D:IsA("Decal") or D:IsA("Texture") then
									D:Destroy()
								end
							end
						end

						Part.Material = Enum.Material.ForceField
						Part.Color = MainColor

					elseif ChamsType == "BoxHandleAdornment"
						or ChamsType == "OutlineGlow"
						or ChamsType == "Glow"
						or ChamsType == "LayeredGlow" then

						local Ad, Glow
						local IsHead = Name == "Head" or Name == "FakeHead"

						if ChamsType == "Glow" or ChamsType == "LayeredGlow" then
							local BaseColor =
								(ChamsType == "Glow")
								and Color3New(MainColor.R * 5, MainColor.G * 5, MainColor.B * 5)
								or  Color3New(GlowColor.R * 5, GlowColor.G * 5, GlowColor.B * 5)

							Ad = CreateAdornment(
								Part,
								IsHead and "Cylinder" or "Box",
								BaseColor,
								-1,
								IsHead and 10 or 9,
								Vec3(0.03, 0.03, 0.03),
								{ Shading = Enum.AdornShading.XRayShaded }
							)

							if ChamsType == "LayeredGlow" then
								CreateAdornment(
									Part,
									IsHead and "Cylinder" or "Box",
									MainColor,
									Trans,
									10,
									Vec3(0.02, 0.02, 0.02)
								)
							end
						else
							if IsHead then
								Ad = CreateAdornment(
									Part,
									"Cylinder",
									MainColor,
									Trans,
									4,
									nil,
									{ HeightOffset = 0.3, RadiusOffset = 0.2 }
								)

								if Library.Flags["chams.outline"] then
									Glow = Ad:Clone()
									Glow.Name = "Glow"
									Glow.ZIndex = 3
									Glow.Color3 = GlowColor
									Glow.Height += 0.13
									Glow.Radius += 0.13
									Glow.Parent = Part
								end
							else
								Ad = CreateAdornment(
									Part,
									"Box",
									MainColor,
									Trans,
									4,
									Vec3(0.02, 0.02, 0.02)
								)

								if Library.Flags["chams.outline"] then
									Glow = Ad:Clone()
									Glow.Name = "Glow"
									Glow.ZIndex = 3
									Glow.Color3 = GlowColor
									Glow.Size += Vec3(0.13, 0.13, 0.13)
									Glow.Parent = Part
								end
							end
						end
					elseif ChamsType == "Wireframe" then
						local Ad = Part:FindFirstChild("Chams")
							or CreateAdornment(Part, "Wireframe", MainColor, 0, 1)

						Ad.Color3 = MainColor
						Ad:Clear()

						local Corners = Nocturnal:Corners(Part)
						local Edges = Nocturnal.Edges
						local Points = {}

						for k = 1, #Edges do
							local E = Edges[k];
							Points[#Points + 1] = Corners[E[1]];
							Points[#Points + 1] = Corners[E[2]];
						end

						Ad:AddLines(Points);
					elseif ChamsType == "Highlight" then
						local Char = Entry.PlayerInstance.Character
						if not Char then continue end

						local Existing = Char:FindFirstChild("Chams")
						if Existing and Existing:IsA("Highlight") then
							Existing.FillColor = MainColor
							Existing.OutlineColor = GlowColor
							Existing.FillTransparency = Trans
						else
							local Highlight = InstanceNew("Highlight", Char);
							Highlight.Name = "Chams";
							Highlight.FillColor = MainColor;
							Highlight.OutlineColor = GlowColor;
							Highlight.FillTransparency = Trans;
							Highlight.Adornee = Char;
						end;
					end;
				end;
			end;
        end;
    end);
end;

--// Antiaim Thread
do
    local Old, Rotation: any;
    Rotation = 0;
    
    Insert(Nocturnal.Connections, RunService.RenderStepped:Connect(function(DeltaTime: number)
		if not Library.Flags["aa.enabled"] then return end;

        if Nocturnal:Alive() then
            local RootPart: Instance = LocalPlayer.Character.PrimaryPart;
            local JitterAmount: number = Library.Flags["aa.jitter"];
            local Method: string = Library.Flags["aa.yaw"];
            local Roll: number = Library.Flags["aa.ud"] and Rad(180) or 0;

            Switch(Method, {
                Spin = function()
                    Rotation += JitterAmount;
                    RootPart.CFrame = CFrameNew(RootPart.Position) * CFrameAngles(0, Rotation, Roll);
                end,

                Jitter = function()
                    local Delta: number = JitterAmount;
                    if Random() < 0.5 then Delta = -Delta end;

                    Rotation += Delta;

                    RootPart.CFrame = CFrameNew(RootPart.Position) * CFrameAngles(0, Rotation, Roll);
                end,

                Backward = function()
                    RootPart.CFrame = CFrameNew(RootPart.Position) * CFrameAngles(0, Pi, Roll);
                end,

                Freestanding = function()
                    RootPart.CFrame = CFrameNew(RootPart.Position) * CFrameAngles(0, Rad( Nocturnal:GetFreestandYaw() ), Roll);
                end
            }, function() end);
        end 
    end))
end;


--// ESP Thread
do
    CreateThread(function()
        while Wait() do
            if not Environment().Nocturnal then break end;
            if not Nocturnal.LoadComplete then continue end;

            local Flags = Library.Flags;
            local Enemy = Nocturnal.Sense.teamSettings.enemy;

            Enemy.enabled = Flags["esp.enabled"];

            Enemy.box = Flags["esp.box"];
            Enemy.boxColor[1] = Flags["esp.box.color"];

            Enemy.boxFill = Flags["esp.fill"];
            Enemy.boxFillColor[1] = Flags["esp.fill.color"];

            Enemy.healthBar = Flags["esp.health"];
            Enemy.healthyColor = Flags["esp.health.color"];

            Enemy.name = Flags["esp.name"];
            Enemy.nameColor[1] = Flags["esp.name.color"];

            Enemy.skeleton = Flags["esp.skeleton"];
            Enemy.skeletonColor[1] = Flags["esp.skeleton.color"];

            Enemy.distance = Flags["esp.distance"];
            Enemy.distanceColor[1] = Flags["esp.distance.color"];

            Enemy.offScreenArrow = Flags["esp.arrow"];
            Enemy.offScreenArrowColor[1] = Flags["esp.arrow.color"];

			Enemy.chams = Flags["chams.enabled"] and Flags["chams.method"] == "Drawing";
			Enemy.chamsFillColor[1] = Flags["chams.color"];
        end;
    end);
end;

--// Queue
CreateThread(function(): ()
    queue_on_teleport([[
        repeat task.wait() until game:IsLoaded();
        repeat task.wait() until game:GetService("Players").LocalPlayer:FindFirstChild("PlayerScripts");

        task.delay(10, function()
            loadfile("src.lua")();
        end);
    ]]);
end);

--// Workspace hooks
do
    local Old;

    Old = hookmetamethod(workspace, "__namecall", newcclosure(function(...: any)
        local Method: string = getnamecallmethod();
        local Arguments: any = Pack(...); --// Pack preserves nils, as {...} does NOT!
        local Self: Instance = Arguments[1];
		local Option: string = Library.Flags["silent.mode"];

		--// I do not dare to use Switch(); in this
        if Library.Flags["rage.silent"] and Self == workspace and not checkcaller() then

            --// Modern Raycast method
            if Method == "Raycast" and Option == Method then
                if Nocturnal:IsValid(Arguments, Nocturnal.RayParameters.Raycast) then
                    local RayOrigin: Vector3 = Arguments[2]
                    local PlayerIndex, HitPart = Nocturnal:FindBestTarget();

                    if HitPart then
                        Arguments[3] = Nocturnal:DirectAt(RayOrigin, HitPart.Position);

                        return Old(Unpack(Arguments));
                    end
                end

            --// Deprecated FindPartOnRay methods
            elseif (Method == "FindPartOnRay" or Method == "findPartOnRay") and Option:lower() == Method:lower() then
                if Nocturnal:IsValid(Arguments, Nocturnal.RayParameters.FindPartOnRay) then
                    local RayToCast: Ray = Arguments[2]
                    local PlayerIndex, HitPart = Nocturnal:FindBestTarget();

                    if HitPart then
                        local RayOrigin: Vector3 = RayToCast.Origin
                        local RayDirection: Vector3 = Nocturnal:DirectAt(RayOrigin, HitPart.Position)
                        Arguments[2] = Ray.new(RayOrigin, RayDirection)

                        return Old(Unpack(Arguments));
                    end
                end

            elseif Method == "FindPartOnRayWithIgnoreList" and Option == Method then
                if Nocturnal:IsValid(Arguments, Nocturnal.RayParameters.FindPartOnRayWithIgnoreList) then
                    local RayToCast: Ray = Arguments[2];
                    local PlayerIndex, HitPart = Nocturnal:FindBestTarget();

                    if HitPart then
                        local RayOrigin: Vector3 = RayToCast.Origin
                        local RayDirection: Vector3 = Nocturnal:DirectAt(RayOrigin, HitPart.Position)
                        Arguments[2] = Ray.new(RayOrigin, RayDirection)

                        return Old(Unpack(Arguments));
                    end
                end

            elseif Method == "FindPartOnRayWithWhitelist" and Option == Method then
                if Nocturnal:IsValid(Arguments, Nocturnal.RayParameters.FindPartOnRayWithWhitelist) then
                    local RayToCast: Ray = Arguments[2]
                    local PlayerIndex, HitPart = Nocturnal:FindBestTarget();

                    if HitPart then
                        local RayOrigin: Vector3 = RayToCast.Origin
                        local RayDirection: Vector3 = Nocturnal:DirectAt(RayOrigin, HitPart.Position)
                        Arguments[2] = Ray.new(RayOrigin, RayDirection)

                        return Old(Unpack(Arguments));
                    end;
                end;
            end;
        end;

        return Old(...);
    end));
end;

local Old;
Old = DetourFn(Environment().Nocturnal.Unload, function(...)
	for Index, Connection in Nocturnal.Connections do
		if Connection and Connection.Disconnect then
			Connection:Disconnect();
		end;
	end;

    Nocturnal.LoadComplete = false;

	return Old(...);
end);

Nocturnal.LoadComplete = true;
