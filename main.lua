json = require "json"

function interpret(L, context)
    if type(L) ~= "table" then
        return
    end
    
    local command = L["kind"]
    local variables = context or {}

    if command == "Print" then
        local termo = interpret(L["value"], variables)
        print(tostring(termo))
        return
    elseif command == "Let" then
        local value = interpret(L["value"], variables)
        variables[L["name"]["text"]] = value
        return interpret(L["next"], variables)
    elseif command == "Var" then
        local value = variables[L["text"]]
        return value
    elseif command == "If" then
        if interpret(L["condition"], variables) then
            return interpret(L["then"], variables)
        else 
            return interpret(L["otherwise"], variables)
        end
    elseif command == "Call" then
        local callee = interpret(L["callee"], variables)
        local newVariables = {}

        for i, arg in pairs(variables) do
            newVariables[i] = arg
        end

        for k, v in pairs(L["arguments"]) do
            newVariables[variables[L["callee"]["text"]]["parameters"][k]["text"]] = interpret(v, variables)
        end

        return interpret(callee["value"], newVariables)
    elseif command == "Function" then
        return L
    elseif command == "Str" then
        return L["value"]
    elseif command == "Int" then
        return L["value"]
    elseif command == "Bool" then
        return L["value"]
    elseif command == "Binary" then
        local operator = L["op"]
        local lhs = interpret(L["lhs"], variables)
        local rhs = interpret(L["rhs"], variables)
        
        if operator == "Eq" then
            return lhs == rhs
        elseif operator == "Add" then
            return lhs + rhs
        elseif operator == "Sub" then
            return lhs - rhs
        elseif operator == "Or" then
            return lhs or rhs
        elseif operator == "Lt" then
            return lhs < rhs
        else
            print("Unknown operator: " .. operator)
            os.exit()
        end
    elseif command ~= nil then
        print("Unknown command: " .. command)
        os.exit()
    end
end

input = arg[1] or "/var/rinha/source.rinha.json"

file = io.open(input, "r")
if file == nil then
    print("Não foi possível ler \"" .. input .. "\"")
    os.exit()
end

content = file:read "*a"

for k, v in pairs(json.decode(content)) do
    interpret(v, {})
end
