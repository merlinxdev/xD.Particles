ParticlesClass = {}
ParticlesClass.__index = ParticlesClass

function ParticlesClass.new(particleList)
    assert(type(particleList) == "table", "particleList must be a table") -- ตรวจสอบ input
    local instance = setmetatable({},ParticlesClass)
    instance.particles = particleList
    instance.coords = vec3(0,0,0).xyz
    instance.processedParticles = instance:getParticle()
    instance.current = {}
    instance.nextParticle = 1
    instance.autoPlay = false
    instance.particleonPlay = false
    return instance
end

function ParticlesClass:getParticles()
    return self.processedParticles[self.nextParticle][1] , self.processedParticles[self.nextParticle][2]
end

function ParticlesClass:UpdateNUI()
    local dict , name = self:getParticles()
    XD.XD_NUI("XD_NUI_UPDATE",{dict = dict , name = name},nil)
end

function ParticlesClass:getParticle()
    local tablex = {}
    for k,v in pairs(self.particles) do
        for j,i in ipairs(v) do 
            table.insert(tablex,{k,i})
        end
    end
    return tablex
end

function ParticlesClass:setObject(coords)
    self.coords = coords
end

function ParticlesClass:getParticles()
    return self.processedParticles[self.nextParticle][1] , self.processedParticles[self.nextParticle][2]
end

function ParticlesClass:autoPlayParticles()
    self.autoPlay = not self.autoPlay
    CreateThread(function()
        while self.autoPlay do
            self.nextParticle = self.nextParticle + 1
            if self.nextParticle > #self.processedParticles then
                self.nextParticle = 1
            end
            self:UpdateNUI()
            Citizen.Wait(1500)
        end
    end)
end

function ParticlesClass:Next()
    self.nextParticle = self.nextParticle + 1
    if self.nextParticle > #self.processedParticles then
        self.nextParticle = 1
    end
    self.current.dict = self.processedParticles[self.nextParticle][1]
    self.current.name = self.processedParticles[self.nextParticle][2]
end

function ParticlesClass:Prev()
    self.nextParticle = self.nextParticle - 1
    if self.nextParticle < 1 then
        self.nextParticle = #self.processedParticles
    end
    self.current.dict = self.processedParticles[self.nextParticle][1]
    self.current.name = self.processedParticles[self.nextParticle][2]
end

function ParticlesClass:showText()
    local TextShow = "Dict: " .. self.current.dict .." Name : "..self.current.name
    self:DrawText3D(self.coords,TextShow)
end

function ParticlesClass:playParticle(particleDict,particleName,size)
    self:loadParticle(particleDict)
    UseParticleFxAssetNextCall(particleDict)
    StartParticleFxNonLoopedAtCoord(particleName, self.coords, 0.0, 0.0, 0.0, size or 1.0, false, false, false)
end

function ParticlesClass:loadParticle(particleDict)
    RequestNamedPtfxAsset(particleDict)
    while not HasNamedPtfxAssetLoaded(particleDict) do
        Citizen.Wait(0)
    end
end

function ParticlesClass:DrawText3D(coords, text)
    local onScreen,_x,_y=World3dToScreen2d(coords.x,coords.y,coords.z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    if onScreen then
        SetTextScale(0.19, 0.19)
        SetTextFont(0)
        SetTextProportional(1)
        -- SetTextScale(0.0, 0.55)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 55)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

