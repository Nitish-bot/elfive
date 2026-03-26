function loadSound(_file)
  -- apart from path, file can also be Decoder or SoundData (love2d objects)
  local success, result = pcall(love.audio.newSource, _file, "static")

  if success then
    local sound = {}
    sound._source = result
    -- Can consider storing playing and paused as
    -- internal state if the engine state doesnt suffice
    sound.speed = 1

    function sound:start()
      self._source:play()
    end

    function sound:play()
      self._source:play()
    end

    function sound:pause()
      self._source:pause()
    end

    function sound:stop()
      self._source:stop()
    end

    function sound:loop(loopState)
      if type(loopState) ~= "boolean" then
        error("sound:loop(loopState) expects loopState to be boolean")
      end

      self._source:setLooping(loopState)
    end

    function sound:isPlaying()
      return self._source:isPlaying()
    end

    return sound
  else
    error("Failed to load sound from '" .. _file .. "': " .. tostring(result))
  end
end
