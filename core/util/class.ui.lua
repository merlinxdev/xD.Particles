XD = { NUI = false }
XD.XD_NUI = function(parth,data,mouse)
    if mouse ~= nil then
        XD.NUI = not XD.NUI
        SetNuiFocus(mouse,mouse)
    end

    SendNuiMessage(json.encode({ 
        type = parth,
        data = data,
    }))

    return XD.NUI
end