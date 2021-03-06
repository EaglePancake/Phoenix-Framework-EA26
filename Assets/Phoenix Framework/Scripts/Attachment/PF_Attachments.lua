-- Register the behaviour
behaviour("PF_Attachments")

-- Local Tables
local attachmentPointsTable = {}

local AttachmentUI = {
	RefreshMenuText = function (self)
		if self.weaponChanged == false then return end

		local data = Player.actor.activeWeapon.gameObject.GetComponent(DataContainer)
		local weaponName = PhoenixData.GetString(data, "weaponName", false, "Cool Gun")

		if string.len(weaponName) >= 8 then
			self.weaponNameText.text = "<smallcaps>" .. weaponName .. "</smallcaps> <color=#808080ff><size=20>By: " .. PhoenixData.GetString(data, "creatorName", false, "Swag dude's gun")
		else
			self.weaponNameText.text = '<align="left"><smallcaps>' .. weaponName .. '</smallcaps>' .. '\n <align="right"><color=#808080ff><size=20>By: ' .. PhoenixData.GetString(data, "creatorName", false, "Swag dude's gun")
		end

		-- self.weaponNameText.text = "<smallcaps>" .. PhoenixData.GetString(data, "weaponName", false, "Cool Gun") .. "</smallcaps> <color=#808080ff><size=20>By: " .. PhoenixData.GetString(data, "creatorName", false, "Swag dude's gun")
		self.historyHeaderText.text = PhoenixData.GetString(data, "weaponHistoryTitle", false, "Cool Gun's History")
		self.historyDescText.text = PhoenixData.GetString(data, "weaponHistory", false, "This is a very cool gun")
		self.statsHeaderText.text = weaponName .. " Stats"

		-- Menu UI stuffs... this is so painful....
		-- Recoil Stats
		local recoilRange = PhoenixData.GetVector(data, "recoilRange", false, Vector3(0,1,0))
		self.statsRecoilSlider.minValue = recoilRange.x 
		self.statsRecoilSlider.maxValue = recoilRange.y
		self.statsRecoilLeft.text = tostring(Mathf.Floor(recoilRange.x * 10) / 10)
		self.statsRecoilRight.text = tostring(Mathf.Floor(recoilRange.y * 10) / 10)

		-- Spread
		local spreadRange = PhoenixData.GetVector(data, "spreadRange", false, Vector3(0,1,0))
		self.statsSpreadSlider.minValue = spreadRange.x
		self.statsSpreadSlider.maxValue = spreadRange.y
		self.statsSpreadLeft.text = tostring(Mathf.Floor(spreadRange.x * 10) / 10)
		self.statsSpreadRight.text = tostring(Mathf.Floor(spreadRange.y * 10) / 10)

		-- Move Speed
		local moveSpeedRange = PhoenixData.GetVector(data, "moveSpeedRange", false, Vector3(0,1,0))
		self.statsMoveSpeedSlider.minValue = moveSpeedRange.x
		self.statsMoveSpeedSlider.maxValue = moveSpeedRange.y
		self.statsMoveSpeedLeft.text = tostring(Mathf.Floor(moveSpeedRange.x * 10) / 10)
		self.statsMoveSpeedRight.text = tostring(Mathf.Floor(moveSpeedRange.y * 10) / 10)

		-- Fire Rate
		local fireRateRange = PhoenixData.GetVector(data, "fireRateRange", false, Vector3(0,1,0))
		self.statsFireRateSlider.minValue = fireRateRange.x
		self.statsFireRateSlider.maxValue = fireRateRange.y
		self.statsFireRateLeft.text = tostring(Mathf.Floor(fireRateRange.x * 10) / 10)
		self.statsFireRateRight.text = tostring(Mathf.Floor(fireRateRange.y * 10) / 10)

		local damageRange = PhoenixData.GetVector(data, "damageRange", false, Vector3(0,1,0))
		self.statsDamgeSlider.minValue = damageRange.x
		self.statsDamgeSlider.maxValue = damageRange.y
		self.statsDamgeLeft.text = tostring(Mathf.Floor(damageRange.x * 10) / 10)
		self.statsDamgeRight.text = tostring(Mathf.Floor(damageRange.y * 10) / 10)

		-- SFX source
		self.sfxSource = self.targets.sfxSource.gameObject.GetComponent(AudioSource)

		self.weaponChanged = false
	end,
}

local AttachmentBase = {
	SetupKeybinds = function (self)
		self.attachmentKeybind = PhoenixInput.AttachmentMenuKeybind()
		self.firemodeKeybind = PhoenixInput.FiremodeKeybind()
		self.railToggleKeybind = PhoenixInput.RailmountToggleKeybind()
	end,

	CloneAttachmentPanel = function (self)

	end,

	SetupEvents = function (self)
		self.script.AddValueMonitor("ReturnIsPaused", "OnGamePaused")
	end,

	StoreComponents = function (self)
		-- variables I have to declare
		self.transitionMultiplier = 1
		self.slowMotionMultiplier = 1

		self.changedMag = false

		self.isNight = self:isPlayingAtNight()

		self.FPCamera = PlayerCamera.fpCamera
		-- self.baseFov = PhoenixMath.SetupHorizontalFOV(GameObject.Find("Field Of View").GetComponentInChildren(Slider).value)
		self.currentFov = self.baseFov

		self.randomAttachments = self.script.mutator.GetConfigurationBool("bool_randomAttachments")
		self.autoReload = self.script.mutator.GetConfigurationBool("bool_AutoReload") 
		self.realtimeMenu = self.script.mutator.GetConfigurationBool("bool_RealtimeMenu")

		self.attachmentPanel = self.targets.attachmentPanel.gameObject
		ScriptedBehaviour.GetScript(self.attachmentPanel):Initialise()

		-- Base header and canvas animator
		self.menuUI = self.targets.MenuUI.gameObject.GetComponent(Animator)
		self.weaponNameText = self.targets.weaponNameText.gameObject.GetComponent(TextMeshProUGUI)
		self.historyHeaderText = self.targets.historyHeaderText.gameObject.GetComponent(TextMeshProUGUI)
		self.historyDescText = self.targets.historyDescText.gameObject.GetComponent(TextMeshProUGUI)
		self.statsHeaderText = self.targets.statsHeaderText.gameObject.GetComponent(TextMeshProUGUI)

		-- Stats Panel
		self.statsRecoil = self.targets.statsRecoil.gameObject.GetComponent(DataContainer)
		self.statsSpread = self.targets.statsSpread.gameObject.GetComponent(DataContainer)
		self.statsMoveSpeed = self.targets.statsMoveSpeed.gameObject.GetComponent(DataContainer)
		self.statsFireRate = self.targets.statsFireRate.gameObject.GetComponent(DataContainer)
		self.statsDamge = self.targets.statsDamge.gameObject.GetComponent(DataContainer)

		-- FUCK I HATE THIS, its for the stats panel
		-- Recoil
		self.statsRecoilSlider = self.statsRecoil.GetGameObject("slider").GetComponent(Slider)
		self.statsRecoilLeft = self.statsRecoil.GetGameObject("left").GetComponent(TextMeshProUGUI)
		self.statsRecoilRight = self.statsRecoil.GetGameObject("right").GetComponent(TextMeshProUGUI)

		-- Spread
		self.statsSpreadSlider = self.statsSpread.GetGameObject("slider").GetComponent(Slider)
		self.statsSpreadLeft = self.statsSpread.GetGameObject("left").GetComponent(TextMeshProUGUI)
		self.statsSpreadRight = self.statsSpread.GetGameObject("right").GetComponent(TextMeshProUGUI)

		-- Movement Speed
		self.statsMoveSpeedSlider = self.statsMoveSpeed.GetGameObject("slider").GetComponent(Slider)
		self.statsMoveSpeedLeft = self.statsMoveSpeed.GetGameObject("left").GetComponent(TextMeshProUGUI)
		self.statsMoveSpeedRight = self.statsMoveSpeed.GetGameObject("right").GetComponent(TextMeshProUGUI)

		-- Fire Rate
		self.statsFireRateSlider = self.statsFireRate.GetGameObject("slider").GetComponent(Slider)
		self.statsFireRateLeft = self.statsFireRate.GetGameObject("left").GetComponent(TextMeshProUGUI)
		self.statsFireRateRight = self.statsFireRate.GetGameObject("right").GetComponent(TextMeshProUGUI)

		-- Damge
		self.statsDamgeSlider = self.statsDamge.GetGameObject("slider").GetComponent(Slider)
		self.statsDamgeLeft = self.statsDamge.GetGameObject("left").GetComponent(TextMeshProUGUI)
		self.statsDamgeRight = self.statsDamge.GetGameObject("right").GetComponent(TextMeshProUGUI)

		-- Attachment point stuff
		self.attachmentPointNest = self.targets.attachmentPointNest.gameObject.transform
		self.attachmentPointInstance = self.targets.attachmentPointInstance

		-- Night time stuff
		-- self.nightLight = self.targets.nightLight.gameObject

		-- Spawns the attachment points, and willspawn more if gun has more then currently spawned.. not here doe
		for i = 1, 10 do
			go = GameObject.Instantiate(self.attachmentPointInstance)
			go.transform.SetParent(self.attachmentPointNest, false)
			attachmentPointsTable[i] = go
			self.script.GetScript(go):Initialise()
		end
	end,

	PlayerStatusCheck = function (self)
		return Player.actor.activeWeapon.isReloading == false 
		and Player.actor.activeWeapon.isUnholstered == true 
		and Player.actor.isInWater == false 
		and Player.actor.isOnLadder == false 
		and GameManager.isPaused == false
	end,

	ToggleMenu = function (self, state)
		local MenuState = {
			["true"] = function (self)
				AttachmentUI.RefreshMenuText(self)
				-- State
				self.menuState = true
				self.menuStateNumber = 1
				self.transitionMultiplier = 1

				self.script.GetScript(m_PhoenixBase.FPSHud):FadeUI(false)

				-- Weapon Animations
				Player.actor.activeWeapon.animator.SetBool("customization", true)
				-- Player.actor.activeWeapon.gameObject.GetComponent(Animator).updateMode = AnimatorUpdateMode.UnscaledTime
				Player.actor.activeWeapon.LockWeapon()

				-- Changes time
				-- Time.timeScale = 0.03125
				Screen.UnlockCursor()
				Input.DisableNumberRowInputs()

				-- Stupid gamehud stuff
				GameManager.hudGameModeEnabled = false
				GameManager.hudPlayerEnabled = false
			end,

			["false"] = function (self)
				self.menuState = false
				self.menuStateNumber = 0
				self.transitionMultiplier = 9.5

				self.script.GetScript(m_PhoenixBase.FPSHud):FadeUI(true)

				-- Weapon Animations
				Player.actor.activeWeapon.animator.SetBool("customization", false)
				-- Player.actor.activeWeapon.gameObject.GetComponent(Animator).updateMode = AnimatorUpdateMode.Normal
				Player.actor.activeWeapon.UnlockWeapon()

				-- Changes time
				-- Time.timeScale = 1
				Screen.LockCursor()
				Input.EnableNumberRowInputs()

				if self.autoReload and Player.actor.activeWeapon.ammo == 0 then
					Player.actor.activeWeapon.Reload()
				end

				-- Stupid gamehud stuff
				if Player.actor == nil or Player.actor.isDead then return end
				GameManager.hudGameModeEnabled = true
				GameManager.hudPlayerEnabled = true
			end,
		}

		MenuState[tostring(state)](self)
	end,

	RefreshPoints = {
		OnEnable = function (self)
			local data = Player.actor.activeWeapon.gameObject.GetComponentsInChildren(DataContainer)
			local dataIndex = 0

			for k,v in ipairs(data) do
			if PhoenixData.GetString(v, "dataType", false, "nahDontGotIt") == "attachmentPoint" then 
				if dataIndex == self.attachmentPointNest.childCount then return end
					-- Gets the UI (Framework) element for the point 
					local go = self.attachmentPointNest.GetChild(dataIndex).gameObject
					go.SetActive(true)

					local pointScript = self.script.GetScript(go.gameObject)
					-- Does point stuff
					pointScript.attachmentBase = self
					pointScript.weaponPoint = v.gameObject
					pointScript.pointIndex = dataIndex + 1

					-- Storage Stuff
					if _G.PhoenixGlobalStorage["SavedAttachments"][tostring(Player.actor.activeWeapon)][tostring(v.gameObject)] == nil then
						_G.PhoenixGlobalStorage["SavedAttachments"][tostring(Player.actor.activeWeapon)][tostring(v.gameObject)] = 1
						pointScript:EquipAttachment(1, false, true)
						if self.randomAttachments then
							pointScript:EquipRandomAttachment()
						end
						Player.actor.activeWeapon.ammo = Player.actor.activeWeapon.maxAmmo
						pointScript:OnWeaponChange()
						dataIndex = 1 + dataIndex
					else
						local saved = _G.PhoenixGlobalStorage["SavedAttachments"][tostring(Player.actor.activeWeapon)][tostring(v.gameObject)]
						-- print("Current Attachment: " .. tostring(_G.PhoenixGlobalStorage["SavedAttachments"][tostring(Player.actor.activeWeapon)][tostring(v.gameObject)]) .. " " .. v.gameObject.name)
						if self.wasDead then
							pointScript:EquipAttachment(1, true, false)
							pointScript:EquipAttachment(saved, false, false)
							Player.actor.activeWeapon.ammo = Player.actor.activeWeapon.maxAmmo
						--	print("FUCK")
						else
							pointScript:EquipAttachment(saved, true, false)
						--	print("FUCK 2")
						end
						pointScript:OnWeaponChange()
	
						-- pluses the index
						dataIndex = 1 + dataIndex
					end
				end
			end

			self.wasDead = false
		end,

		OnDisable = function (self)
			for i = 1, self.attachmentPointNest.childCount do
				self.attachmentPointNest.GetChild(i - 1).gameObject.SetActive(false)
			end
		end,
	}
}

local AttachmentEvents = {
	OnPause = function (self, bool)
		local state = {
		["true"] = function (self) 
			AttachmentBase.ToggleMenu(self, false)
			self.menuUI.gameObject.SetActive(false)
			self.menuUI.gameObject.SetActive(true)
		end, 
		["false"] = function () end,
		}
	state[tostring(bool)](self)
	end,
}
function PF_Attachments:Initialise()
	m_PhoenixAttachment = self

	AttachmentBase.SetupKeybinds(self)
	AttachmentBase.StoreComponents(self)
	AttachmentBase.SetupEvents(self)
	AttachmentBase.RefreshPoints.OnDisable(self)

	PhoenixDebug.Print("PF_Attachments | Initialise", "log")
end

function PF_Attachments:Update()
	if Time.timeScale < 0.02 then return end

	if Input.GetKeyBindButtonDown(KeyBinds.Slowmotion) and self.menuUI.GetFloat("State") ~= 1 and not self.realtimeMenu then
		local SlowmoState = {
			["true"] = 0.2,
			["false"] = 1
		}

		self.isSlowMode = not self.isSlowMode
		self.slowMotionMultiplier = SlowmoState[tostring(self.isSlowMode)]
	end

	if not Player.actor.isDead and not GameManager.isPaused and (self.menuUI.GetFloat("State") ~= 1 or self.menuUI.GetFloat("State") ~= 2) then
		self.menuUI.SetFloat("State", self.menuStateNumber, 0.2 / self.transitionMultiplier, Time.unscaledDeltaTime)

		if not self.realtimeMenu then
			Time.timeScale = PhoenixMath.Normalize(self.menuUI.GetFloat("State"), 1 , 0, 0.0325, 1 * self.slowMotionMultiplier)
		end
		-- FOV changing stuff... decided to cut it since it would be weird to work with
		--self.FPCamera.fieldOfView = PhoenixMath.Normalize(self.menuUI.GetFloat("State"), 1 , 0, 60, self.currentFov)
	end
	
	if Input.GetKeyDown(self.attachmentKeybind) and AttachmentBase.PlayerStatusCheck() then
		AttachmentBase.ToggleMenu(self, not self.menuState)
	end

	if Input.GetKeyDown(self.firemodeKeybind) and AttachmentBase.PlayerStatusCheck() and self.currentReceiver ~= nil then
		self:ChangeFiremode()
	end

	if Input.GetKeyDown(self.railToggleKeybind) and AttachmentBase.PlayerStatusCheck() then
		self.rail.SetActive(not self.rail.activeSelf)
	end

	if Input.GetKeyBindButtonDown(KeyBinds.OpenLoadout) then
		AttachmentBase.ToggleMenu(self, false)
		self.wasDead = true
	end
end

function PF_Attachments:OnDisable()
	if Player.actor == nil or Player.actor.isDead then return end

	self.currentReceiver = nil
	self.rail = nil

	AttachmentBase.ToggleMenu(self, false)
	AttachmentBase.RefreshPoints.OnDisable(self)

	if self.realtimeMenu then return end
	-- Slowmode stuff
	local SlowmoState = {
		["true"] = 0.2,
		["false"] = 1
	}
	Time.timeScale = SlowmoState[tostring(self.isSlowMode)]
end

function PF_Attachments:OnEnable()
	if Player.actor == nil or Player.actor.isDead  then return end

	-- Sets up storage stuff on weapon switch
	if _G.PhoenixGlobalStorage["SavedAttachments"][tostring(Player.actor.activeWeapon)] == nil then
		_G.PhoenixGlobalStorage["SavedAttachments"][tostring(Player.actor.activeWeapon)] = {}
	end

	Player.actor.activeWeapon.animator.SetBool("customization", false)
	Player.actor.activeWeapon.gameObject.GetComponent(Animator).updateMode = AnimatorUpdateMode.Normal

	self.weaponChanged = true
	m_AttachmentPanel:OnWeaponChange()

	AttachmentBase.ToggleMenu(self, false)
	AttachmentBase.RefreshPoints.OnEnable(self)

	if self.realtimeMenu then return end
	-- Slowmode stuff
	if Time.timeScale <= 0.3 then self.isSlowMode = true else self.isSlowMode = false end
	local SlowmoState = {
		["true"] = 0.2,
		["false"] = 1
	}
	self.slowMotionMultiplier = SlowmoState[tostring(self.isSlowMode)]
end

function PF_Attachments:RefreshReceiver(mag, receiverAttachment, attachmentPoint)
	local assignSound = {
		["truetrue"] = function (self) -- Loud Auto
			--print("Loud Auto")
			Player.actor.activeWeapon.gameObject.GetComponent(AudioSource).clip = self.currentReceiver.GetComponent(DataContainer).GetAudioClip("loudAuto")
		end,
		["truefalse"] = function (self) -- Loud Single
			--print("Loud Single")
			Player.actor.activeWeapon.gameObject.GetComponent(AudioSource).clip = self.currentReceiver.GetComponent(DataContainer).GetAudioClip("loudSingle")
		end,
		["falsetrue"] = function (self) -- Suppressed Auto
			--print("Suppressed Auto")
			Player.actor.activeWeapon.gameObject.GetComponent(AudioSource).clip = self.currentReceiver.GetComponent(DataContainer).GetAudioClip("suppressedAuto")
		end,
		["falsefalse"] = function (self) -- Suppressed Single
			--print("Suppressed Single")
			Player.actor.activeWeapon.gameObject.GetComponent(AudioSource).clip = self.currentReceiver.GetComponent(DataContainer).GetAudioClip("suppressedSingle")
		end,
	}

	if (mag) then -- If called from mag
		--print("Changed receiver through mag")
		-- stores receiver point to variable
		local receiverPoint = Player.actor.activeWeapon.gameObject.GetComponent(DataContainer).GetGameObject("receiverPoint").gameObject
		local casingPoint = Player.actor.activeWeapon.gameObject.GetComponent(DataContainer).GetGameObject("casingPoint").gameObject

		-- Disable all receivers
		for i = 1 , receiverPoint.transform.childCount do
			receiverPoint.transform.GetChild(i - 1).gameObject.SetActive(false)	
		end

		-- Disable all casing particles
		for i = 1, casingPoint.transform.childCount do
			casingPoint.transform.GetChild(i - 1).gameObject.SetActive(false)
		end

		-- Get new receiver
		self.currentReceiver = receiverAttachment.gameObject
		self.currentReceiver.SetActive(true)
		self.currentReceiver.GetComponent(DataContainer).GetGameObject("casingParticle").gameObject.SetActive(true)
		Player.actor.activeWeapon.cooldown = self.currentReceiver.GetComponent(DataContainer).GetFloat("fireRate")
		Player.actor.activeWeapon.isAuto = self.currentReceiver.GetComponent(DataContainer).GetBool("allowAutoShot")
		m_HudBase:FiremodeText()

		-- attachmentPoint:ModularAnimator(paramName, paramValue)

		-- PROJECTILES STUFF
		-- Player.actor.activeWeapon.SetProjectilePrefab(receiverAttachment.gameObject.GetComponent(DataContainer).GetGameObject("projectile"))
		assignSound[tostring(Player.actor.activeWeapon.isLoud) .. tostring(Player.actor.activeWeapon.isAuto)](self)

	else -- If called from muzzle or firemode change
		--print("Changed receiver through muzzle")
		assignSound[tostring(Player.actor.activeWeapon.isLoud) .. tostring(Player.actor.activeWeapon.isAuto)](self)
	end
end

-- Made by Chai
function PF_Attachments:isPlayingAtNight()
	local nightGameObject = GameObject.Find("Night")
	if(nightGameObject ~= nil) then
		return true
	else
		return false
	end
end

function PF_Attachments:ChangeFiremode()
	local assignSound = {
		["truetrue"] = function (self) -- Loud Auto
			--print("Loud Auto")
			Player.actor.activeWeapon.gameObject.GetComponent(AudioSource).clip = self.currentReceiver.GetComponent(DataContainer).GetAudioClip("loudAuto")
		end,
		["truefalse"] = function (self) -- Loud Single
			--print("Loud Single")
			Player.actor.activeWeapon.gameObject.GetComponent(AudioSource).clip = self.currentReceiver.GetComponent(DataContainer).GetAudioClip("loudSingle")
		end,
		["falsetrue"] = function (self) -- Suppressed Auto
			--print("Suppressed Auto")
			Player.actor.activeWeapon.gameObject.GetComponent(AudioSource).clip = self.currentReceiver.GetComponent(DataContainer).GetAudioClip("suppressedAuto")
		end,
		["falsefalse"] = function (self) -- Suppressed Single
			--print("Suppressed Single")
			Player.actor.activeWeapon.gameObject.GetComponent(AudioSource).clip = self.currentReceiver.GetComponent(DataContainer).GetAudioClip("suppressedSingle")
		end,
	}

	if self.currentReceiver.GetComponent(DataContainer).GetBool("allowSingleShot") and self.currentReceiver.GetComponent(DataContainer).GetBool("allowAutoShot") then
		Player.actor.activeWeapon.isAuto = not Player.actor.activeWeapon.isAuto
		Player.actor.activeWeapon.animator.SetTrigger("swapfiremode")
		m_HudBase:FiremodeText()
		assignSound[tostring(Player.actor.activeWeapon.isLoud) .. tostring(Player.actor.activeWeapon.isAuto)](self)
	end
end

function PF_Attachments:ReturnIsPaused() return GameManager.isPaused end

function PF_Attachments:OnGamePaused(bool) AttachmentEvents.OnPause(self, bool) end

function PF_Attachments:RefreshAttachmentPoints() AttachmentBase.RefreshPoints.OnEnable(self) end